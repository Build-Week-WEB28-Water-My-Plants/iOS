//
//  PlantRepresentation.swift
//  Plants
//
//  Created by Lambda_School_Loaner_219 on 2/3/20.
//

import Foundation
import UIKit 
struct PlantRepresentation: Equatable, Codable {
    
    let id: Double
    var image: Data
    let nickname: String
    let speciesId: Double
    let h2oFrequency: Double?
    let location: String
    
    init(id: Double, image: Data, nickname: String, speciesId: Double, h2oFrequency: Double?, location: String) {
        
        self.id = id
        self.image = image
        self.nickname = nickname
        self.speciesId = speciesId
        self.h2oFrequency = h2oFrequency
        self.location = location
    }
    
}
