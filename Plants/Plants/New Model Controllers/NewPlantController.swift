//
//  NewPlantController.swift
//  Plants
//
//  Created by Alexander Supe on 05.02.20.
//

import Foundation
import CoreData

class NewPlantController {
    let baseURL = URL(string: "https://plan-58e26.firebaseio.com/")!
    typealias CompletionHandler = (Error?) -> Void
    
    static var shared = NewPlantController()
    let token = UserController.shared.authToken?.token ?? UUID().uuidString
    
    init() { read() }
    
    func create(newPlant: NewPlant, completion: @escaping CompletionHandler = { _ in }) {
        let uuid = newPlant.id ?? UUID()
        let requestURL = baseURL.appendingPathComponent(token)
        var request = URLRequest(url: requestURL.appendingPathComponent(uuid.uuidString).appendingPathExtension("json"))
        request.httpMethod = "PUT"
        
        do {
            guard var representation = newPlant.newPlantRepresentation else { completion(NSError()); return }
            representation.id = uuid.uuidString
            newPlant.id = uuid
            try CoreDataStack.shared.save()
            request.httpBody = try JSONEncoder().encode(representation)
        } catch {
            print("Encoding error \(newPlant): \(error)")
            DispatchQueue.main.async { completion(error) }
            return
        }
        
        URLSession.shared.dataTask(with: request) { _, _, error in
            if let error = error {
                print("Error PUTting to server: \(error)")
                DispatchQueue.main.async { completion(error) }
                return
            }
            DispatchQueue.main.async { completion(nil) }
        }.resume()
    }
    
    func read(completion: @escaping CompletionHandler = { _ in }) {
        let requestURL = baseURL.appendingPathComponent(token)
        let request = URLRequest(url: requestURL.appendingPathExtension("json"))
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print("Error fetching: \(error)")
                DispatchQueue.main.async { completion(error) }
                return
            }
            
            guard let data = data else {
                print("No data return by data entry")
                DispatchQueue.main.async { completion(NSError()) }
                return
            }
            
            do {
                let newPlantRepresentations = Array(try JSONDecoder().decode([String : NewPlantRepresentation].self, from: data).values)
                try self.update(with: newPlantRepresentations)
                DispatchQueue.main.async { completion(nil) }
            } catch {
                print("Error decoding or storing representations: \(error)")
                DispatchQueue.main.async { completion(error) }
            }
        }.resume()
    }
    
    func update(_ newPlant: NewPlant, nickname: String?, location: String?, wateredDate: Date?, image: Data?, h2oFrequency: Double?) {
        let nickname = nickname ?? newPlant.nickname; let id = newPlant.id; let location = location ?? newPlant.location; let wateredDate = wateredDate ?? newPlant.wateredDate; let image = image ?? newPlant.image; let h2oFrequency = h2oFrequency ?? newPlant.h2oFrequency
        delete(newPlant)
        CoreDataStack.shared.mainContext.delete(newPlant)
        do {
            try CoreDataStack.shared.mainContext.save()
        }
        catch {
            CoreDataStack.shared.mainContext.reset()
            NSLog("Error saving managed object context: \(error)")
        }
        create(newPlant: NewPlant(nickname: nickname ?? "", id: id ?? UUID(), wateredDate: wateredDate ?? Date(), image: image ?? Data(), location: location ?? "", h2oFrequency: h2oFrequency))
        
    }
    
    func delete(_ newPlant: NewPlant, completion: @escaping CompletionHandler = { _ in }) {
        guard let uuid = newPlant.id else { completion(NSError()); return }
        let requestURL = baseURL.appendingPathComponent(token).appendingPathComponent(uuid.uuidString).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { _, response, error in
            print(response!)
            DispatchQueue.main.async { completion(error) }
        }.resume()
    }
    
    // MARK: - Internal methods
    private func update(with representations: [NewPlantRepresentation]) throws {
        guard representations.isEmpty == false else { return }
        let identifiersToFetch = representations.compactMap { UUID(uuidString: $0.id) }
        let representationsByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, representations))
        var toCreate = representationsByID
        let fetchRequest: NSFetchRequest<NewPlant> = NewPlant.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier IN %@", identifiersToFetch)
        let context = CoreDataStack.shared.container.newBackgroundContext()
        context.perform {
            do { let existingPlants = try context.fetch(fetchRequest)
                for plant in existingPlants {
                    guard let id = plant.id,
                        let representation = representationsByID[id] else { continue }
                    self.updateData(newPlant: plant, with: representation)
                    toCreate.removeValue(forKey: id)
                }
                for representation in toCreate.values { NewPlant(newPlantRepresentation: representation, context: context) }
            }
            catch { print("Error fetching plants for UUIDs: \(error)") }
        }
        try CoreDataStack.shared.save(context: context)
    }
    
    private func updateData(newPlant: NewPlant, with representation: NewPlantRepresentation) {
        newPlant.nickname = representation.nickname
        newPlant.id = UUID(uuidString: representation.id)
        newPlant.location = representation.location
        newPlant.image = representation.image
        newPlant.h2oFrequency = representation.h2oFrequency
        newPlant.wateredDate = representation.wateredDate
    }
}

