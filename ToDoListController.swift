//
//  ToDoListController.swift
//  toDoListFirebase2
//
//  Created by User on 12.04.2021.
//

import Foundation
import UIKit
import FirebaseFirestore
import Firebase
import FirebaseFirestoreSwift

class ToDoListController: UIViewController {
    private let taskService = TaskService.shared
    
    
    // MARK: - Controller Life Cycle
    
    override func viewDidLoad(){
        super.viewDidLoad()
        toDoTableView.delegate = self
        toDoTableView.dataSource = self
    }
    
    //MARK: - Actions
    
    @IBAction func editButton(_ sender: Any) {
        toDoTableView.setEditing(!toDoTableView.isEditing, animated: true)
    }
    @IBOutlet weak var toDoTableView: UITableView!
    
    @IBAction func pushAddAction(_ sender: Any){
        let alertController = UIAlertController(title: "Create new item", message: nil , preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "New item name"
        }
        let alertActionCancel = UIAlertAction(title: "Cancel", style: .destructive) { (alert) in}
        let alertActionCreate = UIAlertAction(title: "Create", style: .default) { (alert) in
            
            if(alertController.textFields![0].text == ""){
                return
            }else{
                let newItem = alertController.textFields![0].text
                guard let userId = Auth.auth().currentUser?.uid else { return }
                
                let task = Task.init(name: newItem ?? "", isCompleted: false)
                task.userId = userId
                let taskId = FirebaseProvider.shared.createTask(task)
                task.taskId = taskId
                
                self.taskService.addItem(task: task)
                
                self.toDoTableView.reloadData()
            }
        }
        
        alertController.addAction(alertActionCancel)
        alertController.addAction(alertActionCreate)
        present(alertController, animated: false, completion: nil)
    }
}

//MARK: - Extensions

extension ToDoListController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView)-> Int{
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskService.toDoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let currentItem = taskService.toDoList[indexPath.row]
        cell.textLabel?.text = currentItem[Task.Keys.name.rawValue] as? String
        if (currentItem[Task.Keys.isCompleted.rawValue] as? Bool) == true {
            cell.imageView?.image = UIImage(named: "check")
            
        } else {
            cell.imageView?.image = UIImage(named: "uncheck")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task = taskService.removeItem(atindex: indexPath.row)
        
            if let taskId = task?.taskId {
                FirebaseProvider.shared.deleteData(taskId: taskId)
            }
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }else if(editingStyle == .insert){
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        toDoTableView.deselectRow(at: indexPath, animated: true)
        if taskService.changeState(at: indexPath.row) {
            toDoTableView.cellForRow(at: indexPath)?.imageView?.image = UIImage(named: "check")
            
                        let task = taskService.getElementByInd(at: indexPath.row)
                        if let taskId = task?.taskId  {
                            FirebaseProvider.shared.changeCompletionTrue(taskId: taskId)
                        }
        }else{
            toDoTableView.cellForRow(at: indexPath)?.imageView?.image = UIImage(named: "uncheck")
            
                        let task = taskService.getElementByInd(at: indexPath.row)
                        if let taskId = task?.taskId {
                            FirebaseProvider.shared.changeCompletionFalse(taskId: taskId)
                        }
        }
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        taskService.moveItem(fromIndex: sourceIndexPath.row, toIndex: destinationIndexPath.row)
        toDoTableView.reloadData()
    }
}






