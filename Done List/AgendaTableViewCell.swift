//
//  AgendaTableViewCell.swift
//  Done List
//
//  Created by Mike Nelson on 5/11/17.
//  Copyright © 2017 MJR Designs. All rights reserved.
//

import UIKit
import EventKit

class AgendaTableViewCell: UITableViewCell {

    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureView(withEvent event: EKEvent) {
        eventTitle.text = event.title
        
        startTimeLabel.text = getFormattedTimeString(date: event.startDate)
        
        let duration = DLCalendarService.init().calculateDuration(event: event) / 60
        
        durationLabel.text = "\(Int(duration)) mins"
    }
    
    func getFormattedTimeString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        
        return formatter.string(from: date)
    }

}
