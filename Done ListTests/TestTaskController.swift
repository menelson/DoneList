//
//  TestTaskController.swift
//  Done List
//
//  Created by Mike Nelson on 5/12/17.
//  Copyright © 2017 MJR Designs. All rights reserved.
//

import XCTest
import CoreData
@testable import Done_List

class TestTaskController: XCTestCase {
    var controller: TaskController?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let context = setUpInMemoryCoreDateContext()
        controller = TaskController.init()
        controller?.context = context
        
        controller?.createNewTask(name: "Unit Test 1")
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    /*
     * Technique is from https://www.andrewcbancroft.com/2015/01/13/unit-testing-model-layer-core-data-swift/
     */
    func setUpInMemoryCoreDateContext() -> NSManagedObjectContext {
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main])
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel!)
        
        do {
            try persistentStoreCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
        } catch {
            print("Adding in-memory persistent store failed")
        }
        
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
        
        return managedObjectContext
    }
    
    func testFetchingTaskByPriority() {
        // Given
        let priority = Priority.Normal
        
        // When
        let tasks = controller?.fetchTasks(byPriority: priority)
        
        // Then
        XCTAssertNotNil(tasks, "Function should return non nil array")
        XCTAssertTrue((tasks?.count)! >= 1, "Array should be 0 or larger")
        if (tasks?.count)! > 0 {
            XCTAssertTrue(tasks?[0].priority == "This Week", "Priority should equal Today")
        }
    
    }
}
