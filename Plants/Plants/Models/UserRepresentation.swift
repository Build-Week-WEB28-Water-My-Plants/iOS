//
//  UserRepresentation.swift
//  Plants
//
//  Created by Lambda_School_Loaner_219 on 2/3/20.
//

import Foundation

struct UserRepresentation: Codable, Equatable {
    var username: String
    var password:String
    var phoneNumber:String?
//    var token:String
//    var id:Int
    enum CodingKeys: String, CodingKey {
      case username, password,
//        token, id,
        phoneNumber = "phone_number"
    }
}
