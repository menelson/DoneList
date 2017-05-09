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
    
    var calendars = [EKCalendar]()
    var agendaEvents = [EKEvent]()
    static let ONE_DAY_INTERVAL = 24 * 3600
    
    @IBOutlet weak var agendaTableView: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getPreferredCalendars()
        getTodaysEventsFromCalendars(calendars: calendars)
        
        agendaTableView?.delegate = self
        agendaTableView?.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        let startDate = Date()
        let endDate = startDate.addingTimeInterval(TimeInterval(AgendaViewController.ONE_DAY_INTERVAL))
        
        let eventSearch = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: self.calendars)
        
        agendaEvents = eventStore.events(matching: eventSearch)
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AgendaCell") else {
            return UITableViewCell()
        }
        
        cell.textLabel?.text = agendaEvents[indexPath.row].title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Already Scheduled"
    }
}

extension AgendaViewController: UITableViewDelegate {
    
}
