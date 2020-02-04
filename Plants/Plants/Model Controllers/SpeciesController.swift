//
//  SpeciesController.swift
//  Plants
//
//  Created by Alexander Supe on 04.02.20.
//

import Foundation

class SpeciesController {
    
    static let shared = SpeciesController()
    
    private let baseURL = URL(string: "https://water-my-plants-1.herokuapp.com/api")!
    
    func getCorrespondingSpecies(id: Int, completion: @escaping (Error?) -> ()) -> Species? {
        
        let requestURL = baseURL.appendingPathComponent("/plants/species/list/\(id)")
        var request = URLRequest(url: requestURL)
        request.addValue(UserController.shared.authToken, forHTTPHeaderField: "Authorization")
        var species: Species?
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error { completion(error); return }
            guard let data = data else { completion(NSError()); return }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                species = try decoder.decode(Species.self, from: data)
                completion(nil)
            } catch {
                NSLog("Error decoding JSON data: \(error)")
                completion(error)
            }
        }.resume()
        return species
    }
    
    func createSpecies(h2oFrequency: Double, completion: @escaping (Error?) -> ()) {
        
        let requestURL = baseURL.appendingPathComponent("/plants/species/")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        request.addValue(UserController.shared.authToken, forHTTPHeaderField: "Authorization")
        let species = Species(h2oFrequency: h2oFrequency, commonName: String.random(length: 20), scientificName: String.random(length: 20))

        do {
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            request.httpBody = try encoder.encode(species)
        } catch {
            DispatchQueue.main.async { completion(error) }
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error { completion(error); return }
        }.resume()
        return
    }
    
    func updateSpecies(id: Int, h2oFrequency: Double, completion: @escaping (Error?) -> ()) {
        
        let requestURL = baseURL.appendingPathComponent("/plants/species/\(id)")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        request.addValue(UserController.shared.authToken, forHTTPHeaderField: "Authorization")
        let species = Species(h2oFrequency: h2oFrequency, commonName: String.random(length: 20), scientificName: String.random(length: 20))
        do {
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            request.httpBody = try encoder.encode(species)
        } catch {
            DispatchQueue.main.async { completion(error) }
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error { completion(error); return }
        }.resume()
        return
    }
    
    
}

extension String {
    static func random(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
}
