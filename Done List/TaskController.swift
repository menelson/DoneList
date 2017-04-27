//
//  TaskController.swift
//  Done List
//
//  Created by Mike Nelson on 4/24/17.
//  Copyright © 2017 MJR Designs. All rights reserved.
//

import UIKit
import CoreData

class TaskController: NSObject {
    
    static let sharedInstance = TaskController()
    var dataController: DataController
    let context: NSManagedObjectContext
    
    override init() {
        dataController = DataController() {}
        let container: NSPersistentContainer = dataController.getPersistentContainer() as NSPersistentContainer
//        container.viewContext.automaticallyMergesChangesFromParent = true
        context = container.newBackgroundContext()
        context.automaticallyMergesChangesFromParent = true
    }
    
    func save() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                fatalError("failed to save: \(error)")
            }
        }
        
    }
    
    func createNewTask(name: String) {
        let task = NSEntityDescription.insertNewObject(forEntityName: "Task", into: context) as! TaskMO
        task.name = name
        
        save()
    }
    
    func getTaskContext() -> NSManagedObjectContext {
        return context
    }

}
