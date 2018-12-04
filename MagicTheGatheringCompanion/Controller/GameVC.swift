//
//  AuthVC.swift
//  MagicTheGatheringCompanion
//
//  Created by Christian Solis-Shepperson on 6/3/18.
//  Copyright © 2018 Christian Solis-Shepperson. All rights reserved.
//

import UIKit
import Firebase

class GameVC: UIViewController{
    
    @IBOutlet weak var turnIndicator: UISwitch!
    @IBOutlet weak var manaBtn: UIButton!
    @IBOutlet var manaView: UIView!
    @IBOutlet weak var healthLbl: UILabel!
    @IBOutlet weak var commanderDmgLbl: UILabel!
    @IBOutlet weak var plusCommanderDmg: UIButton!
    @IBOutlet weak var minusCommanderDmg: UIButton!
    @IBOutlet weak var minusHealthBtn: UIButton!
    @IBOutlet weak var plusHealthBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var commanderStackView: UIStackView!
    @IBOutlet weak var floatManaLbl: UILabel!
    @IBOutlet weak var infectLbl: UILabel!
    
    
    //variable for gameType
    var gameType = Int()
    var health = Int()
    var commandDmg = Int()
    var gameSession = ""
    
    var players = [String]()
    var playerUIDS = [String]()
    var activeTurn = 0
    var activePlayer = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if gameType == 1 {
            self.commanderStackView.isHidden = true
        }
        healthLbl.text = "\(health)"
        commanderDmgLbl.text = "\(commandDmg)"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print("Hey its me \(GameSystem.system.REF_BASE_GAME.child("demo").child((Auth.auth().currentUser?.uid)!))")
        
        GameSystem.system.REF_BASE_GAME.child("demo").child((Auth.auth().currentUser?.uid)!).observe(.value) { (userSnapshot) in
            print(userSnapshot)
            let returnedHealth = userSnapshot.childSnapshot(forPath: "health").value as! Int
            let returnedTurn = userSnapshot.childSnapshot(forPath: "playerTurn").value as! Bool
            let returnDmg = userSnapshot.childSnapshot(forPath: "commanderDamage").value as! Int
            let returnMana = userSnapshot.childSnapshot(forPath: "floatMana").value as! Int
            let returnInfect = userSnapshot.childSnapshot(forPath: "infectDamage").value as! Int
            let health = returnedHealth
            let commandDmg = returnDmg
            print(returnedHealth)
            self.healthLbl.text = "\(health)"
            self.commanderDmgLbl.text = "\(commandDmg)"
            self.floatManaLbl.text = "\(returnMana)"
            self.infectLbl.text = "\(returnInfect)"
            self.turnIndicator.setOn(returnedTurn, animated:true)
        }
    }
    
    func loadPlayers(_ handler: @escaping()->()){
        GameSystem.system.REF_BASE_GAME.child("demo").child((Auth.auth().currentUser?.uid)!).observe(.value) { (userSnapshots) in
            for user in userSnapshots.children.allObjects as! [DataSnapshot]{
                let id = user.key
                self.playerUIDS.append(id)
                
                DataService.instance.getUsernames(forID: id, handler: { (returnedUsername) in
                    let username = returnedUsername
                    self.players.append(username)
                })
            }
        }
        print(players)
        handler()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch? = touches.first
        
        if touch?.view != manaView {
            self.manaView.removeFromSuperview()
        }
    }
    
    @IBAction func turnIndicatorPressed(_ sender: Any) {
        
//        loadPlayers {
//            var changeIDArray = [String]()
//            //set active player
//            self.activePlayer = self.players[self.activeTurn]
//            //make activePlayer previous
//            let previousPlayerActive = self.activePlayer
//            
//            //increment turn
//            if self.activeTurn >= self.players.count - 1 {
//                self.activeTurn = self.activeTurn % self.players.count-1
//            } else {
//                self.activeTurn+=1
//            }
//            
//            //set new activePlayer
//            self.activePlayer = self.players[self.activeTurn]
//            print(self.activePlayer)
//            print(previousPlayerActive)
//            
//            changeIDArray.append(previousPlayerActive)
//            changeIDArray.append(self.activePlayer)
//            print(changeIDArray)
//            
//            //do stuff
//            let group = DispatchGroup()
//            group.enter()
//            GameSystem.system.incrementTurn(forUsername: changeIDArray, {
//                group.leave()
//            })
//        }
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        let logoutPopup = UIAlertController(title: "Are you sure?", message: "Game data will be erased, continue?", preferredStyle: .alert)
        let dismissPopup = UIAlertAction(title: "OK", style: .default) { (buttonTapped) in
            logoutPopup.dismiss(animated: true, completion: nil)
            self.dismiss(animated: true, completion: nil)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .default) { (buttonTapped) in
            logoutPopup.dismiss(animated: true, completion: nil)
        }
        logoutPopup.addAction(dismissPopup)
        logoutPopup.addAction(cancel)
        present(logoutPopup, animated: true, completion: nil)
    }
    
    //FIXME
    @IBAction func manaBtnPressed(_ sender: Any) {
        self.view.addSubview(manaView)
        manaView.center = self.view.center
    }
    
    @IBAction func plusHealthBtnPressed(_ sender: Any) {
        GameSystem.system.incrementHealth { (returnedHealth) in
            let health = returnedHealth
            self.healthLbl.text = "\(health)"
        }
    }
    
    @IBAction func minusHealthBtnPressed(_ sender: Any) {
        GameSystem.system.decrementHealth { (returnedHealth) in
            let health = returnedHealth
            self.healthLbl.text = "\(health)"
        }
    }
    @IBAction func plusCommanderDmgPressed(_ sender: Any) {
        GameSystem.system.incrementCommandDmg { (returnedDmg) in
            let dmg = returnedDmg
            self.commanderDmgLbl.text = "\(dmg)"
        }
    }
    @IBAction func minusCommanderDmgPressed(_ sender: Any) {
        GameSystem.system.decrementCommandDmg { (returnedDmg) in
            let dmg = returnedDmg
            self.commanderDmgLbl.text = "\(dmg)"
        }
    }
    
    @IBAction func minusManaPressed(_ sender: Any) {
        GameSystem.system.decrementMana { (returnMana) in
            let mana = returnMana
            self.floatManaLbl.text = mana
        }
    }
    
    @IBAction func plusManaPressed(_ sender: Any) {
        GameSystem.system.incrementMana { (returnMana) in
            let mana = returnMana
            self.floatManaLbl.text = mana
        }
        
    }
    
    @IBAction func minusInfectPressed(_ sender: Any) {
        GameSystem.system.decrementInfect(handler: { (returnInfect) in
            let infect = returnInfect
            self.infectLbl.text = infect
        })
    }
    
    @IBAction func plusInfectPressed(_ sender: Any) {
        GameSystem.system.incrementInfect(handler: { (returnInfect) in
            let infect = returnInfect
            self.infectLbl.text = infect
        })
    }
}
