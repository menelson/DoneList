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

    
}

extension CalendarSettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        if cell?.accessoryType == .checkmark {
            cell?.accessoryType = .none
        } else {
            cell?.accessoryType = .checkmark
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
        
        cell.textLabel?.text = calendar.title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Available Calendars"
    }
}
