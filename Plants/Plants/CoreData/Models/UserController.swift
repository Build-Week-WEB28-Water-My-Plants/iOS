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
    
    private let loginUserURL = URL(string: "https://water-my-plants-1.herokuapp.com/api/users/register/users/login")
    
    
}
