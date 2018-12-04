//
//  FriendSystem.swift
//  MagicTheGatheringCompanion
//
//  Created by Christian Solis-Shepperson on 11/5/18.
//  Copyright © 2018 Christian Solis-Shepperson. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth

class FriendSystem {
    
    static let system = FriendSystem()
    
    //Private variables  to reference database information
    private var _REF_BASE = DB_BASE
    private var _REF_USERS = DB_BASE.child("users")
    
    //The Firebase reference to the users tree
    var REF_USERS: DatabaseReference{
        return _REF_USERS
    }
    
    //The Firebase reference to the current user tree
    var CURRENT_USER_REF: DatabaseReference {
        let id = Auth.auth().currentUser!.uid
        return REF_USERS.child("\(id)")
    }
    
    //The current user's id
    var CURRENT_USER_ID: String {
        let id = Auth.auth().currentUser!.uid
        return id
    }
    
    // The Firebase reference to the current user's friend tree
    var CURRENT_USER_FRIENDS_REF: DatabaseReference {
        return CURRENT_USER_REF.child("friends")
    }
    
    //The Firebase reference to the current user's friend request tree
    var CURRENT_USER_REQUESTS_REF: DatabaseReference {
        return CURRENT_USER_REF.child("requests")
    }
    
    // Gets the User object for the specified user id
    func getUser(_ userID: String, completion: @escaping (User) -> Void) {
        REF_USERS.child(userID).observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            let email = snapshot.childSnapshot(forPath: "email").value as! String
            let id = snapshot.key
            let userName = snapshot.childSnapshot(forPath: "userName").value as! String
            completion(User(userEmail: email, userID: id, userName: userName))
        })
    }
    
    // Sends a friend request to the user with the specified id
    func sendRequestToUser(_ userID: String) {
        REF_USERS.child(userID).child("requests").child(CURRENT_USER_ID).setValue(true)
    }
    
    // Accepts a friend request from the user with the specified id
    func acceptFriendRequest(_ userID: String) {
        CURRENT_USER_REF.child("requests").child(userID).removeValue()
        CURRENT_USER_REF.child("friends").child(userID).setValue(true)
        REF_USERS.child(userID).child("friends").child(CURRENT_USER_ID).setValue(true)
        REF_USERS.child(userID).child("requests").child(CURRENT_USER_ID).removeValue()
    }
    
    func acceptGameRequest(){
        
    }
    
    
    // The list of all friends of the current user
    var friendList = [User]()
    
    /** Adds a friend observer. The completion function will run every time this list changes, allowing you
     to update your UI. */
    func addFriendObserver(_ update: @escaping () -> Void) {
        CURRENT_USER_FRIENDS_REF.observe(DataEventType.value, with: { (snapshot) in
            self.friendList.removeAll()
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                let id = child.key
                self.getUser(id, completion: { (user) in
                    self.friendList.append(user)
                    update()
                })
            }
            // If there are no children, run completion here instead
            if snapshot.childrenCount == 0 {
                update()
            }
        })
    }
    
    // Removes the friend observer
    func removeFriendObserver() {
        CURRENT_USER_FRIENDS_REF.removeAllObservers()
    }
    
    
    
    // The list of all friend requests the current user has
    var requestList = [User]()
    
    /** Adds a friend request observer. The completion function will run every time this list changes, allowing you
     to update your UI. */
    func addRequestObserver(_ update: @escaping () -> Void) {
        CURRENT_USER_REQUESTS_REF.observe(DataEventType.value, with: { (snapshot) in
            self.requestList.removeAll()
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                let id = child.key
                self.getUser(id, completion: { (user) in
                    self.requestList.append(user)
                    update()
                })
            }
            // If there are no children, run completion here instead
            if snapshot.childrenCount == 0 {
                update()
            }
        })
    }
    
    //Removes the friend request observer
    func removeRequestObserver() {
        CURRENT_USER_FRIENDS_REF.removeAllObservers()
    }
}
