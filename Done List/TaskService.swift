//
//  TaskService.swift
//  Done List
//
//  Created by Mike Nelson on 5/30/17.
//  Copyright © 2017 MJR Designs. All rights reserved.
//

import Foundation

class TaskService {
    
    lazy var dateFormatter = {
        _ -> DateFormatter in
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        return formatter
    }()
    
    static let lastRunKey: String = "LAST_RUN"
    let userDefaults = UserDefaults.standard
    
    init() {
        _ = userDefaults.synchronize()
    }
    
    func sync() {
        if !serviceAlreadyRun() {
            TaskController().autoUpdateTaskPriority()
            
            let lastRun = dateFormatter.string(from: Date())
            
            insertInDefaults(lastRun: lastRun)
        }
    }
    
    func serviceAlreadyRun() -> Bool {
        let lastRunString = fetchLastRunDate()
        
        if (lastRunString == "") {
            return false
        }
        
        let lastRun = dateFormatter.date(from: lastRunString)
        
        if (compare(lastRun: lastRun!, now: Date())) {
            return false
        }

        return true
    }
    
    func compare(lastRun lastRunDate: Date, now: Date) -> Bool {
        let oneDay = 24.0 * 3600.0
        
        let diff = now.timeIntervalSince(lastRunDate)
        
        if diff >= oneDay {
            return true
        }
        
        return false
    }
    
    func fetchLastRunDate() -> String {
        guard let lastRun = userDefaults.string(forKey: TaskService.lastRunKey) else {
            return ""
        }
        
        return lastRun
    }
    
    func insertInDefaults(lastRun: String) {
        userDefaults.set(lastRun, forKey: TaskService.lastRunKey)
    }
    
    
    
}
