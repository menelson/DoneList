//
//  TaskTableViewCell.swift
//  Done List
//
//  Created by Mike Nelson on 5/24/17.
//  Copyright © 2017 MJR Designs. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    
    @IBOutlet weak var taskTitle: UILabel!
    @IBOutlet weak var taskCreatedDate: UILabel!
    @IBOutlet weak var taskAge: UILabel!
    
    var task: TaskMO?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureView(withTask task: TaskMO) {
        taskTitle.text = task.name
        
        let age = TaskController.sharedInstance.getTaskAge(task: task)
        taskAge.text = "\(age) days old"
        
        taskCreatedDate.text = "Due Date: \(self.fetchFormattedTaskDueDate(task: task))"

    }
    
    func fetchFormattedTaskDueDate(task: TaskMO) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        
        if task.dueDate == (Date.distantFuture as NSDate) {
            return "NO DUE DATE"
        }
        return formatter.string(from: task.dueDate! as Date)
    }

}
