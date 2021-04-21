//
//  TaskService.swift
//  toDoListFirebase2
//
//  Created by User on 17.04.2021.
//

import Foundation

class TaskService {
    public static var shared = TaskService()
    
    private init() {}
    
    var toDoList: [[String: Any]] {
        set {
            UserDefaults.standard.set(newValue, forKey: "ToDoDataKey")
            UserDefaults.standard.synchronize()
        }
        
        get {
            return UserDefaults.standard.array(forKey: "ToDoDataKey") as? [[String: Any]] ?? []
        }
    }

    func addItem(task: Task){
//        print(task.taskId)
        toDoList.append(task.getSerializedObject())
    }
    
    func getElementByInd(at ind: Int) -> Task? {
        return Task(fromDict: toDoList[ind])
    }
    
    func removeItem(atindex: Int) -> Task? {
        return Task(fromDict: toDoList.remove(at: atindex))
    }
    
    func removeAll(){
        toDoList.removeAll()
    }
    
    func changeState(at item: Int) -> Bool{
        toDoList[item][Task.Keys.isCompleted.rawValue] = !((toDoList[item][Task.Keys.isCompleted.rawValue] as! Bool))
        
        return toDoList[item][Task.Keys.isCompleted.rawValue] as! Bool
    }

    func moveItem(fromIndex: Int, toIndex: Int) {
        let from = toDoList[fromIndex]
        toDoList.remove(at: fromIndex)
        toDoList.insert(from, at: toIndex)
    }
}
