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
    private var _REF_GAME = DB_BASE.child("game")
    
    //variable to hold game id's
    private var newGameID = DatabaseReference()
    
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
    
    /** Base GameID */
    var REF_BASE_GAME: DatabaseReference {
        return _REF_GAME
    }
    
    /** The game id */
    var REF_GAME: DatabaseReference {
        let game = newGameID
        return _REF_GAME.child("\(game)")
    }
    
    /** Current game id */
    var CURRENT_GAME: DatabaseReference {
        return newGameID
    }
    
    var CURRENT_USER_GAME: DatabaseReference{
        let id = Auth.auth().currentUser!.uid
        return newGameID.child("\(id)")
    }
    
    func createNewGameID(){
        newGameID = self._REF_GAME.child("demo")
        //newGameID = self._REF_GAME.childByAutoId()
    }
    
    func createGame(playerNames: [String], gameType: Int, handler : @escaping (_ gameCreated: Bool)-> ()){
        
        let gameCreator = Auth.auth().currentUser?.uid
        //convert usernames into UID
        DataService.instance.getIds(forUsernames: playerNames) { (returnedIDs) in
            //creates a common node for games, per game creation
            self.createNewGameID()
            
            if gameType == 1 {
                for id in returnedIDs{
                    self.newGameID.child(id).updateChildValues(["gameType":1, "health": 20, "commanderDamage":0, "infectDamage":0, "floatMana":0, "playerTurn": false, "createdBy": Auth.auth().currentUser?.uid])
                }
            } else if gameType ==  2 {
                for id in returnedIDs{
                    self.newGameID.child(id).updateChildValues(["gameType":2, "health": 40, "commanderDamage":0, "infectDamage":0, "floatMana":0, "playerTurn": false,"createdBy": Auth.auth().currentUser?.uid])
                }
            }
            self.newGameID.child(gameCreator!).child("playerTurn").setValue(true)
        }
        handler(true)
    }
    
    // Sends a game request to the user with the specified id
    func sendGameRequestToUser(_ userID: String) {
        CURRENT_GAME.child(userID).child("gameRequests").child(CURRENT_USER_ID).setValue(true)
    }
    
    // Accepts a game request from the user with the specified id
    func acceptGameRequest(_ userID: String) {
        CURRENT_GAME.child("gameRequests").child(userID).removeValue()
    }
    
    // The list of all friend requests the current user has
    var requestList = [User]()
    
    /** Adds a friend request observer. The completion function will run every time this list changes, allowing you
     to update your UI. */
    func addRequestObserver(_ update: @escaping () -> Void) {
        CURRENT_GAME.child("gameRequests").observe(DataEventType.value, with: { (snapshot) in
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
        CURRENT_GAME.child("gameRequests").removeAllObservers()
    }
    
    // Gets the User object for the specified user id
    func getUser(_ userID: String, completion: @escaping (User) -> Void) {
        REF_USERS.child(userID).observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            let email = "Game invite" //snapshot.childSnapshot(forPath: "email").value as! String
            let id = snapshot.key
            let userName =  "" //snapshot.childSnapshot(forPath: "userName").value as! String
            completion(User(userEmail: email, userID: id, userName: userName))
        })
    }
    
    func incrementHealth(handler: @escaping (_ playerHealth: String)->()){
        print("working")
        var returnHealth = ""
        GameSystem.system.REF_BASE_GAME.child("demo").child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value) { (userSnapshot) in
            print("downloaded")
            var health = userSnapshot.childSnapshot(forPath: "health").value as! Int
            health+=1
            print("added")
            GameSystem.system.REF_BASE_GAME.child("demo").child((Auth.auth().currentUser?.uid)!).child("health").setValue(health)
            returnHealth = "\(health)"
            print("returned")
        }
        handler(returnHealth)
    }
    
    func decrementHealth(handler: @escaping (_ playerHealth: String)->()){
        var returnHealth = ""
        GameSystem.system.REF_BASE_GAME.child("demo").child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value) { (userSnapshot) in
            var health = userSnapshot.childSnapshot(forPath: "health").value as! Int
            health-=1
            GameSystem.system.REF_BASE_GAME.child("demo").child((Auth.auth().currentUser?.uid)!).child("health").setValue(health)
            returnHealth = "\(health)"
        }
        handler(returnHealth)
    }
    
    func incrementCommandDmg(handler: @escaping (_ playerHealth: String)->()){
        var returnDmg = ""
        GameSystem.system.REF_BASE_GAME.child("demo").child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value) { (userSnapshot) in
            var dmg = userSnapshot.childSnapshot(forPath: "commanderDamage").value as! Int
            dmg+=1
            GameSystem.system.REF_BASE_GAME.child("demo").child((Auth.auth().currentUser?.uid)!).child("commanderDamage").setValue(dmg)
            returnDmg = "\(dmg)"
        }
        handler(returnDmg)
    }
    
    func decrementCommandDmg(handler: @escaping (_ playerHealth: String)->()){
        var returnDmg = ""
        GameSystem.system.REF_BASE_GAME.child("demo").child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value) { (userSnapshot) in
            var dmg = userSnapshot.childSnapshot(forPath: "commanderDamage").value as! Int
            dmg-=1
            GameSystem.system.REF_BASE_GAME.child("demo").child((Auth.auth().currentUser?.uid)!).child("commanderDamage").setValue(dmg)
            returnDmg = "\(dmg)"
        }
        handler(returnDmg)
    }
    
    func incrementMana(handler: @escaping (_ playerMana: String)->()){
        var returnMana = ""
        GameSystem.system.REF_BASE_GAME.child("demo").child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value) { (userSnapshot) in
            var mana = userSnapshot.childSnapshot(forPath: "floatMana").value as! Int
            mana+=1
            GameSystem.system.REF_BASE_GAME.child("demo").child((Auth.auth().currentUser?.uid)!).child("floatMana").setValue(mana)
            returnMana = "\(mana)"
        }
        handler(returnMana)
    }
    
    func decrementMana(handler: @escaping (_ playerMana: String)->()){
        var returnMana = ""
        GameSystem.system.REF_BASE_GAME.child("demo").child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value) { (userSnapshot) in
            var mana = userSnapshot.childSnapshot(forPath: "floatMana").value as! Int
            mana-=1
            GameSystem.system.REF_BASE_GAME.child("demo").child((Auth.auth().currentUser?.uid)!).child("floatMana").setValue(mana)
            returnMana = "\(mana)"
        }
        handler(returnMana)
    }
    
    func incrementInfect(handler: @escaping (_ playerInfect: String)->()){
        var returnInfect = ""
        GameSystem.system.REF_BASE_GAME.child("demo").child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value) { (userSnapshot) in
            var dmg = userSnapshot.childSnapshot(forPath: "infectDamage").value as! Int
            dmg+=1
            GameSystem.system.REF_BASE_GAME.child("demo").child((Auth.auth().currentUser?.uid)!).child("infectDamage").setValue(dmg)
            returnInfect = "\(dmg)"
        }
        handler(returnInfect)
    }
    
    func decrementInfect(handler: @escaping (_ playerInfect: String)->()){
        var returnInfect = ""
        GameSystem.system.REF_BASE_GAME.child("demo").child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value) { (userSnapshot) in
            var dmg = userSnapshot.childSnapshot(forPath: "infectDamage").value as! Int
            dmg-=1
            GameSystem.system.REF_BASE_GAME.child("demo").child((Auth.auth().currentUser?.uid)!).child("infectDamage").setValue(dmg)
            returnInfect = "\(dmg)"
        }
        handler(returnInfect)
    }
    
    func incrementTurn(forUsername usernames: [String],_ handler: @escaping()->()){
        //get id for activePlayer and previousPlayer and update in database
        DataService.instance.getIds(forUsernames: usernames) { (returnedIds) in
            print(returnedIds)
            let currentID = returnedIds[0]
            let prevID = returnedIds[1]
            
            print(GameSystem.system.CURRENT_GAME)
            print(GameSystem.system.REF_BASE_GAME.child("demo").child("\(prevID)").child("playerTurn"))
            print( GameSystem.system.REF_BASE_GAME.child("demo").child("\(currentID)").child("playerTurn"))
            
            GameSystem.system.REF_BASE_GAME.child("demo").child("\(prevID)").child("playerTurn").setValue(false)
            GameSystem.system.REF_BASE_GAME.child("demo").child("\(currentID)").child("playerTurn").setValue(true)
        }
        handler()
    }
}
