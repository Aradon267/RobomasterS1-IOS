//
//  WriteData.swift
//  Robomaster
//
//  Created by Arad Donenfeld on 01/10/2022.
//

import Foundation
import FirebaseDatabase
import FirebaseDatabaseSwift

///  The class that writes any changes to the Firebase.
class WriteData: ObservableObject{
    private let ref = Database.database().reference()
    
    /// The function will write a new user to the Firebase
    /// - Parameter userData: The user to add to the Firebase.
    func writeNewUser(userData: User){
        ref.child("allUsers").childByAutoId().setValue(userData.toDictionary)
    }
    
    /// The function will remove a program from the Firebase.
    /// - Parameter programData: The program to remove.
    func removeProgram(programData: Program){
        ref.child("allPrograms").child(programData.progid).removeValue()
    }
    
    /// The function will write a new program to the Firebase.
    /// - Parameter programData: The program to add.
    func writeNewProgram(programData: Program){
        let uid = ref.child("allPrograms").childByAutoId().key
        programData.progid = uid!
        ref.child("allPrograms").child(uid!).setValue(programData.toDictionary)
    }
}
