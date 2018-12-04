//
//  LoginVC.swift
//  MagicTheGatheringCompanion
//
//  Created by Christian Solis-Shepperson on 6/3/18.
//  Copyright © 2018 Christian Solis-Shepperson. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    //Outlets
    @IBOutlet weak var emailField: InsetTextField!
    @IBOutlet weak var passwordField: InsetTextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailField.delegate = self
        passwordField.delegate = self
    }
    
    @IBAction func signInBtnPressed(_ sender: Any) {
        //Attempts to log in a user
        if emailField.text != nil && passwordField.text != nil{
            AuthService.instance.loginUser(withEmail: emailField.text!, andPassword: passwordField.text!) { (success, error) in
                if success{
                    self.dismiss(animated: true, completion: nil)
                } else {
                    print(String(describing: error?.localizedDescription))
                }

                //Registers user is login was unsuccessful
                AuthService.instance.registerUser(withEmail: self.emailField.text!, andPassword: self.passwordField.text!, userCreationComplete: { (success, error) in
                    if success{
                        AuthService.instance.loginUser(withEmail: self.emailField.text!, andPassword: self.passwordField.text!, userLoginComplete: { (success, nil) in
                            self.dismiss(animated: true, completion: nil)
                            print("Successfully registered user")
                        })
                    } else {
                        print(String(describing: error?.localizedDescription))
                    }
                })
            }
        }
    }
    
    @IBAction func closeBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension LoginVC: UITextFieldDelegate{
    
}
