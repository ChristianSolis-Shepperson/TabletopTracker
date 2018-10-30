//
//  ProfileVC.swift
//  MagicTheGatheringCompanion
//
//  Created by Christian Solis-Shepperson on 10/7/18.
//  Copyright © 2018 Christian Solis-Shepperson. All rights reserved.
//

import UIKit
import Firebase

class ProfileVC: UIViewController {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var signOutBtn: UIButton!
    @IBOutlet weak var addFriendText: UITextField!
    @IBOutlet weak var addFriendBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //does not work with email sign in
        if Auth.auth().currentUser != nil{
            DataService.instance.getUsername { (returnedUsername) in
                self.usernameLabel.text = "Welcome \(returnedUsername)!"
            }
        } else {
            self.usernameLabel.text = "Welcome"
        }
    }
    
    @IBAction func signOutBtnPressed(_ sender: Any) {
        let logoutPopup = UIAlertController(title: "Logout?", message: "Are you sure you want to log out?", preferredStyle: .actionSheet)
        let logoutAction = UIAlertAction(title: "Logout?", style: .destructive) { (buttonTapped) in
            
            do{
                try Auth.auth().signOut()
                let authVC = self.storyboard?.instantiateViewController(withIdentifier: "AuthVC") as? AuthVC
                self.present(authVC!, animated: true, completion: nil)
            } catch{
                print(error)
            }
        }
        logoutPopup.addAction(logoutAction)
        present(logoutPopup, animated: true, completion: nil)
        
    }
    
    //FIXME
    @IBAction func addFriendBtnPressed(_ sender: Any) {
        let friendName = addFriendText.text
        
    }

    
}
