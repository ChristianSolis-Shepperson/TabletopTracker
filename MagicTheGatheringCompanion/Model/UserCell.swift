//
//  UserCell.swift
//  MagicTheGatheringCompanion
//
//  Created by Christian Solis-Shepperson on 11/22/18.
//  Copyright © 2018 Christian Solis-Shepperson. All rights reserved.
//

import Foundation
import UIKit

class UserCell: UITableViewCell {
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var addPlayerLabel: UILabel!
    
    var buttonFunc: (() -> (Void))!

    @IBAction func buttonTapped(_ sender: UIButton) {
        buttonFunc()
    }
    
    func setFunction(_ function: @escaping () -> Void) {
        self.buttonFunc = function
    }
    
}
