//
//  AgendaViewController.swift
//  Done List
//
//  Created by Mike Nelson on 5/4/17.
//  Copyright © 2017 MJR Designs. All rights reserved.
//

import UIKit
import EventKit

class AgendaViewController: UIViewController {
    
    @IBOutlet weak var agendaTableView: UITableView?
    @IBOutlet weak var taskTableView: UITableView?
    @IBOutlet weak var permissionView: UIView!
    
    var calendars = [EKCalendar]()
    var agendaEvents = [EKEvent]()
    var todayTasks = [TaskMO]()
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(AgendaViewController.agendaRefresh), for: UIControlEvents.valueChanged)
        
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupEventsData()
        setupTodayTasks()
        
        agendaTableView?.delegate = self
        agendaTableView?.dataSource = self
        agendaTableView?.addSubview(self.refreshControl)
        
        taskTableView?.delegate = self
        taskTableView?.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupEventsData()
        setupTodayTasks()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK:- UI Controls
    @objc func agendaRefresh(refreshControl: UIRefreshControl) {
        setupEventsData()
        self.agendaTableView?.reloadData()
        refreshControl.endRefreshing()
    }
    
    @IBAction func didTapGoToSettings(_ sender: Any) {
        let settingsURL = URL(string: UIApplicationOpenSettingsURLString)
        
        UIApplication.shared.open(settingsURL!, options: [:], completionHandler: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TaskScheduleSegue" {
            
            let destinationVC = segue.destination as? ScheduleTaskViewController
            
            let indexPath = taskTableView?.indexPathForSelectedRow
            let task = todayTasks[(indexPath?.row)!]
            
            destinationVC?.task = task
        }
    }
    
    // MARK:- Setup helpers
    func setupEventsData() {
        
        let calService = DLCalendarService.init()
        
        // Only pull data if permission is granted
        let status = EKEventStore.authorizationStatus(for: EKEntityType.event)
        if status == EKAuthorizationStatus.authorized {
            
            self.permissionView.isHidden = true
            self.agendaTableView?.isHidden = false
            
            // Reset Calendar Array
            self.calendars = [EKCalendar]()
            self.calendars = calService.fetchUserPreferredCalendars()
            
            // Reset Event Array
            self.agendaEvents = [EKEvent]()
            self.agendaEvents = setupCurrentAndFutureEvents()
            
            self.agendaTableView?.reloadData()
        } else {
            agendaTableView?.isHidden = true
            
        }
    }
    
    func setupCurrentAndFutureEvents() -> [EKEvent] {
        let todayEvents = DLCalendarService.init().fetchEventsForCurrentDay(calendars: self.calendars)
        
        var currentAndFutureEvents = [EKEvent]()
        let now = Date()
        for event in todayEvents {
            if event.startDate >= now {
                currentAndFutureEvents.append(event)
            }
        }
        
        return currentAndFutureEvents
    }
    
    func setupTodayTasks() {
        self.todayTasks = [TaskMO]()
        self.todayTasks = TaskController.sharedInstance.fetchTasks(byPriority: Priority.Urgent)
        self.taskTableView?.reloadData()
    }
    
    func getFormattedTimeString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        
        return formatter.string(from: date)
    }
    
}

extension AgendaViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        
        if (tableView == agendaTableView) {
            count = agendaEvents.count
        } else if (tableView == taskTableView) {
            count = todayTasks.count
            print("Task TV : \(count)")
        }
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (tableView == agendaTableView) {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "AgendaCell") as? AgendaTableViewCell else {
                return AgendaTableViewCell()
            }
            
            cell.eventTitle.text = agendaEvents[indexPath.row].title
            
            cell.startTimeLabel.text = getFormattedTimeString(date: agendaEvents[indexPath.row].startDate)
            
            let duration = DLCalendarService.init().calculateDuration(event: agendaEvents[indexPath.row]) / 60
            
            cell.durationLabel.text = "\(Int(duration)) mins"
            
            return cell
        } else if (tableView == taskTableView) {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TodayTaskCell") else {
                return UITableViewCell()
            }
            cell.textLabel?.text = todayTasks[indexPath.row].name
            print("Scheduled: \(todayTasks[indexPath.row].scheduled)")
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title: String = "Empty"
        
        if (tableView == agendaTableView) {
            title = "Already Scheduled"
        } else if (tableView == taskTableView) {
            title = "Unscheduled Tasks"
        }
        
        return title
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as? UITableViewHeaderFooterView
        header?.contentView.backgroundColor = UIColor.init(red: 57/255, green: 104/255, blue: 243/255, alpha: 1.0)
        header?.textLabel?.textColor = UIColor.white
    }
}

extension AgendaViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == taskTableView {
            performSegue(withIdentifier: "TaskScheduleSegue", sender: self)
        }
    }
    
}
