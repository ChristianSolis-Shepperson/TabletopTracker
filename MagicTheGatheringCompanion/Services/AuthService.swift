//
//  AuthService.swift
//  breakpoint
//
//  Created by Christian Solis-Shepperson on 6/3/18.
//  Copyright © 2018 Christian Solis-Shepperson. All rights reserved.
//

import Foundation
import Firebase
import FacebookCore
import FacebookLogin

class AuthService{
    
    static let instance = AuthService()
    
    func registerUser(withEmail email: String, andPassword password: String, userCreationComplete: @escaping (_ status: Bool, _ error: Error?)-> ()){
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            guard let authUser = user else {
                userCreationComplete(false,error)
                return
            }
            
            //let userData = ["provider": authUser.user.providerID, "email": authUser.user.email]
            let userData = ["uid": Auth.auth().currentUser?.uid as Any, "wins": 0, "losses": 0, "winPercent": 0, "userName": "Planeswalker", "decks": [],"provider": authUser.user.providerID, "email": authUser.user.email! ] as [String : Any]
            DataService.instance.createDBUser(uid: authUser.user.uid, userData: userData)
            userCreationComplete(true,nil)
        }
    }
    
    func loginUser(withEmail email: String, andPassword password: String, userLoginComplete: @escaping (_ status: Bool, _ error: Error?)-> ()){
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil{
                userLoginComplete(false, error)
                return
            }
            userLoginComplete(true,nil)
        }
    }
    
    func signInFirebase(){
        guard let authToken = AccessToken.current?.authenticationToken else {return}
        let credential = FacebookAuthProvider.credential(withAccessToken: authToken)
        Auth.auth().signInAndRetrieveData(with: credential) { (user, err) in
            if let err = err{
                print(err)
                return
            }
            print("Successfully logged into Firebase")
        }
    }
}
