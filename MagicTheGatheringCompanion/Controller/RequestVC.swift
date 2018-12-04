//
//  RequestVC.swift
//  MagicTheGatheringCompanion
//
//  Created by Christian Solis-Shepperson on 6/3/18.
//  Copyright © 2018 Christian Solis-Shepperson. All rights reserved.
//
import UIKit

class RequestVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var requestArray = [Requests]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FriendSystem.system.requestList)

        FriendSystem.system.addRequestObserver {
            print(FriendSystem.system.requestList)
            self.tableView.reloadData()
        }
        tableView.delegate = self
        tableView.dataSource = self
    }

    
    @IBAction func backBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}

extension RequestVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FriendSystem.system.requestList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Create cell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as? UserCell else {return UITableViewCell()}
        // Modify cell
        cell.button.setTitle("Accept", for: UIControl.State())
        cell.emailLabel.text = FriendSystem.system.requestList[indexPath.row].email

        cell.setFunction {
            let id = FriendSystem.system.requestList[indexPath.row].id
            FriendSystem.system.acceptFriendRequest(id!)
        }
        
        
        // Return cell
        return cell
    }
    
}
