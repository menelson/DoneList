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
    
    var calendars = [EKCalendar]()
    var agendaEvents = [EKEvent]()
    static let ONE_DAY_INTERVAL = 24 * 3600 - 1
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(AgendaViewController.agendaRefresh), for: UIControlEvents.valueChanged)
        
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupEventsData()
        
        agendaTableView?.delegate = self
        agendaTableView?.dataSource = self
        agendaTableView?.addSubview(self.refreshControl)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupEventsData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func agendaRefresh(refreshControl: UIRefreshControl) {
        setupEventsData()
        self.agendaTableView?.reloadData()
        refreshControl.endRefreshing()
    }
    
    func setupEventsData() {
        self.calendars = [EKCalendar]()
        self.getPreferredCalendars()
        self.agendaEvents = [EKEvent]()
        self.getTodaysEventsFromCalendars(calendars: calendars)
        self.agendaTableView?.reloadData()
    }
    
    func getPreferredCalendars() {
        let calendarIds = DLCalendarDefaults.init().getAvailableCalendars()
        
        for id in calendarIds {
            let calendar = DLCalendarService.init().fetchCalendarById(identifier: id)
            calendars.append(calendar)
        }
    }
    
    func getTodaysEventsFromCalendars(calendars: [EKCalendar]) {
        let eventStore = EKEventStore()
        let today = Date()
        let startDate = DLCalendarService.init().getStartDate(date: today)
        let endDate = DLCalendarService.init().getEndDate(date: today)
        
        let eventSearch = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: self.calendars)
        
        agendaEvents = eventStore.events(matching: eventSearch)
    }
    
    func getFormattedDateString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        
        return formatter.string(from: date)
    }
        
}

extension AgendaViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return agendaEvents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AgendaCell") as? AgendaTableViewCell else {
            return AgendaTableViewCell()
        }
        
        cell.eventTitle.text = agendaEvents[indexPath.row].title
        cell.startTimeLabel.text = getFormattedDateString(date: agendaEvents[indexPath.row].startDate)
        cell.durationLabel.text = "30 mins"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Already Scheduled"
    }
}

extension AgendaViewController: UITableViewDelegate {
    
}
