//
//  Plant+Convenience.swift
//  Plants
//
//  Created by Alexander Supe on 02.02.20.
//

import Foundation
import CoreData

import Foundation
import CoreData
extension Plant {
     
    var plantRepresentation: PlantRepresentation? {
        guard let species = species, let nickname = nickname, let id: Double = 0.0, let location = location, let image = image else { return nil }
            
        return PlantRepresentation(imageURL: "", id: id, nickname: nickname, species: species, h2oFrequency: 0.0, location: location)
        
    }
    
    convenience init(species: String, nickname: String, location: String, image: String, id: Double, h2oFrequency: Double, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.species = species
        self.nickname = nickname
        self.location = location
        self.image = image
        self.id = id
        self.h2oFrequency = h2oFrequency
    }
    
    @discardableResult convenience init?(plantRepresentation: PlantRepresentation, context: NSManagedObjectContext) {
        
        self.init(species: plantRepresentation.species,
                  nickname: plantRepresentation.nickname,
                  location: plantRepresentation.location,
                  image: plantRepresentation.imageURL,
                  id: plantRepresentation.id,
                  h2oFrequency: plantRepresentation.h2oFrequency,
                  context: context)
    }
}
