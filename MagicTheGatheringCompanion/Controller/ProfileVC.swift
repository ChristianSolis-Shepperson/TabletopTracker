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
    
    @IBAction func ChangeUsernamePressed(_ sender: Any) {
        messageBox(messageTitle: "Change username", messageAlert: "", messageBoxStyle: .alert, alertActionStyle: .default) {
        }
    }
    
    func messageBox(messageTitle: String, messageAlert: String, messageBoxStyle: UIAlertController.Style, alertActionStyle: UIAlertAction.Style, completionHandler: @escaping () -> Void)
    {
        let alert = UIAlertController(title: messageTitle, message: messageAlert, preferredStyle: messageBoxStyle)
        alert.addTextField { (textfield) in
            textfield.placeholder = "Enter new name"
        }
        
        let okAction = UIAlertAction(title: "Ok", style: alertActionStyle) { _ in
            let newUserName = alert.textFields?.first?.text
            DataService.instance.REF_USERS.child((Auth.auth().currentUser?.uid)!).child("userName").setValue(newUserName)
            
            completionHandler() // This will only get called after okay is tapped in the alert
        }
        
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    //FIXME
    @IBAction func addFriendBtnPressed(_ sender: Any) {
        let friendName = addFriendText.text
        
        var databaseReferenceQuery = DataService.instance.REF_USERS.queryOrdered(byChild: "userName").queryEqual(toValue: friendName).observeSingleEvent(of: .value, with: { (snapshot) in
            if ( snapshot.value != nil ) {
                // user exists, send request
                for child in snapshot.children {
                    let snap = child as! DataSnapshot
                    let dict = snap.value as! [String: Any]
                    let friendUID = dict["uid"] as! String
                    FriendSystem.system.sendRequestToUser(friendUID)
                }
            }
            
            let alertController = UIAlertController(title: "Friend Request", message: "Request Sent", preferredStyle: .alert)
            
            // Create OK button
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                
                // Code in this block will trigger when OK button tapped.
                print("Ok button tapped");
                
            }
            alertController.addAction(OKAction)
            
            // Present Dialog message
            self.present(alertController, animated: true, completion:nil)
            
        }, withCancel: { (error) in
            // An error occurred
            UIAlertController.init(title: "Friend Request", message: "An Error Occurred", preferredStyle: .alert)
            print(error.localizedDescription)
        })
    }
}
