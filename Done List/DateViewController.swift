//
//  DateViewController.swift
//  Done List
//
//  Created by Mike Nelson on 5/1/17.
//  Copyright © 2017 MJR Designs. All rights reserved.
//

import UIKit

class DateViewController: UIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker?
    @IBOutlet weak var ageLabel: UILabel?
    
    var task: TaskMO?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDatePicker()
        setupAgeLabel()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupDatePicker() {
        if task?.dueDate != (Date.distantFuture as NSDate) {
            datePicker?.date = (task?.dueDate)! as Date
        }
    }
    
    func setupAgeLabel() {
        let calendar = Calendar.current
        let today = Date.init()
        let days = calendar.dateComponents([.day], from: (task?.createdDate)! as Date, to: today)
        self.ageLabel?.text = "\(days.day ?? 0)"
    }
    
    @IBAction func didTapCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
   
    @IBAction func didTapDone(_ sender: Any) {
        self.dismiss(animated: true, completion: {
            TaskController.sharedInstance.updateTask(task: self.task!)
        })
    }

    @IBAction func dueDateChanged(_ sender: Any) {
        task?.dueDate = datePicker?.date as NSDate?
    }
}
