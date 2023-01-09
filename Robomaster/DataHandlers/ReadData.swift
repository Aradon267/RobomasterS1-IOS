//
//  ReadData.swift
//  Robomaster
//
//  Created by Arad Donenfeld on 30/09/2022.
//

import Foundation
import FirebaseDatabase
import FirebaseDatabaseSwift

/// The class that reads data from the Firebase.
class ReadData: ObservableObject{
    var ref = Database.database().reference()
    
    @Published
    /// A list of users from the Firebase.
    var listUsers = [User]()
    
    @Published
    /// A list of programs from the Firebase.
    var listPrograms = [Program]()
    
    /// The function will read all users from the Firebase to one list.
    func observerListUsers(){
        ref.child("allUsers").observe(.value) { parentSnapshot in
            guard let children = parentSnapshot.children.allObjects as? [DataSnapshot] else {
                return
            }
            
            self.listUsers = children.compactMap({snapshot in
                return try? snapshot.data(as: User.self)
            })
        }
    }
    
    /// The function will read all programs from the Firebase to one list.
    func observerListPrograms(){
        ref.child("allPrograms").observe(.value) { parentSnapshot in
            guard let children = parentSnapshot.children.allObjects as? [DataSnapshot] else {
                return
            }
            
            self.listPrograms = children.compactMap({snapshot in
                return try? snapshot.data(as: Program.self)
            })
        }
    }
}
