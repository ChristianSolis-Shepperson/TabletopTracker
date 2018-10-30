//
//  DataService.swift
//  breakpoint
//
//  Created by Christian Solis-Shepperson on 6/3/18.
//  Copyright © 2018 Christian Solis-Shepperson. All rights reserved.
//

import Foundation
import Firebase

let DB_BASE = Database.database().reference()

class DataService{
    
    static let instance = DataService()
    
    //Private variables  to reference database information
    private var _REF_BASE = DB_BASE
    private var _REF_USERS = DB_BASE.child("users")
    private var _REF_FRIENDS = DB_BASE.child("friends")
    
    //Public variables to reference the private database references
    var REF_BASE: DatabaseReference{
        return _REF_BASE
    }
    
    var REF_USERS: DatabaseReference{
        return _REF_USERS
    }
    
    var REF_FRIENDS: DatabaseReference{
        return _REF_FRIENDS
    }
    
    
    func createDBUser(uid: String, userData: Dictionary<String,Any>){
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
    //does not work for email sign in
    func getProviderUID(handler: @escaping (_ username: String) -> ()){
        let activeUserID = Auth.auth().currentUser?.uid
//        let providerData = Auth.auth().currentUser?.providerData
//        //let emailProvider = Firebase.EmailPasswordAuthSignInMethod
//        var providerUID = ""
//        providerData?.forEach({ (profile) in
//            print(profile.uid)
//            providerUID = profile.uid
//        })
//        handler(providerUID)
        handler(activeUserID!)
    }
    
    func getUsername(handler: @escaping (_ username: String) -> ()){
        var username = ""
        
        //Gets the provider UID and retreives username inside closure from the database
        getProviderUID { (pID) in
            self.REF_USERS.child(pID).observeSingleEvent(of: .value, with: { (userSnapshot) in
                print(userSnapshot)
                
                let value = userSnapshot.value as? NSDictionary
                let returnedUsername = value?["userName"] as? String ?? ""
                username = returnedUsername
                print(username)
                handler(username)
            })
        }
        
        //FIXME
        func changeUsername(withNewName username: String){
            REF_USERS.child((Auth.auth().currentUser?.uid)!).child("userName").setValue(username)
        }
        
        
        
        func getEmail(forSearchQuery query: String, handler: @escaping (_ emailArray: [String])->()){
            var emailArray = [String]()
            
            REF_USERS.observe(.value) { (userSnapshot) in
                guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else {return}
                for user in userSnapshot{
                    let email = user.childSnapshot(forPath: "email").value as! String
                    if email.contains(query) == true && email != Auth.auth().currentUser?.email{
                        emailArray.append(email)
                    }
                }
                handler(emailArray)
            }
        }
        
        func getIds(forUsernames usernames: [String], handler: @escaping (_ uidArray: [String])->()){
            REF_USERS.observe(.value) { (userSnapshot) in
                var idArray = [String]()
                guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else {return}
                for user in userSnapshot{
                    let email = user.childSnapshot(forPath: "email").value as! String
                    if usernames.contains(email){
                        idArray.append(user.key)
                    }
                }
                handler(idArray)
            }
        }
        
        //change function to add friends based on username
        func addFriend(withName name: String){
            var databaseReferenceQuery = DataService.instance.REF_USERS.queryOrdered(byChild: "userName").queryEqual(toValue: name).observeSingleEvent(of: .value, with: { (snapshot) in
                if ( snapshot.value != nil ) {
                    // user exists, now add them to friends array in user
                    self.getProviderUID(handler: { (pID) in
                        let data = ["friend": snapshot.value]
                        self.REF_FRIENDS.child(pID).updateChildValues(data as [AnyHashable : Any])
                    })
                }

            }, withCancel: { (error) in
                // An error occurred
                print(error.localizedDescription)
            })
        }
    }
}
