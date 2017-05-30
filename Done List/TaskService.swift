//
//  TaskService.swift
//  Done List
//
//  Created by Mike Nelson on 5/30/17.
//  Copyright © 2017 MJR Designs. All rights reserved.
//

import Foundation

class TaskService {
    
    // Check current month / day / year
    // Check if already done -> Bool...?
    // Update
    var now: Date?
    static let lastRunKey: String = "LAST_RUN"
    
    init() {
        
    }
    
    func sync() {
        if serviceAlreadyRun() {
            TaskController().autoUpdateTaskPriority()
        }
    }
    
    func serviceAlreadyRun() -> Bool {
        return false
    }
    
    func compare(lastRun lastRunDate: Date, now: Date) -> Bool {
        let oneDay = 24.0 * 3600.0
        
        let diff = now.timeIntervalSince(lastRunDate)
        
        if diff >= oneDay {
            return true
        }
        
        return false
    }
    
}
