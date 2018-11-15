//
//  AuthVC.swift
//  breakpoint
//
//  Created by Christian Solis-Shepperson on 6/3/18.
//  Copyright © 2018 Christian Solis-Shepperson. All rights reserved.
//

import UIKit
import Firebase

class GameVC: UIViewController{
    
    @IBOutlet weak var turnIndicator: UISwitch!
    @IBOutlet weak var playerHealthBtn: UIButton!
    @IBOutlet weak var manaBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}
