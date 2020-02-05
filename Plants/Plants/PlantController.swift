//
//  File.swift
//  Plants
//
//  Created by Lambda_School_Loaner_219 on 2/3/20.
//

import Foundation
import CoreData



class PlantController {
    
    var myPlants = [PlantRepresentation]()
    
    static var shared = PlantController() 
    
    let baseURL = URL(string: "https://water-my-plants-1.herokuapp.com/api")!
    // MARK: - Set Functions
    
    func createPlantInServer(plant: Plant, completion: @escaping() -> Void = {}) {
        let token = String(describing: UserController.shared.authToken?.token)
        
        let speciesId = SpeciesController.shared.createSpecies(h2oFrequency: plant.h2oFrequency, image: plant.image) { (error) in
                DispatchQueue.main.async { completion() }
                return
        }
        guard let speciesId2 = speciesId, let nickname = plant.nickname, let location = plant.location, let image = plant.image, let wateredDate = plant.wateredDate else { return }
        
        let plant2 = Plant(speciesId: Double(speciesId2), nickname: nickname, location: location, image: image, id: plant.id, h2oFrequency: plant.h2oFrequency, wateredDate: wateredDate)
        
        let requestURL = baseURL.appendingPathComponent("/plants")
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.put.rawValue
        request.setValue(token, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard var plantRepresentation = plant2.plantRepresentation else {
            NSLog("Error with request URL")
            completion()
            return
        }
        
        do {
            request.httpBody = try JSONEncoder().encode(plantRepresentation)
        } catch {
            NSLog("Error encoding: \(error)")
            completion()
            return
        }
        
        URLSession.shared.dataTask(with: request){ data, _, error in
            
            if let error = error {
                NSLog("Error with data task: \(error)")
                completion()
                return
            }
            
            guard let data = data else {
                NSLog("Bad Data")
                return
            }
            
            JSONDecoder().keyDecodingStrategy = .convertFromSnakeCase
            do {
                let plant = try JSONDecoder().decode(PlantRepresentation.self, from: data)
                plantRepresentation.id = plant.id
                self.myPlants.append(plantRepresentation)
                completion()
            } catch {
                NSLog("Error decoding: \(error)")
                completion()
            }
        }.resume()
    }
    
    func updateServer(_ plant: PlantRepresentation, completion: @escaping(Error?) -> Void) {
        guard let token = UserController.shared.authToken else { return }
        SpeciesController.shared.updateSpecies(id: Int(plant.id), h2oFrequency: plant.h2oFrequency ?? 0, image: plant.image) { (error) in
            if let error = error {
                DispatchQueue.main.async { completion(error) }
                return
            }
        }
        
        
        let requestURL = baseURL.appendingPathComponent("/plants/\(plant.id)")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.put.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Authorization")
        request.addValue(token.token, forHTTPHeaderField: "Authorization")
        do {
            request.httpBody = try JSONEncoder().encode(plant)
        } catch {
            NSLog("Error encoding")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { _, response, error in
            if let response = response {
                print(response)
            }
            
            if let error = error {
                NSLog("\(error)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }
    
    func deleteFromServer(_ plantRep: PlantRepresentation, completion: @escaping(Error?) -> Void) {
        
        let token = String(describing: UserController.shared.authToken?.token)
        var requestURL = baseURL
        requestURL.appendPathComponent("\(plantRep.id)")
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.delete.rawValue
        request.addValue(token, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: request) { _, response, error in
            if let response = response {
                print(response)
            }
            if let _ = error {
                NSLog("Error")
                completion(error)
                return
            }
            
            guard let index = self.myPlants.firstIndex(of: plantRep) else
            {print("returning nill out of deleteClassFromSever"); return}
            self.myPlants.remove(at:index)
            completion(nil)
        }.resume()
    }
    
    // MARK: - Get Functions
    func fetchPlantFromServer(completion: @escaping (Error?) -> Void = {_ in } ) {
        /// For updating  a plant, check back in later.
        let token = String(describing: UserController.shared.authToken?.token)
        guard let id = UserController.shared.userID else { return }
        print("id= \(id) token:\(token)")
        let requestURL = baseURL.appendingPathComponent("plants/user/\(id)")
        var request = URLRequest(url: requestURL)
        request.addValue(token, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            
            if let error = error {
                NSLog("Error with request: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                NSLog("Error fetching data: \(String(describing: error))")
                completion(error)
                return
            }
            
            do {
                var plants = try JSONDecoder().decode(PlantRepresentations.self, from: data).results
                var i = 0
                for plant in plants {
                    let speciesId = SpeciesController.shared.getCorrespondingSpecies(id: Int(plant.id)) { (error) in
                            DispatchQueue.main.async { completion(error) }
                            return
                    }
                    plants[i].speciesId = Double(speciesId?.id ?? 7)
                    i += 1
                }
                
            } catch {
                NSLog("Error decoding: \(error)")
            }
            completion(nil)
        }.resume()
    }
    // MARK: - Crud Functions
    
    func createPlant(with speciesId: Double, nickname: String, location: String, image: Data, id: Double, wateredDate: Date, h2oFrequency: Double?, context: NSManagedObjectContext) {
        
        let plant = Plant(speciesId: speciesId, nickname: nickname, location: location, image: image, id: id, h2oFrequency: h2oFrequency, wateredDate: wateredDate, context: context)
        
        do {
            try CoreDataStack.shared.save()
            createPlantInServer(plant: plant)
        } catch {
            NSLog("Error creating plant")
        }
    }
    
    func updatePlant(for plantRep: PlantRepresentation, with plant: Plant) -> PlantRepresentation {
        guard let index = myPlants.firstIndex(of: plantRep) else { return plantRep }
        myPlants[index].nickname = plant.nickname ?? ""
        myPlants[index].h2oFrequency = plant.h2oFrequency
        myPlants[index].image = plant.image ?? Data()
        myPlants[index].location = plant.location ?? ""
        myPlants[index].speciesId = plant.speciesId
        
        return myPlants[index]
    }
    func deletePlant(_ plantRep: PlantRepresentation) {
        guard let index = myPlants.firstIndex(of: plantRep) else { return }
        myPlants.remove(at: index)
    }
}


