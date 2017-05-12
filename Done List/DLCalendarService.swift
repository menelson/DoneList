//
//  DLCalendarService.swift
//  Done List
//
//  Created by Mike Nelson on 5/8/17.
//  Copyright © 2017 MJR Designs. All rights reserved.
//

import Foundation
import EventKit
import UIKit

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
            informUserOfCalendarNeed()
            break
        case EKAuthorizationStatus.denied:
            informUserOfCalendarNeed()
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
                self.informUserOfCalendarNeed()
            }
        }
    }
    
    func informUserOfCalendarNeed() {
        let message = "The Calendar is used to schedule Tasks and block off your time. Without Access to the Calendar, some features of the app will not work correctly."
        
        let dialog = UIAlertController(title: "Calendar Permission", message: message, preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default, handler: {
            action in
            
            let settingsURL = URL(string: UIApplicationOpenSettingsURLString)
            UIApplication.shared.open(settingsURL!, options: [:], completionHandler: nil)
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        dialog.addAction(settingsAction)
        dialog.addAction(cancelAction)
        
        if var currentViewController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = currentViewController.presentedViewController {
                currentViewController = presentedViewController
            }
            
            currentViewController.present(dialog, animated: true, completion: nil)
        }
        
        
    }
    
    func fetchUserCalendars() -> [EKCalendar] {
        return eventStore.calendars(for: EKEntityType.event)
    }
    
    func fetchUserPreferredCalendars() -> [EKCalendar] {
        var calendars = [EKCalendar]()
        let calIds = DLCalendarDefaults.init().getAvailableCalendars()
        
        for id in calIds {
            let calendar = fetchCalendarById(identifier: id)
            calendars.append(calendar)
        }
        return calendars
    }
    
    func fetchCalendarById(identifier: String) -> EKCalendar {
        return eventStore.calendar(withIdentifier: identifier)!
    }
    
    func fetchEventsForCurrentDay(calendars: [EKCalendar]) -> [EKEvent] {
        let today = Date()
        let startDate = getStartDate(date: today)
        let endDate = getEndDate(date: today)
        
        let eventQuery = eventStore.predicateForEvents(withStart: startDate,
                                                       end: endDate,
                                                       calendars: calendars)
        
        return eventStore.events(matching: eventQuery)
    }
    
    func getStartDate(date: Date) -> Date {
        // Get calendar
        let calendar = Calendar(identifier: .gregorian)
        
        // Set componenets to Midnight of current Day
        var components = calendar.dateComponents([.year, .month, .day], from: date)
        components.hour = 0
        components.minute = 0
        components.second = 0
        
        // Create start date based on components
        guard let start = calendar.date(from: components) else {
            return Date()
        }
        
        return start
    }
    
    func getEndDate(date: Date) -> Date {
        // Get calendar
        let calendar = Calendar(identifier: .gregorian)
        
        // Set componenets to Midnight of current Day
        var components = calendar.dateComponents([.year, .month, .day], from: date)
        components.hour = 23
        components.minute = 59
        components.second = 59
        
        // Create start date based on components
        guard let endDate = calendar.date(from: components) else {
            return Date()
        }
        
        return endDate

    }
    
    func calculateDuration(event: EKEvent) -> TimeInterval {
        
        let difference = event.endDate.timeIntervalSince(event.startDate)
        
        return difference
    }


}
