//
//  PlantRepresentation.swift
//  Plants
//
//  Created by Lambda_School_Loaner_219 on 2/3/20.
//

import Foundation
import UIKit 
struct PlantRepresentation: Equatable, Codable {
    
    var id: Double
    var image: Data
    var nickname: String
    var speciesId: Double
    var h2oFrequency: Double?
    var location: String
    
    init(id: Double, image: Data, nickname: String, speciesId: Double, h2oFrequency: Double?, location: String) {
        
        self.id = id
        self.image = image
        self.nickname = nickname
        self.speciesId = speciesId
        self.h2oFrequency = h2oFrequency
        self.location = location
    }
    
}
