//
//  CreateGameVC.swift
//  MagicTheGatheringCompanion
//
//  Created by Christian Solis-Shepperson on 6/3/18.
//  Copyright © 2018 Christian Solis-Shepperson. All rights reserved.
//

import UIKit
import Firebase

class CreateGameVC: UIViewController{
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var standardGameBtn: UIButton!
    @IBOutlet weak var commanderGameBtn: UIButton!
    
    //Variables
    var usernameArray = [String]()
    var currentUsername = String()
    
    //standard will return 1 and commander will return 2
    var gameType = 0
    var gameHealth = 0
    var commanderDmg = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DataService.instance.getUsername { (returnedUserName) in
            self.currentUsername = returnedUserName
        }
        
        print(usernameArray)
        print(FriendSystem.system.friendList)
        
        FriendSystem.system.addFriendObserver {
            print(FriendSystem.system.friendList)
            self.tableView.reloadData()
        }
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func closeBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! GameVC
        vc.gameType = self.gameType
        vc.health = self.gameHealth
        vc.commandDmg = 0
        vc.players = self.usernameArray
    }
    
    @IBAction func startGamePressed(_ sender: Any) {
        if !usernameArray.isEmpty &&  gameType != 0{
            
            self.usernameArray.append(currentUsername)
            print(usernameArray)
            
            GameSystem.system.createGame(playerNames: self.usernameArray, gameType: gameType, handler: { (gameCreated) in
                if gameCreated{
//                    let gameVC = self.storyboard?.instantiateViewController(withIdentifier: "GameVC")
//                    self.present(gameVC!, animated: true, completion: nil)
                    
//                    //send request to other users
//                    DataService.instance.getIds(forUsernames: self.usernameArray, handler: { (returnedIds) in
//                        for id in returnedIds {
//                            GameSystem.system.sendGameRequestToUser(id)
//                        }
//                    })
                    
                    self.performSegue(withIdentifier: "GameVC", sender: self)
                    
                } else {
                    print("group could not be created. Please try again")
                }
            })
        } else {
            let logoutPopup = UIAlertController(title: "Unable to Create Game", message: "Cannot create game without another player and selected game type", preferredStyle: .alert)
            let dismissPopup = UIAlertAction(title: "Ok", style: .default) { (buttonTapped) in
                logoutPopup.dismiss(animated: true, completion: nil)
            }
            logoutPopup.addAction(dismissPopup)
            present(logoutPopup, animated: true, completion: nil)
        }
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
    
    @IBAction func joinGameBtnPressed(_ sender: Any) {
        let joinGameVC = self.storyboard?.instantiateViewController(withIdentifier: "JoinGameVC")
        self.present(joinGameVC!, animated: true, completion: nil)
    }
    
}
extension CreateGameVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FriendSystem.system.friendList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create cell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as? UserCell else {return UITableViewCell()}
        // Modify cell
        cell.addPlayerLabel.text = "Add to Game"
        //display username instead of email
        cell.emailLabel.text = FriendSystem.system.friendList[indexPath.row].userName
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? UserCell else {return}
        cell.emailLabel.text = FriendSystem.system.friendList[indexPath.row].userName
        
        if !usernameArray.contains(cell.emailLabel.text!) {
            usernameArray.append(cell.emailLabel.text!)
            cell.addPlayerLabel.text = "Added"
            print(usernameArray)
        } else {
            usernameArray = usernameArray.filter({$0 != cell.emailLabel.text})
            cell.addPlayerLabel.text = "Add to Game"
            print(usernameArray)
        }
    }
    
}
