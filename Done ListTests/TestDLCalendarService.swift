//
//  TestDLCalendarService.swift
//  Done List
//
//  Created by Mike Nelson on 5/8/17.
//  Copyright © 2017 MJR Designs. All rights reserved.
//

import XCTest
import EventKit

class TestDLCalendarService: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
        
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}

class FakeCalendar: EKCalendar {
    
}
