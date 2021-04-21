//
//  Model.swift
//  toDoListFirebase2
//
//  Created by User on 12.04.2021.
//

import Foundation

extension Task {
    enum Keys: String {
        case name
        case isCompleted
        case userId
        case taskId
    }
}

class Task {
    var name: String
    var isCompleted: Bool
    var taskId: String?
    var userId: String?
    
    init?(fromDict: [String: Any]) {
        guard let name = fromDict[Keys.name.rawValue] as? String else { return nil }
        
        self.name = name
        self.isCompleted = fromDict[Keys.isCompleted.rawValue] as? Bool ?? false
        
        if let taskId = fromDict[Keys.taskId.rawValue] as? String {
            self.taskId = taskId
        }
    }
    
    init(name: String, isCompleted: Bool) {
        self.name = name
        self.isCompleted = isCompleted
    }
    
    public func getSerializedObject() -> [String: Any] {
        var dict: [String: Any] = [Keys.name.rawValue: name,
                                   Keys.isCompleted.rawValue: isCompleted]
        if let userId = userId {
            dict[Keys.userId.rawValue] = userId
        }
        
        if let taskId = taskId {
            dict[Keys.taskId.rawValue] = taskId
        }
        return dict
    }
}
