//
//  Plant+Convenience.swift
//  Plants
//
//  Created by Alexander Supe on 02.02.20.
//

import Foundation
import CoreData

extension Plant {
    
    convenience init(species: String, nickname: String, location: String, image: Data?, id: UUID = UUID(), h2oFrequency: Int16, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.species = species
        self.nickname = nickname
        self.location = location
        self.image = image
        self.id = id
        self.h2oFrequency = h2oFrequency
    }
}
