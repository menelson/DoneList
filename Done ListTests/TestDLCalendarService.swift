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
    let calendar = Calendar(identifier: .gregorian)
    let today = Date()
    
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
        XCTAssertNotNil(startDate)
        XCTAssert(startDateComps.hour == 0, "The hour should be 0 on a 24 hour clock")
        XCTAssert(startDateComps.minute == 0, "The mins should be 0")
        XCTAssert(startDateComps.month == todayDateComps.month, "Event month should remain the same")
        XCTAssert(startDateComps.day == todayDateComps.day, "Event day should remain the same")        
    }
    
    func testServiceEndTime() {
        // Given
        let todayDateComps = calendar.dateComponents([.month, .day], from: today)
        
        // When
        let endDate = DLCalendarService.init().getEndDate(date: today)
        let endDateComps = calendar.dateComponents([.month, .day, .hour, .minute], from: endDate)
        
        // Then
        XCTAssert(endDateComps.hour == 23, "The hour should be 0 on a 24 hour clock")
        XCTAssert(endDateComps.minute == 59, "The mins should be 0")
        XCTAssert(endDateComps.month == todayDateComps.month, "Event month should remain the same")
        XCTAssert(endDateComps.day == todayDateComps.day, "Event day should remain the same")
    }
    
    func testFetchingCurrentDayEvents() {
        // Given
        var events: [EKEvent]
        let calendars = DLCalendarService.init().fetchUserPreferredCalendars()
        
        // When
        events = DLCalendarService.init().fetchEventsForCurrentDay(calendars: calendars)
        
        // Then
        XCTAssertNotNil(events)
        XCTAssert(events.count >= 0,
                  "Aray size should be greater than or equal to 0")
    }
    
    func testFetchingPreferredCalendars() {
        // Given
        var calendars: [EKCalendar]
        
        // When
        calendars = DLCalendarService.init().fetchUserPreferredCalendars()
        
        // Then
        XCTAssertNotNil(calendars)
        XCTAssert(calendars.count >= 0,
                  "Aray size should be greater than or equal to 0")
    }
    
    func testEventDurationCalculation() {
        // Given
        let eventStore = EKEventStore()
        // 30 mins in seconds
        let duration = TimeInterval(60 * 30)
        let event: EKEvent = EKEvent(eventStore: eventStore)
        event.startDate = Date()
        event.endDate = event.startDate.addingTimeInterval(duration)
        
        // When
        let calculatedDuration = DLCalendarService.init().calculateDuration(event: event)
        
        // Then
        XCTAssertNotNil(calculatedDuration)
        
        XCTAssert(calculatedDuration == duration, "Duration should be 1800 seconds")
        
    }
    
    
    
    
}

class FakeCalendar: EKCalendar {
    
}
