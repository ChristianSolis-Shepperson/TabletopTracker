//
//  Game.swift
//  MagicTheGatheringCompanion
//
//  Created by Christian Solis-Shepperson on 12/1/18.
//  Copyright © 2018 Christian Solis-Shepperson. All rights reserved.
//

import Foundation
import Firebase

class Game {
    
    var mana: Int
    var health: Int
    var commanderDamage: Int
    var infectDamage: Int
    var floatMana: Int
    var playerTurn: Bool
    
    init(mana: Int, health: Int, commanderDamage: Int, infectDamage: Int, floatMana: Int, playerTurn: Bool) {
        self.mana = mana
        self.health = health
        self.commanderDamage = commanderDamage
        self.infectDamage = infectDamage
        self.floatMana = floatMana
        self.playerTurn = playerTurn
    }
}
