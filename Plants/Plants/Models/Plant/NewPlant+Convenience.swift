//
//  NewPlant+Convenience.swift
//  Plants
//
//  Created by Alexander Supe on 05.02.20.
//

import Foundation
import CoreData

extension NewPlant {
    
    var newPlantRepresentation: NewPlantRepresentation? {
        guard let nickname = nickname, let id = id, let wateredDate = wateredDate else { return nil }
        return NewPlantRepresentation(nickname: nickname, location: location ?? "", wateredDate: wateredDate, image: image ?? Data(), id: id.uuidString, h2oFrequency: h2oFrequency)
    }
    
    @discardableResult convenience init(nickname: String, id: UUID = UUID(), wateredDate: Date = Date(), image: Data, location: String, h2oFrequency: Double, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.nickname = nickname
        self.id = id
        self.wateredDate = wateredDate
        self.image = image
        self.location = location
        self.h2oFrequency = h2oFrequency
    }
    
    @discardableResult convenience init?(newPlantRepresentation: NewPlantRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        guard let id = UUID(uuidString: newPlantRepresentation.id) else { return nil }
        self.init(nickname: newPlantRepresentation.nickname, id: id, wateredDate: newPlantRepresentation.wateredDate, image: newPlantRepresentation.image, location: newPlantRepresentation.location, h2oFrequency: newPlantRepresentation.h2oFrequency, context: context)
    }
}
