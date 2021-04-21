//
//  TaskRepository.swift
//  toDoListFirebase2
//
//  Created by User on 12.04.2021.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct FirebaseProvider {
    static let shared = FirebaseProvider()
    
    private let db = Firestore.firestore()
    private var tasksCollection: CollectionReference { return db.collection("Tasks") }
    
    private init() {}
    
    func getData(userId: Any) {
        tasksCollection
            .whereField(Task.Keys.userId.rawValue, isEqualTo: "\(userId)")
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    TaskService.shared.removeAll()
                    for document in querySnapshot!.documents {
                        if let task = Task(fromDict: document.data())  {
                            task.taskId = document.documentID
                            TaskService.shared.addItem(task: task)
                            
                            //                            print(task.taskId)
                        }
                    }
                    print("ident fire")
                }
            }
    }
    
    func createTask(_ task: Task) -> String {
        let ref = tasksCollection.addDocument(data: task.getSerializedObject())
        return ref.documentID
    }
    
    func changeCompletionTrue(taskId: String){
        tasksCollection.document(taskId).updateData([
            "isCompleted" : true
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
    func changeCompletionFalse(taskId: String){
        tasksCollection.document(taskId).updateData([
            "isCompleted" : false
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
    func deleteData(taskId: String) {
        tasksCollection.document(taskId).delete(completion: { (error) in
            if let error = error {
                print("Failed to delete, error: \(error)")
            } else {
                print("Successfully deleted")
            }
        })
    }
}

