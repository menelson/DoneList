//
//  ScheduleTaskViewController.swift
//  Done List
//
//  Created by Mike Nelson on 5/25/17.
//  Copyright © 2017 MJR Designs. All rights reserved.
//

import UIKit

class ScheduleTaskViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView?
    var timeSlots = [Int]()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView?.dataSource = self
        tableView?.delegate = self
        
        setUpTimeSlots()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func setUpTimeSlots() {
        let calendars = DLCalendarService().fetchUserPreferredCalendars()
        timeSlots = DLScheduleService(forCalendars: calendars).fetchOpenSlots()
    }
}

extension ScheduleTaskViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeSlots.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TimeCell") else {
            return UITableViewCell()
        }
        
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        
        let time = Calendar.current.date(bySetting: .hour, value: timeSlots[indexPath.row], of: Date())
        
        cell.textLabel?.text = formatter.string(from: time!)
        
        return cell
    }
}

extension ScheduleTaskViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected \(indexPath.row)")
    }
}
