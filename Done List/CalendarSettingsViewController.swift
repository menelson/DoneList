//
//  CalendarSettingsViewController.swift
//  Done List
//
//  Created by Mike Nelson on 5/9/17.
//  Copyright © 2017 MJR Designs. All rights reserved.
//

import UIKit
import EventKit

class CalendarSettingsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView?
    
    var calendars = [EKCalendar]()
    
    lazy var availableCalenders = { () -> [String] in
        let defaults = DLCalendarDefaults.init()
        return defaults.getAvailableCalendars()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        _ = populateCalendars()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapDone(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func populateCalendars() -> Bool {
        let svc = DLCalendarService.init()
        calendars = svc.fetchUserCalendars()
        self.tableView?.reloadData()
        return true
    }
    
    func removeCalendarFromAvailable(row: Int) {
        // Get Identifier from selected row in tableview
        let selectedCal = calendars[row].calendarIdentifier
        
        // Find Cal in available Calendars
        for index in 0...availableCalenders.count {
            if index < availableCalenders.count && availableCalenders[index] == selectedCal {
                // Remove from local
                availableCalenders.remove(at: index)
                
                // Remove from defaults
                let calDefaults = DLCalendarDefaults.init()
                calDefaults.setAvailableCalendars(calendars: availableCalenders)
            }
        }
    }
    
    func checkIfCalendarIsDefault(row: Int) -> Bool {
        let currentIdentifier = calendars[row].calendarIdentifier
        
        for index in 0...availableCalenders.count {
            if index < availableCalenders.count && availableCalenders[index] == currentIdentifier {
                return true
            }
        }
        return false
    }
    
    func addCalendarToDefaults(row: Int) {
        // Add to local
        availableCalenders.append(calendars[row].calendarIdentifier)
        
        // Add to defaults
        let defaults = DLCalendarDefaults.init()
        defaults.setAvailableCalendars(calendars: availableCalenders)
    }
    
}

extension CalendarSettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        if cell?.accessoryType == .checkmark {
            cell?.accessoryType = .none
            self.removeCalendarFromAvailable(row: indexPath.row)
        } else {
            cell?.accessoryType = .checkmark
            addCalendarToDefaults(row: indexPath.row)
        }
    }
}

extension CalendarSettingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calendars.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CalSettingCell") else {
            return UITableViewCell()
        }
        
        let calendar = calendars[indexPath.row]
        print("calendar \(calendar.calendarIdentifier)")
        
        cell.textLabel?.text = calendar.title
        
        if checkIfCalendarIsDefault(row: indexPath.row) {
            cell.accessoryType = .checkmark
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Available Calendars"
    }
}
