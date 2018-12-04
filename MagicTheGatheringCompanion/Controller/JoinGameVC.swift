//
//  JoinGameViewController.swift
//  MagicTheGatheringCompanion
//
//  Created by Christian Solis-Shepperson on 12/3/18.
//  Copyright © 2018 Christian Solis-Shepperson. All rights reserved.
//

import UIKit
import Firebase

class JoinGameVC: UIViewController {

    @IBOutlet weak var lobbyNameTxt: UITextField!
    @IBOutlet weak var standardGameBtn: UIButton!
    @IBOutlet weak var commanderGameBtn: UIButton!
    
    var gameType = 0
    var gameHealth = 0
    var commandDmg = 0
    var players = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! GameVC
        vc.gameType = self.gameType
        vc.health = self.gameHealth
        vc.commandDmg = 0
        vc.players = self.players
    }
    
    @IBAction func standardBtnPressed(_ sender: Any) {
        standardGameBtn.isSelected = true
        commanderGameBtn.isSelected = false
        gameType = 1
        gameHealth = 20
    }
    
    @IBAction func commanderBtnPressed(_ sender: Any) {
        commanderGameBtn.isSelected = true
        standardGameBtn.isSelected = false
        gameType = 2
        gameHealth = 40
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func joinSessionPressed(_ sender: Any) {
        
        //if input is valid and not whitespace
        if !(lobbyNameTxt.text?.trimmingCharacters(in: .whitespaces).isEmpty)! && gameType != 0{
            //connect to game table and go to gameVC
            let game = lobbyNameTxt.text
            print(GameSystem.system.REF_BASE_GAME.child("\(game!)"))
            //need to get users who are inside the current game table
            let myGroup = DispatchGroup()
            GameSystem.system.REF_BASE_GAME.child(game!).observeSingleEvent(of: .value) { (userSnapshot) in
                for snap in userSnapshot.children.allObjects as! [DataSnapshot] {
                    //gets user id's
                    self.players.append(snap.key)
                    print(snap.key)
                    
    
                    //convert to usernames
                    DataService.instance.getUsernames(forID: snap.key, handler: { (returnedUsername) in
                        myGroup.enter()
                        let username = returnedUsername
                        self.players.append(username)
                        myGroup.leave()
                        //create game as you would in creategamevc
                        //segue to gameVC
                    })
                    
                    myGroup.notify(queue: .main) {
                        print("Finished all requests.")
                         self.performSegue(withIdentifier: "GameVC", sender: self)
                    }
                }
            }
        } else {
            let logoutPopup = UIAlertController(title: "Unable to Join Game", message: "Cannot join game without a lobby name and game mode", preferredStyle: .alert)
            let dismissPopup = UIAlertAction(title: "Ok", style: .default) { (buttonTapped) in
                logoutPopup.dismiss(animated: true, completion: nil)
            }
            logoutPopup.addAction(dismissPopup)
            present(logoutPopup, animated: true, completion: nil)
        }
    }
}
