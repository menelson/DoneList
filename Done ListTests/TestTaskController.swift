//
//  TestTaskController.swift
//  Done List
//
//  Created by Mike Nelson on 5/12/17.
//  Copyright © 2017 MJR Designs. All rights reserved.
//

import XCTest
@testable import Done_List

class TestTaskController: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testFetchingTaskByPriority() {
        // Given
        let priority = Priority.Urgent
        
        // When
        let tasks = TaskController.sharedInstance.fetchTasks(byPriority: priority)
        
        // Then
        XCTAssertNotNil(tasks, "Function should return non nil array")
        XCTAssertTrue(tasks.count >= 0, "Array should be 0 or larger")
        if tasks.count > 0 {
            XCTAssertTrue(tasks[0].priority == "Today", "Priority should equal Today")
        }
    
    }
}
