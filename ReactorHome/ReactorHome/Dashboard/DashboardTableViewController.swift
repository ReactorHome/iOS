//
//  DashboardTableViewController.swift
//  ReactorHome
//
//  Created by Will Mock on 10/17/17.
//  Copyright © 2017 Mock. All rights reserved.
//

import UIKit

class DashboardTableViewController: UITableViewController, DashboardCellSegueProtocol{

    //getting group object from previous Segue
    var groupObject: ReactorAPIGroupResult?
    //setting up for other requests
    var eventsObject: ReactorAPIEventsResult?
    var devicesObject: ReactorAPIDevicesResult?
    var deviceGroupsObject: ReactorAPIDeviceGroupsResult?
    
    let mainRequestClient = ReactorMainRequestClient()
    let preferences = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if groupObject == nil{
            groupObject = getGroups()
        }
        eventsObject = getEvents()
        devicesObject = getDevices()
        deviceGroupsObject = getDeviceGroups()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dashboardcell") as!  DashboardTableViewCell
        
        //setting the headers and button names
        let sectionHeaders = ["Alerts","Devices","Groups"]
        cell.sectionTitleText.text = sectionHeaders[indexPath.row]
        let buttonNames = ["All Alerts", "Manage Devices", "Manage Groups"]
        cell.buttonOutlet.setTitle(buttonNames[indexPath.row], for: .normal)
        
        //setting the delegate
        cell.delegate = self
        
        switch indexPath.row {
        case 0:
            cell.cellType = .alertsCell
        case 1:
            cell.cellType = .devicesCell
        case 2:
            cell.cellType = .groupsCell
        default:
            cell.cellType = .errorCell
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView.tag == 1 {
            return 300.0
        }else{
            return 50.0
        }
    }
    
    func callSegueFromCell(cellType: DashboardCellType){
        
        switch cellType{
        case .alertsCell:
            self.performSegue(withIdentifier: "showAllAlerts", sender: self)
        case .devicesCell:
            self.performSegue(withIdentifier: "showManageDevices", sender: self)
        case .groupsCell:
            self.performSegue(withIdentifier: "showManageGroups", sender: self)
        default:
            print("error in DashboardTableViewController")
        }
    }

    func getGroups() -> ReactorAPIGroupResult?{
        var returnValue: ReactorAPIGroupResult? = nil
        mainRequestClient.getGroup(from: .getUsersGroups){ result in
            switch result{
            case .success(let reactorAPIResult):
                guard let getGroupResults = reactorAPIResult else {
                    print("Unable to get Group")
                    return
                }
                
                if let group = getGroupResults.groups?[0]{
                    self.preferences.set(group.id, forKey: "group_Id")
                }
                
                returnValue = getGroupResults
                self.tableView.reloadData()
            case .failure(let error):
                print("the error \(error)")
            }
        }
        return returnValue
    }
    //will need to return ReactorAPIEventsResult?
    func getEvents() -> ReactorAPIEventsResult?{
        print("getting events")
        return nil
    }
    //will need to return ReactorAPIDevicesResult?
    func getDevices() -> ReactorAPIDevicesResult?{
        print("getting devices")
        return nil
    }
    //will need to return ReactorAPIDeviceGroupsResult?
    func getDeviceGroups() ->ReactorAPIDeviceGroupsResult?{
        print("getting  device groups")
        return nil
    }
    
    func showErrorAlert(){
        let alert = UIAlertController(title: "Something went wrong!", message: "There was an error loading your data. Please try relaunching the app", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true)
    }

}
