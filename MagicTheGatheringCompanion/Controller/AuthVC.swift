//
//  AuthVC.swift
//  breakpoint
//
//  Created by Christian Solis-Shepperson on 6/3/18.
//  Copyright © 2018 Christian Solis-Shepperson. All rights reserved.
//

import UIKit
import Firebase
import FacebookCore
import FacebookLogin
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn

class AuthVC: UIViewController, GIDSignInUIDelegate{
    
    
    @IBOutlet weak var FBLoginButton: UIButton!
    @IBOutlet weak var GoogleSignInButton: GIDSignInButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil{
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func signInWithEmailBtnPressed(_ sender: Any) {
        let loginVC = storyboard?.instantiateViewController(withIdentifier: "LoginVC")
        present(loginVC!, animated: true, completion: nil)
    }
    
    @IBAction func googleSignInBtnPressed(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func facebookSignInBtnPressed(_ sender: Any) {
        if(Auth.auth().currentUser == nil) {
            let loginManager = LoginManager()
            loginManager.logIn(readPermissions: [.publicProfile,.email], viewController: self) { (result) in
                switch result{
                case .success(grantedPermissions: _, declinedPermissions: _, token: _): AuthService.instance.signInFirebase()
                print("Successfully logged into Facebook")
                self.dismiss(animated: true, completion: nil)
                let userData = ["uid": Auth.auth().currentUser?.uid as Any ,"wins": 0, "losses": 0, "winPercent": 0, "userName": "Planeswalker", "decks": [],"provider": "Facebook", "email": Auth.auth().currentUser?.email! as Any ] as [String : Any]
                DataService.instance.createDBUser(uid: FBSDKAccessToken.current().userID, userData: userData)
                case .failed(let err): print(err)
                case .cancelled: print("Option Canceled")
                }
            }
        }
    }
    
    
    
    
    
    
}
