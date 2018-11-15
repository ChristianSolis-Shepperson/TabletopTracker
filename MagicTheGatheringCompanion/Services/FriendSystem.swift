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
    
    var REF_USERS: DatabaseReference{
        return _REF_USERS
    }
    
    /** The Firebase reference to the current user tree */
    var CURRENT_USER_REF: DatabaseReference {
        let id = Auth.auth().currentUser!.uid
        return REF_USERS.child("\(id)")
    }
    
    /** The current user's id */
    var CURRENT_USER_ID: String {
        let id = Auth.auth().currentUser!.uid
        return id
    }
    
    /** Sends a friend request to the user with the specified id */
    func sendRequestToUser(_ userID: String) {
        REF_USERS.child(userID).child("requests").child(CURRENT_USER_ID).setValue(true)
    }
    
    /** Unfriends the user with the specified id */
    func removeFriend(_ userID: String) {
        CURRENT_USER_REF.child("friends").child(userID).removeValue()
        REF_USERS.child(userID).child("friends").child(CURRENT_USER_ID).removeValue()
    }
    
    /** Accepts a friend request from the user with the specified id */
    func acceptFriendRequest(_ userID: String) {
        CURRENT_USER_REF.child("requests").child(userID).removeValue()
        CURRENT_USER_REF.child("friends").child(userID).setValue(true)
        REF_USERS.child(userID).child("friends").child(CURRENT_USER_ID).setValue(true)
        REF_USERS.child(userID).child("requests").child(CURRENT_USER_ID).removeValue()
    }
    
}
