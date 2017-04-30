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
        task.priority = Priority.Normal.rawValue
        task.priorityInt = Int32(Priority.Normal.hashValue)
        task.createdDate = Date.init() as NSDate?
        task.dueDate = Date.distantFuture as NSDate?
        save()
    }
    
    func deleteTask(task: TaskMO) {
        self.context.delete(task)
        save()
    }
    
    func updateTask(task: TaskMO) {
        save()
    }
    
    func getTaskContext() -> NSManagedObjectContext {
        return context
    }

}
