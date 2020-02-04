//
//  UserController.swift
//  Plants
//
//  Created by Lambda_School_Loaner_219 on 2/3/20.
//

import Foundation
import CoreData

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    
    
}

enum NetworkError: Error {
    case noAuth
    case badAuth
    case otherError
    case badData
    case noDecode
}

class UserController{
    private let baseURL = URL(string: "https://water-my-plants-1.herokuapp.com/api")!
    private let signUpURL = URL(string: "https://water-my-plants-1.herokuapp.com/api/users/register" )!
    
    private let loginUserURL = URL(string: "https://water-my-plants-1.herokuapp.com/api/users/register/users/login")!
    
    static var shared = UserController()
    
    var authToken:Token?
    var userID: ID?
    
    
    func signUp(with user: UserRepresentation, completion: @escaping (Error?) -> ()) {
       
        
        var request = URLRequest(url: signUpURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
        } catch {
            print("Error encoding user object: \(error)")
            completion(error)
            return
        }
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(NSError(domain: "", code: response.statusCode, userInfo:nil))
                return
            }
            
            if let error = error {
                DispatchQueue.main.async { completion(error) }
                return
            }
            guard let data = data else {
                DispatchQueue.main.async { completion(NSError()) }
                return
            }
            
                    let decoder = JSONDecoder()
                   // decoder.keyDecodingStrategy = .convertFromSnakeCase
                    do {
                        self.userID = try decoder.decode(ID.self, from: data)
                        print("Success signing up  your d is: \(String(describing: self.userID?.id))")
                        
                    } catch {
                        print("Error decoding id object: \(error)")
                        completion(error)
                        return
                    }
                    
            DispatchQueue.main.async { completion(nil) }
                }.resume()
            
            
    }
    
    
    func logIn(with user: UserRepresentation, completion: @escaping (Error?) -> ()) {
        let loginUrl = loginUserURL
        
        var request = URLRequest(url: loginUrl)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
        } catch {
            print("Error encoding user object: \(error)")
            completion(error)
            return
        }
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                DispatchQueue.main.async { completion(NSError(domain: "", code: response.statusCode, userInfo:nil)) }
                return
            }
            
            if let error = error {
                DispatchQueue.main.async { completion(error) }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async { completion(NSError()) }
                return
            }
            
            let decoder = JSONDecoder()
           // decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                self.authToken = try decoder.decode(Token.self, from: data)
                print("Success logging in your token is: \(String(describing: self.authToken?.token))")
                
            } catch {
                print("Error decoding login user object: \(error)")
                DispatchQueue.main.async { completion(error) }
                return
            }
            
            DispatchQueue.main.async { completion(nil) }
        }.resume()
    }
    
    func getUserPlants( completion: @escaping ([PlantRepresentation]?, Error?) -> Void) {
        guard let token = authToken?.token else {
            DispatchQueue.main.async { completion(nil, NSError()) }
            return
            
           
        }
        
         let userPlantsURL = baseURL.appendingPathComponent("/plants/user/\(userID?.id)")
        
        var request = URLRequest(url: userPlantsURL)
              request.httpMethod = HTTPMethod.get.rawValue
              request.addValue(token, forHTTPHeaderField: "Authorization")
              URLSession.shared.dataTask(with: request) { data, _, error in
                  if let _ = error {
                      print("Error")
                    DispatchQueue.main.async { completion(nil, error) }
                      return
                  }
                  guard let data = data else {
                      print("Bad Data")
                      return
                  }
                  let decoder = JSONDecoder()
                  decoder.keyDecodingStrategy = .convertFromSnakeCase
                  do {
                      let userPlants = try decoder.decode([PlantRepresentation].self, from: data)
                    DispatchQueue.main.async { completion(userPlants, nil) }
                      
                  } catch {
                      print("Error decoding")
                    DispatchQueue.main.async { completion(nil, error) }
                  }
              }.resume()
          }
        
    }
        
    
    
    
    
    

