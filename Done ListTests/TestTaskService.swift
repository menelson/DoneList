//
//  TestTaskService.swift
//  Done List
//
//  Created by Mike Nelson on 5/30/17.
//  Copyright © 2017 MJR Designs. All rights reserved.
//

import XCTest
@testable import Done_List

class TestTaskService: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
        UserDefaults.standard.removeObject(forKey: TaskService.lastRunKey)
    }
    
    func testDateComparisionForOneDay() {
        // Given
        let now = Date()
        
        let lastRunDate = Calendar.current.date(byAdding: .day, value: -1, to: now)
        
        let service = TaskService()
        
        // When
        let check = service.compare(lastRun: lastRunDate!, now: now)
        
        // Then
        XCTAssert(check == true, "True should return if difference == 1 day")
        
    }
    
    func testDateComparisionForLessThanOneDay() {
        // Given
        let now = Date()
        
        let lastRunDate = Calendar.current.date(byAdding: .hour, value: -23, to: now)
        
        let service = TaskService()
        
        // When
        let check = service.compare(lastRun: lastRunDate!, now: now)
        
        // Then
        XCTAssert(check == false, "False should return if difference < 1 day")
    }
    
    func testDateComparisionForMoreThanOneDay() {
        // Given
        let now = Date()
        
        let lastRunDate = Calendar.current.date(byAdding: .hour, value: -25, to: now)
        
        let service = TaskService()
        
        // When
        let check = service.compare(lastRun: lastRunDate!, now: now)
        
        // Then
        XCTAssert(check == true, "True should return if difference > 1 day")
    }
    
    func testFetchLastRunWhenNoRunHasBeenCompleted() {
        // Given
        let service = TaskService()
        
        // When
        let lastRun = service.fetchLastRunDate()
        
        // Then
        XCTAssert(lastRun == "", "lastRun should be an empty String")
    }
    
    func testLastRunAddedToDefaults() {
        // Given
        let service = TaskService()
        let lastRun = "5/15/2017 10:52 AM"
        
        // When
        service.insertInDefaults(lastRun: lastRun)
        
        // Then
        let fetched = UserDefaults.standard.string(forKey: TaskService.lastRunKey)
        
        XCTAssert(lastRun == fetched)
    }
    
        
}
