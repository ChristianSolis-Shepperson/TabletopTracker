//
//  User.swift
//  MagicTheGatheringCompanion
//
//  Created by Christian Solis-Shepperson on 10/28/18.
//  Copyright © 2018 Christian Solis-Shepperson. All rights reserved.
//

import Foundation

class User {
    
    var email: String!
    var id: String!
    var userName: String!
    var playerTurn: Bool
    
    init(userEmail: String, userID: String, userName: String) {
        self.email = userEmail
        self.id = userID
        self.userName = userName
        playerTurn = false
    }
}
