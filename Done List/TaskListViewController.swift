//
//  TaskListViewController.swift
//  Done List
//
//  Created by Mike Nelson on 4/24/17.
//  Copyright © 2017 MJR Designs. All rights reserved.
//

import UIKit
import CoreData

class TaskListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView?
    
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>?

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView?.dataSource = self
        tableView?.delegate = self
        
        initializeFetchedResultsController()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let indexPath = self.tableView?.indexPathForSelectedRow
        let task = self.fetchedResultsController?.object(at: indexPath!)
        
        let detailVC: TaskDetailViewController = segue.destination as! TaskDetailViewController
        
        detailVC.task = task as! TaskMO?
    }

    
    @IBAction func didTapAdd(_ sender: Any) {
        let addAlert = UIAlertController(title: "Add a Task",
                                         message: nil,
                                         preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let ok = UIAlertAction(title: "OK",
                               style: .default) { (action) in
                                
                                if let name = (addAlert.textFields?.first)?.text {
                                    TaskController.sharedInstance.createNewTask(name: name)
                                }
        }
        
        addAlert.addAction(ok)
        addAlert.addAction(cancel)
        
        addAlert.addTextField(configurationHandler: {(textField) in
            textField.placeholder = "Enter task name"
        })
        
        self.present(addAlert, animated: true, completion: nil)
    }
    
    @IBAction func didTapAction(_ sender: Any) {
        displayActionSheet()
    }
    
    func initializeFetchedResultsController() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
        
        let nameSort = NSSortDescriptor(key: "name", ascending: true)
        let prioritySort = NSSortDescriptor(key: "priorityInt", ascending: true)
        
        request.sortDescriptors = [prioritySort, nameSort]
        
        let moc = TaskController.sharedInstance.context
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: moc, sectionNameKeyPath: "priorityInt", cacheName: nil)
        
        self.fetchedResultsController?.delegate = self
        
        do {
            try fetchedResultsController?.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
    }
    
    func displayActionSheet() {
        let actionSheet = UIAlertController(title: "Bulk Actions", message: nil, preferredStyle: .actionSheet)
        
        let completeTasksAction = UIAlertAction(title: "Complete Today's Tasks", style: .default, handler: {
            _ in
            
            let tasks = TaskController.sharedInstance.fetchTasks(byPriority: Priority.Urgent)
        
            TaskController.sharedInstance.bulkUpdate(tasks: tasks, priority: Priority.Completed)
        })
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        actionSheet.addAction(completeTasksAction)
        actionSheet.addAction(cancelAction)
        
        
        self.present(actionSheet, animated: true, completion: nil)
    }

}

extension TaskListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let sections = self.fetchedResultsController?.sections else {
            fatalError("No sections")
        }
        
        let sectionInfo = sections[section]
        
        return sectionInfo.numberOfObjects
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return (self.fetchedResultsController?.sections?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "TaskCell")!
        
        let task = fetchedResultsController?.object(at: indexPath) as! TaskMO
        
        cell.textLabel?.text = task.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as? UITableViewHeaderFooterView
        header?.contentView.backgroundColor = UIColor.init(red: 57/255, green: 104/255, blue: 243/255, alpha: 1.0)
        header?.textLabel?.textColor = UIColor.white
    }
    
}

extension TaskListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "TaskDetailSegue", sender: self)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let task = fetchedResultsController?.object(at: indexPath) as? TaskMO {
                TaskController.sharedInstance.deleteTask(task: task)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sectionName = fetchedResultsController?.sections?[section].name else {
            return "N/A"
        }
        
        var name = "N/A"
        
        switch sectionName {
        case "0":
            name = Priority.Urgent.rawValue
            break
        case "1":
            name = Priority.High.rawValue
            break
        case "2":
            name = Priority.Normal.rawValue
            break
        case "3":
            name = Priority.Low.rawValue
            break
        case "4":
            name = Priority.Completed.rawValue
            break
        default:
            break
        }
        
        return name
        
    }
    
}

extension TaskListViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView?.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        switch type {
        case .insert:
            tableView?.insertSections(IndexSet(integer: sectionIndex), with: .fade)
            break
        case .delete:
            tableView?.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
            break
        default:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            tableView?.insertRows(at: [newIndexPath!], with: .fade)
            break
        case .delete:
            tableView?.deleteRows(at: [indexPath!], with: .fade)
            break
        case .update:
            tableView?.reloadRows(at: [indexPath!], with: .fade)
            break
        case .move:
            tableView?.deleteRows(at: [indexPath!], with: .fade)
            tableView?.insertRows(at: [newIndexPath!], with: .fade)
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView?.endUpdates()
    }
}
