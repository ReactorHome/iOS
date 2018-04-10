//
//  EventsTableViewController.swift
//  ReactorHome
//
//  Created by Will Mock on 1/26/18.
//  Copyright © 2018 Mock. All rights reserved.
//

import UIKit

class EventsTableViewController: UITableViewController {

    //header data
    var headerArray: [String] = []
    var bucketArray: [[ReactorAPIEvent]] = []
    
    let mainRequestClient = ReactorMainRequestClient()
    let preferences = UserDefaults.standard
    
    var eventsResult: ReactorAPIEventsResult?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let groupId = preferences.string(forKey: "group_Id"){
            mainRequestClient.getEvents(from: .getEventsForGroup(groupId)) { result in
                switch result{
                case .success(let reactorAPIEvents):
                    guard let getEventsResults = reactorAPIEvents else {
                        print("Unable to get Events")
                        return
                    }
                    self.eventsResult = getEventsResults
                    
                    //setting header array
                    for item in getEventsResults.events!{
                        if !self.headerArray.contains(item.occurredAtDate!){
                            self.headerArray.append(item.occurredAtDate!)
                        }
                    }
                    
                    self.bucketArray = Array(repeating: [], count: self.headerArray.count)
                    
                    for event in getEventsResults.events!{
                        let indexOfEvent = self.headerArray.index(of: event.occurredAtDate!)
                        self.bucketArray[indexOfEvent!].append(event)
                    }
                    
                    self.tableView.reloadData()
                    
                case .failure(let error):
                    print("the error \(error)")
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return headerArray.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if let eventsResult = eventsResult{
            var array:[ReactorAPIEvent] = []
            for item in eventsResult.events!{
                if item.occurredAtDate == headerArray[section]{
                    array.append(item)
                }
            }
            return array.count
        }else{
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (!headerArray.isEmpty) {
            return headerArray[section];
        }else{
            return "Unknown"
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventsCell", for: indexPath)

        if indexPath.section < headerArray.count && indexPath.row < bucketArray[indexPath.section].count {
            cell.textLabel?.text = bucketArray[indexPath.section][indexPath.row].device
            cell.detailTextLabel?.text = bucketArray[indexPath.section][indexPath.row].occurredAtDateLong
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
