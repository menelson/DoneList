//
//  TestScheduleTask.swift
//  Done List
//
//  Created by Mike Nelson on 5/25/17.
//  Copyright © 2017 MJR Designs. All rights reserved.
//

import XCTest
import EventKit
@testable import Done_List

class TestScheduleTask: XCTestCase {
    
    var calendar: EKCalendar?
    var event: EKEvent?
    var scheduleService: DLScheduleService?
    
    override func setUp() {
        super.setUp()
        // Event Setup
//        let eventStore = DLCalendarService().eventStore
//        calendar = EKCalendar(for: .event, eventStore: eventStore)
//        calendar?.title = "Test Calendar"
//        let allCals = [calendar]
//        
//        do {
//            try eventStore.saveCalendar(calendar!, commit: true)
//        } catch {
//            print("unable to save calendar with ::: \(error)")
//        }
//        
//        event = EKEvent(eventStore: eventStore)
//        event?.calendar = calendar!
//        event?.title = "Unit Test Task"
//        event?.startDate = Date()
//        event?.endDate = Calendar.current.date(byAdding: .hour, value: 1, to: (event?.startDate)!)!
//        
//        do {
//            try eventStore.save(event!, span: .thisEvent)
//        } catch {
//            print("Error saving \(error)")
//        }
        
        // Service Setup
        // MARK:- Refactor to use a Mocked calendar
        let cals = DLCalendarService().fetchUserPreferredCalendars()
        scheduleService = DLScheduleService(forCalendars: cals as! [EKCalendar])
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
        
    }
    
    func testInitAvailabilityDictionary() {
        // Given

        // When
        let availability = scheduleService?.getAvailability()
        
        // Then
        XCTAssert(availability?.count == 24, "There should be 24 keys in the dictionary")
        let first = availability?[0] as! [String: String]
        XCTAssert(first["event"] == "", "Event should be empty for first time slot")
        XCTAssert(first["blocked"] == "false", "Event should NOT be blocked")
    }
    
    /*
     * This current works as an integration test with the configured calendars
     */
    func testAddTodayEventsToAvailability() {
        // Given
        //let hour = Calendar.current.component(.hour, from: (event?.startDate)!)
        
        // When
        var availability = scheduleService?.getAvailability()
        
        // Then
        let dictionary = availability?[5] as! [String: Any]
        XCTAssert(dictionary["event"] as? String != "", "Event should not equal empty string")
        XCTAssert(dictionary["blocked"] as? String == "true", "Event slot should be blocked")
    }
    
    func testRetrievingOpenSlots() {
        // Given
        _ = scheduleService
        
        // When
        let openSlots = scheduleService?.fetchOpenSlots()
        
        // Then
        XCTAssertNotNil(openSlots)
        XCTAssert((openSlots?.count)! <= 24)

    }
    
    
    
    
    
    
}
