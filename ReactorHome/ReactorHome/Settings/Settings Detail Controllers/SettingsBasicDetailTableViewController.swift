//
//  SettingsBasicDetailTableViewController.swift
//  ReactorHome
//
//  Created by Will Mock on 4/10/18.
//  Copyright © 2018 Mock. All rights reserved.
//

import UIKit

class SettingsBasicDetailTableViewController: UITableViewController {

    var groupObject: ReactorAPIGroupObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsBasicDetailCell", for: indexPath)

        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Hub Name"
            cell.detailTextLabel?.text = groupObject?.name
        case 1:
            if let fName = groupObject?.owner?.firstName?.description, let lName = groupObject?.owner?.lastName?.description{
                cell.textLabel?.text = "Owner"
                cell.detailTextLabel?.text = "\(fName) \(lName)"
            }
        case 2:
            cell.textLabel?.text = "Hub ID"
            cell.detailTextLabel?.text = groupObject?.hubId
        default:
            print("NO CASE FOR CELL!")
        }
        return cell
    }
    
}
