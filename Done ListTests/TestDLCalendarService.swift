//
//  TestDLCalendarService.swift
//  Done List
//
//  Created by Mike Nelson on 5/8/17.
//  Copyright © 2017 MJR Designs. All rights reserved.
//

import XCTest
import EventKit
@testable import Done_List

class TestDLCalendarService: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testServiceStartTime() {
        // Given
        let calendar = Calendar(identifier: .gregorian)
        let today = Date()
        let todayDateComps = calendar.dateComponents([.month, .day], from: today)
        
        // When
        let startDate = DLCalendarService.init().getStartDate(date: today)
        
        
        let startDateComps = calendar.dateComponents([.month, .day, .hour, .minute], from: startDate)
        
        // Then
        XCTAssert(startDateComps.hour == 0, "The hour should be 0 on a 24 hour clock")
        XCTAssert(startDateComps.minute == 0, "The mins should be 0")
        XCTAssert(startDateComps.month == todayDateComps.month, "Event month should remain the same")
        XCTAssert(startDateComps.day == todayDateComps.day, "Event day should remain the same")        
    }
    
}

class FakeCalendar: EKCalendar {
    
}
