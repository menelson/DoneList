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
    var context: NSManagedObjectContext
    
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
        task.createdDate = Date() as NSDate?
        task.dueDate = Calendar.current.date(byAdding: .day, value: 7, to: Date())! as NSDate
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
    
    func bulkUpdate(tasks: [TaskMO], priority: Priority) {
        for task in tasks {
            task.priority = priority.rawValue
            task.priorityInt = Int32(priority.hashValue)
        }
        save()
    }
    
    func fetchAllTasks() -> [TaskMO] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
        
        var fetchedTasks = [TaskMO]()
        
        do {
            fetchedTasks = try context.fetch(fetchRequest) as! [TaskMO]
        } catch {
            print("Unable to fetch tasks")
        }
        
        return fetchedTasks
    }
    
    func fetchTasks(byPriority priority: Priority) -> [TaskMO] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
        fetchRequest.predicate = NSPredicate(format: "priority == %@", argumentArray: [priority.rawValue])
        
        var fetchedTasks = [TaskMO]()
        
        do {
            fetchedTasks = try context.fetch(fetchRequest) as! [TaskMO]
        } catch {
            fatalError("Failed to fetch tasks: \(error)")
        }
        
        return fetchedTasks
    }
    
    func getTaskAge(task: TaskMO) -> Int {
        let now = Date()
        let diff = now.timeIntervalSince(task.createdDate! as Date)
        
        return Int(round(diff)) / (3600 * 24)
    }
    
    func autoUpdateTaskPriority() {
        let tasks = fetchAllTasks()
        
        for task in tasks {
            let diff = round((task.dueDate! as Date).timeIntervalSince(Date()) / (3600 * 24))
            // Only moving things for the next few days
            if diff > 1 {
                task.priority = Priority.Urgent.rawValue
                task.priorityInt = Int32(Priority.Urgent.hashValue)
            }else if diff == 1 {
                task.priority = Priority.High.rawValue
                task.priorityInt = Int32(Priority.High.hashValue)
            } else if diff == 2 {
                task.priority = Priority.Normal.rawValue
                task.priorityInt = Int32(Priority.Normal.hashValue)
            }
        }
        save()
    }

}
