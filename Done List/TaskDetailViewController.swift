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
    @IBOutlet weak var tableView: UITableView?
    
    var task: TaskMO?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set View title
        self.title = task?.name

        // Populate textField
        nameTextField?.text = task?.name
        
        // TableView Setup
        tableView?.dataSource = self
        tableView?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView?.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        task?.name = nameTextField?.text
        TaskController.sharedInstance.updateTask(task: task!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PrioritySegue" {
            let targetVC: PriorityViewController = (segue.destination as? PriorityViewController)!
            targetVC.task = self.task
        }
    }
    
    func setUpPriorityCell(indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView?.dequeueReusableCell(withIdentifier: "PriorityCell") else {
            return UITableViewCell()
        }
        cell.textLabel?.text = task?.priority
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func setUpDateCell(indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView?.dequeueReusableCell(withIdentifier: "DateCell") else {
            return UITableViewCell()
        }
        
        let createdDate = task?.createdDate as? Date
        let dueDate = task?.dueDate as? Date
        
        let dateFormat = DateFormatter()
        dateFormat.dateStyle = .medium
        dateFormat.timeStyle = .medium
        
        if indexPath.row == 0 {
            cell.textLabel?.text = "Created: \(dateFormat.string(from: createdDate!))"
        } else {
            cell.textLabel?.text = "Due: \(dateFormat.string(from: dueDate!))"
            cell.accessoryType = .disclosureIndicator
        }
        
        return cell
    }
   
}

extension TaskDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell
        let section = indexPath.section
        
        if section == 0 {
            cell = setUpPriorityCell(indexPath: indexPath)
        } else {
            cell = setUpDateCell(indexPath: indexPath)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        }
        
        return 2
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Priority"
        }
        
        return "Dates"
    }
}

extension TaskDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        
        if section == 0 {
            self.performSegue(withIdentifier: "PrioritySegue", sender: self)
        }
    }
    
}
