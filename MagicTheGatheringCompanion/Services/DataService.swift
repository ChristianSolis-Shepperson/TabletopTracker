//
//  DataService.swift
//  MagicTheGatheringCompanion
//
//  Created by Christian Solis-Shepperson on 6/3/18.
//  Copyright © 2018 Christian Solis-Shepperson. All rights reserved.
//

import Foundation
import Firebase

let DB_BASE = Database.database().reference()

class DataService{
    
    static let instance = DataService()
    
    //Private variables  to reference database information
    private var _REF_BASE = DB_BASE
    private var _REF_USERS = DB_BASE.child("users")
    private var _REF_FRIENDS = DB_BASE.child("friends")
    
    //Public variables to reference the private database references
    var REF_BASE: DatabaseReference{
        return _REF_BASE
    }
    
    var REF_USERS: DatabaseReference{
        return _REF_USERS
    }
    
    var REF_FRIENDS: DatabaseReference{
        return _REF_FRIENDS
    }
    
    
    func createDBUser(uid: String, userData: Dictionary<String,Any>){
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
    func getProviderUID(handler: @escaping (_ username: String) -> ()){
        let activeUserID = Auth.auth().currentUser?.uid
        handler(activeUserID!)
    }
    
    func getUsername(handler: @escaping (_ username: String) -> ()){
        var username = ""
        
        //Gets the provider UID and retreives username inside closure from the database
        getProviderUID { (pID) in
            self.REF_USERS.child(pID).observe(.value, with: { (userSnapshot) in
                //print(userSnapshot)
                
                let value = userSnapshot.value as? NSDictionary
                let returnedUsername = value?["userName"] as? String ?? ""
                username = returnedUsername
                //print(username)
                handler(username)
            })
        }
    }
    
    func getUsernames(forID userID: String, handler: @escaping (_ username: String) -> ()){
        var username = ""
        
        REF_USERS.child(userID).observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            guard let name = snapshot.childSnapshot(forPath: "userName").value as? String else {return}
            username = name
        })
        handler(username)
    }
    
    func getIds(forUsernames usernames: [String], handler: @escaping (_ uidArray: [String])->()){
        REF_USERS.observe(.value) { (userSnapshot) in
            var idArray = [String]()
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else {return}
            for user in userSnapshot{
                guard let userName = user.childSnapshot(forPath: "userName").value as? String else {return}
                if usernames.contains(userName){
                    print("here is userid \(user.key)")
                    idArray.append(user.key)
                }
            }
            handler(idArray)
        }
    }
}
