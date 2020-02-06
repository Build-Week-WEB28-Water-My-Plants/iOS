//
//  CoreDataStack.swift
//  Plants
//
//  Created by Alexander Supe on 03.02.20.
//

import Foundation
import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()
    
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "NewPlant")
        container.loadPersistentStores { (_, error) in
            if let error = error { fatalError("Failed to load persistent stores: \(error)") }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }
    
    func save(context: NSManagedObjectContext = CoreDataStack.shared.mainContext) throws {
        var error: Error?
        context.performAndWait {
            do { try context.save() }
            catch let saveError { error = saveError }
        }
        if let error = error { throw error }
    }
    
}
