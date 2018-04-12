//
//  AllAlertsTableViewController.swift
//  ReactorHome
//
//  Created by Will Mock on 4/12/18.
//  Copyright © 2018 Mock. All rights reserved.
//

import UIKit

class AllAlertsTableViewController: UITableViewController {

    var data: ReactorAPIAlerts?
    
    var revAlerts: [ReactorAPIAlert]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let data = data, let alerts = data.alerts{
            revAlerts = alerts.reversed()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if let data = data, let alerts = data.alerts{
            return alerts.count
        }else{
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "allAlertsResue", for: indexPath)
        
        if let revAlerts = revAlerts{
            cell.textLabel?.text = revAlerts[indexPath.row].data
        }else{
            cell.textLabel?.text = "Unknown"
        }
        return cell
    }
}
