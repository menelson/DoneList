//
//  DLCalendarService.swift
//  Done List
//
//  Created by Mike Nelson on 5/8/17.
//  Copyright © 2017 MJR Designs. All rights reserved.
//

import Foundation
import EventKit

class DLCalendarService {
    let eventStore = EKEventStore()
    var calendars = [EKCalendar]()
    
    init() {
        checkPermissionStatus()
    }
    
    func checkPermissionStatus() {
        let status = EKEventStore.authorizationStatus(for: EKEntityType.event)
        
        switch(status) {
        case EKAuthorizationStatus.notDetermined:
            requestCalendarAccess()
            break
        case EKAuthorizationStatus.authorized:
            _ = fetchUserCalendars()
            break
        case EKAuthorizationStatus.restricted:
            // Prompt to display why - Currently unhandled
            break
        case EKAuthorizationStatus.denied:
            // Prompt to display why - Currently unhandled
            break
        }
    }
    
    func requestCalendarAccess() {
        eventStore.requestAccess(to: EKEntityType.event) { (accessGranted, error) in
            if error != nil {
                print("Error accessing calendar permissions with :::: \(String(describing: error?.localizedDescription))")
            }
            
            if accessGranted == true {
                DispatchQueue.main.async {
                    // Do stuff with calendars
                    _ = self.fetchUserCalendars()
                }
            } else {
                // Prompt user again
            }
        }
    }
    
    func fetchUserCalendars() -> [EKCalendar] {
        return eventStore.calendars(for: EKEntityType.event)
    }
    
    func fetchCalendarById(identifier: String) -> EKCalendar {
        return eventStore.calendar(withIdentifier: identifier)!
    }


}
