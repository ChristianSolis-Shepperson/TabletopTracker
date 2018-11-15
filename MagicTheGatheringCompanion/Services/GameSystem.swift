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

class GameSystem {
    
    static let system = GameSystem()
    
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
    
}
