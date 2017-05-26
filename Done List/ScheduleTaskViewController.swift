//
//  ScheduleTaskViewController.swift
//  Done List
//
//  Created by Mike Nelson on 5/25/17.
//  Copyright © 2017 MJR Designs. All rights reserved.
//

import UIKit
import EventKitUI


class ScheduleTaskViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView?
    
    var task: TaskMO?
    
    var timeSlots = [Int]()
    lazy var editEventVC: EKEventEditViewController? = EKEventEditViewController()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView?.dataSource = self
        tableView?.delegate = self
        
        setUpTimeSlots()
    
        editEventVC?.editViewDelegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // UI Actions and Setup
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
        
        
        let startTime = Calendar.current.date(bySetting: .hour, value: timeSlots[indexPath.row], of: Date())
        
        cell.textLabel?.text = formatter.string(from: startTime!)
        
        return cell
    }
}

extension ScheduleTaskViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let startTime = Calendar.current.date(bySetting: .hour, value: timeSlots[indexPath.row], of: Date())
        let endTime = Calendar.current.date(byAdding: .hour, value: 1, to: startTime!)
        
        let store = EKEventStore()
        let event = EKEvent(eventStore: store)
        event.title = task?.name ?? ""
        event.startDate = startTime!
        event.endDate = endTime!
        
        editEventVC?.event = event
        editEventVC?.eventStore = store
        
        self.present(editEventVC!, animated: true, completion: nil)
    }
}


extension ScheduleTaskViewController: EKEventEditViewDelegate {
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        switch action {
        case .canceled:
            controller.cancelEditing()
            self.dismiss(animated: true, completion: nil)
            break;
        case .saved:
            // Dismiss Edit
            controller.dismiss(animated: true, completion: {
                // Dismiss current VC
                self.dismiss(animated: true, completion: nil)
            })
            break;
        default:
            break;
        }
    }
}
