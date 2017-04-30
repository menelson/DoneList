//
//  TaskDetailViewController.swift
//  Done List
//
//  Created by Mike Nelson on 4/28/17.
//  Copyright © 2017 MJR Designs. All rights reserved.
//

import UIKit

class TaskDetailViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField?
    @IBOutlet weak var priorityPicker: UIPickerView?
    @IBOutlet weak var tableView: UITableView?
    
    var task: TaskMO?
    
    let priorities = [Priority.Urgent.rawValue,
                      Priority.High.rawValue,
                      Priority.Normal.rawValue,
                      Priority.Low.rawValue]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set View title
        self.title = task?.name

        // Populate textField
        nameTextField?.text = task?.name
        
        // PickerView Setup
        let position = Int((task?.priorityInt)!)
        
        priorityPicker?.delegate = self
        priorityPicker?.dataSource = self
        priorityPicker?.selectRow(position,
                                  inComponent: 0,
                                  animated: false)
        
        // TableView Setup
        tableView?.dataSource = self
        tableView?.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        task?.name = nameTextField?.text
        TaskController.sharedInstance.updateTask(task: task!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
   
}

extension TaskDetailViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("Selected \(priorities[row])")
        task?.priority = priorities[row]
        task?.priorityInt = Int32(row)
    }
    
}

extension TaskDetailViewController: UIPickerViewDataSource {
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

extension TaskDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DateCell")
        
        let createdDate = task?.createdDate as? Date
        let dueDate = task?.dueDate as? Date
        
        let dateFormat = DateFormatter()
        dateFormat.dateStyle = .medium
        dateFormat.timeStyle = .medium
        
        
        if indexPath.row == 0 {
            cell?.textLabel?.text = "Created: \(dateFormat.string(from: createdDate!))"
        } else {
            cell?.textLabel?.text = "Due: \(dateFormat.string(from: dueDate!))"
            cell?.accessoryType = .disclosureIndicator
        }

        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

extension TaskDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
    }
    
}
