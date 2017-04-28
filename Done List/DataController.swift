//
//  DataController.swift
//  Done List
//
//  Created by Mike Nelson on 4/24/17.
//  Copyright © 2017 MJR Designs. All rights reserved.
//

import UIKit
import CoreData

class DataController: NSObject {
    
    let persistentContainer: NSPersistentContainer
    
    static let sharedInstance = DataController(completionClosure: {})
    
    init(completionClosure: @escaping () -> () ){
        persistentContainer = NSPersistentContainer(name: "Model")
        
        persistentContainer.loadPersistentStores() {
            (description, error) in
            
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
            
            completionClosure()
        }
        
    }
    
    func getMainManagedObjectContext() -> NSManagedObjectContext {
        let context = persistentContainer.viewContext
        context.automaticallyMergesChangesFromParent = true
        return context
    }
    
    func getBackgroundManagedObjectContext() -> NSManagedObjectContext {
        return persistentContainer.newBackgroundContext()
    }
    
    func getPersistentContainer() -> NSPersistentContainer {
        return persistentContainer
    }
    
}
