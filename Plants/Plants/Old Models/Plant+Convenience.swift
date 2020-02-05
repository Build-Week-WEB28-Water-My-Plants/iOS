//
//  Plant+Convenience.swift
//  Plants
//
//  Created by Alexander Supe on 02.02.20.
//

import Foundation
import CoreData

extension Plant {
     
    var plantRepresentation: PlantRepresentation? {
        guard let nickname = nickname, let id: Double = 0.0, let location = location, let image = image, let speciesId: Double = 0.0, let wateredDate = wateredDate else { return nil }
            
        return PlantRepresentation(id: id, image: image, nickname: nickname, speciesId: speciesId, h2oFrequency: h2oFrequency, location: location, creationDate: wateredDate)
        
    }
    
    convenience init(speciesId: Double?, nickname: String, location: String, image: Data, id: Double, h2oFrequency: Double?, wateredDate: Date, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        self.speciesId = speciesId ?? 0
        self.nickname = nickname
        self.location = location
        self.image = image
        self.id = id
        self.wateredDate = wateredDate
        guard let h2oFrequency = h2oFrequency else { return }
        self.h2oFrequency = h2oFrequency
    }
    
    @discardableResult convenience init?(plantRepresentation: PlantRepresentation, context: NSManagedObjectContext) {
        
        self.init(speciesId: plantRepresentation.speciesId,
                  nickname: plantRepresentation.nickname,
                  location: plantRepresentation.location,
                  image: plantRepresentation.image ?? Data(),
                  id: plantRepresentation.id,
                  h2oFrequency: plantRepresentation.h2oFrequency,
                  wateredDate: plantRepresentation.creationDate ?? Date(),
                  context: context)
        
    }
}
