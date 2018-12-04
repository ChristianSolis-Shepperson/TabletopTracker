//
//  RequestVC.swift
//  MagicTheGatheringCompanion
//
//  Created by Christian Solis-Shepperson on 6/3/18.
//  Copyright © 2018 Christian Solis-Shepperson. All rights reserved.
//
import UIKit

class GameRequestVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var requestArray = [Requests]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(GameSystem.system.requestList)
        
        GameSystem.system.addRequestObserver {
            print(GameSystem.system.requestList)
            self.tableView.reloadData()
        }
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    @IBAction func backBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}

extension GameRequestVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GameSystem.system.requestList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Create cell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as? UserCell else {return UITableViewCell()}
        // Modify cell
        cell.button.setTitle("Accept", for: UIControl.State())
        cell.emailLabel.text = GameSystem.system.requestList[indexPath.row].email
        
        cell.setFunction {
            let id = GameSystem.system.requestList[indexPath.row].id
            GameSystem.system.acceptGameRequest(id!)
            
            //instatiante GameVC
        }
        
        
        // Return cell
        return cell
    }
    
}
