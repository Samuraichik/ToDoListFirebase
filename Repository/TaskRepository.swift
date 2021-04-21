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
    
    func getData(userId: Any) {
        db.collection("Tasks").whereField("user id", isEqualTo: "\(userId)")
            .getDocuments(){ (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    removeAll()
                    for document in querySnapshot!.documents {
                        addItem(nameItem: "\(document["Taskname"]!)", isCompleted: document["IsTaskCompleted"] as! Bool)
                    }
                    
                }
            }
    }
    
    func deleteData(index: Int){
        let temp = getElementById(at: index)
        print("\(temp)")
        db.collection("Tasks").whereField("Taskname", isEqualTo: "\(temp)")
            .getDocuments(){ (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents{
                        FirebaseProvider.db.collection("Tasks").document("\(document.documentID)").delete() { err in
                            
                            if let err = err {
                                print("Error removing document: \(err)")
                            } else {
                                print("Document successfully removed!")
                            }
                        }
                        print("\(document.documentID)")
                        
                    }
                }
            }
    }
}

