//
//  User.swift
//  MagicTheGatheringCompanion
//
//  Created by Christian Solis-Shepperson on 10/28/18.
//  Copyright © 2018 Christian Solis-Shepperson. All rights reserved.
//

import Foundation

struct User {
    let uid: String
    let wins: Int
    let losses: Int
    let winPercent: Float
    let userName: String
    //let decks: [String]
    let provider: String
    let email: String
    
    init(uid: String, dictionary: [String:Any]) {
        self.uid = uid
        self.wins = dictionary["wins"] as? Int ?? 0
        self.losses = dictionary["losses"] as? Int ?? 0
        self.winPercent = dictionary["winPercent"] as? Float ?? 0
        self.userName = dictionary["userName"] as? String ?? ""
        self.provider = dictionary["provider"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
    }
}
