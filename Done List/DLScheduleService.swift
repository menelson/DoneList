//
//  DLScheduleService.swift
//  Done List
//
//  Created by Mike Nelson on 5/25/17.
//  Copyright © 2017 MJR Designs. All rights reserved.
//

import Foundation
import EventKit

class DLScheduleService {
    
    var availability = [Int: Any]()
    
    init(forCalendars calendars: [EKCalendar]) {
        availability = addEventsToAvailability(fromCalendars: calendars)
    }
    
    private func initializeEmptyDictionary() -> [Int: Any] {
        var dictionary = [Int: Any]()
        
        for i in 0...23 {
            dictionary[i] = ["event" : "", "blocked": "false"]
        }
        
        return dictionary
    }
    
    func addEventsToAvailability(fromCalendars calendars: [EKCalendar]) -> [Int: Any] {
        var dictionary = initializeEmptyDictionary()
        
        let events = DLCalendarService().fetchEventsForCurrentDay(calendars: calendars)
        
        for event in events {
            let hour = Calendar.current.component(.hour, from: event.startDate)
            dictionary[hour] = ["event": event, "blocked" : "true"]
        }
        return dictionary
    }
    
    func getAvailability() -> [Int: Any] {
        return availability
    }
}
