//
//  DLCalendarDefaults.swift
//  Done List
//
//  Created by Mike Nelson on 5/9/17.
//  Copyright © 2017 MJR Designs. All rights reserved.
//

import Foundation
import EventKit

class DLCalendarDefaults {
    
    static let calendarKey = "AvailableCalendars"
    
    let sharedUserDefaults: UserDefaults
    
    
    init() {
        sharedUserDefaults = UserDefaults.standard
        _ = sharedUserDefaults.synchronize()
    }
    
    func setAvailableCalendars(calendars: [String]) {
        sharedUserDefaults.set(calendars, forKey: CalendarDefaults.calendarKey)
    }
    
    func getAvailableCalendars() -> [String] {
        var calendars = [String]()
        
        guard let temp = sharedUserDefaults.object(forKey: CalendarDefaults.calendarKey) as? [String] else {
            return calendars
        }
        
        if (temp.count) > 0 {
            calendars = temp
        }
        
        return calendars
    }
    
    
    
}
