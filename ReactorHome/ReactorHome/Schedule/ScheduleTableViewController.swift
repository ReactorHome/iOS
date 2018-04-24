//
//  ScheduleTableViewController.swift
//  ReactorHome
//
//  Created by Will Mock on 4/18/18.
//  Copyright © 2018 Mock. All rights reserved.
//

import UIKit

class ScheduleTableViewController: UITableViewController {

    let preferences = UserDefaults.standard
    let client = ReactorMainRequestClient()
    
    var eventsResult: [ReactorAPIScheduleEvent]? = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let groupId = preferences.string(forKey: "group_Id"){
            client.getScheduledEvents(from: .getScheduledEventsforGroup(groupId)){ result in
                switch result{
                case .success(let reactorAPIScheduledEvents):
                    guard let getScheduledEventsResults = reactorAPIScheduledEvents else {
                        print("Unable to get Events")
                        return
                    }
                    self.eventsResult = getScheduledEventsResults.events
                    self.tableView.reloadData()
                    
                case .failure(let error):
                    print("the error \(error)")
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let groupId = preferences.string(forKey: "group_Id"){
            client.getScheduledEvents(from: .getScheduledEventsforGroup(groupId)){ result in
                switch result{
                case .success(let reactorAPIScheduledEvents):
                    guard let getScheduledEventsResults = reactorAPIScheduledEvents else {
                        print("Unable to get Events")
                        return
                    }
                    self.eventsResult = getScheduledEventsResults.events
                    self.tableView.reloadData()
                    
                case .failure(let error):
                    print("the error \(error)")
                }
            }
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
        if let events = eventsResult{
            return events.count
        }else{
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "schedulecell", for: indexPath)

        if let events = eventsResult{
            // Configure the cell...
            let name = events[indexPath.row].deviceName
            //let name = events[indexPath.row].deviceId
            let hour = events[indexPath.row].hour
            let min = events[indexPath.row].minute
            var weekString = ""
            
            if events[indexPath.row].monday!{
                weekString.append("M")
            }
            if events[indexPath.row].tuesday!{
                weekString.append("T")
            }
            if events[indexPath.row].wednesday!{
                weekString.append("W")
            }
            if events[indexPath.row].thursday!{
                weekString.append("TH")
            }
            if events[indexPath.row].friday!{
                weekString.append("F")
            }
            if events[indexPath.row].saturday!{
                weekString.append("S")
            }
            if events[indexPath.row].sunday!{
                weekString.append("Su")
            }
            
            if let name = name, let hour = hour, let min = min{
                cell.textLabel?.text = "\(name) @ \(hour):\(min) \(weekString)"
            }
        }else{
            // Configure the cell...
            cell.textLabel?.text = "Title @ 00:00 MWF"
        }
        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            if let events = eventsResult, let idString = events[indexPath.row].id?.description{
                eventsResult!.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                client.deleteScheduledEvents(from: .deleteScheduledEvent(idString)) { result in
                    switch result{
                    case .success:
                        print("successfully deleted row")
                    case .failure(let error):
                        print("the error \(error)")
                    }
                }
            }
            //will send delete request here
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
}
