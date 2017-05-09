//
//  PriorityViewController.swift
//  Done List
//
//  Created by Mike Nelson on 4/30/17.
//  Copyright © 2017 MJR Designs. All rights reserved.
//

import UIKit

class PriorityViewController: UIViewController {
    
    @IBOutlet weak var priorityPicker: UIPickerView?
    
    let priorities = [Priority.Urgent.rawValue,
                      Priority.High.rawValue,
                      Priority.Normal.rawValue,
                      Priority.Low.rawValue,
                      Priority.Completed.rawValue]
    
    var task: TaskMO?

    override func viewDidLoad() {
        super.viewDidLoad()

        // PickerView Setup
        let position = Int((task?.priorityInt)!)
        
        priorityPicker?.delegate = self
        priorityPicker?.dataSource = self
        priorityPicker?.selectRow(position,
                                  inComponent: 0,
                                  animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func didTapDone(_ sender: Any) {
        self.dismiss(animated: true, completion: {
            TaskController.sharedInstance.updateTask(task: self.task!)
        })
    }
    @IBAction func didTapCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}

extension PriorityViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("Selected \(priorities[row])")
        task?.priority = priorities[row]
        task?.priorityInt = Int32(row)
    }
    
}

extension PriorityViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return priorities.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return priorities[row]
    }
    
}

