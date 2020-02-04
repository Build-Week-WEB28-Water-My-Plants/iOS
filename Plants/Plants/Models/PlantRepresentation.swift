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
    var image: UIImage {
        return UIImage(named: imageURL) ?? UIImage()
    }
    let nickname: String
    let species: String
    let h2oFrequency: Double 
    let location: String
    var imageURL: String
    
    init(imageURL: String, id: Double, nickname: String, species: String, h2oFrequency: Double, location: String) {
        self.imageURL = imageURL
        self.id = id
        self.nickname = nickname
        self.species = species
        self.h2oFrequency = h2oFrequency
        self.location = location
    }
    
}
