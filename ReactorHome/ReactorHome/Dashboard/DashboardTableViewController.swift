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
    var hubObject: ReactorAPIHubResult?
    var alertsObject: ReactorAPIAlerts?
    var devicesObject: ReactorAPIHubResult?
    var deviceGroupsObject: ReactorAPIDeviceGroupsResult?
    
    let mainRequestClient = ReactorMainRequestClient()
    let preferences = UserDefaults.standard
    
    var device: ReactorAPIDevice?
    
    //function for refreshing
    @objc func refreshTable() {
        getAllData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl?.tintColor = UIColor.gray
        refreshControl?.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
        
        if groupObject == nil{
            getGroups(){ result in
                self.groupObject = result
                
                if (self.groupObject != nil){
                    self.preferences.set(self.groupObject?.groups![0].hubId, forKey: "hub_id")
                    self.preferences.set(self.groupObject?.groups![0].name, forKey: "hub_name")
                }
                
                self.getAllData()
            }
        }
    }
    
    func getAllData() {
        let dispatchGroup = DispatchGroup()
        let groupNum = preferences.integer(forKey: "set_group_Id")
        
        if let groupObject = self.groupObject{
            dispatchGroup.enter()
            self.getHub(hubId: (groupObject.groups![groupNum].hubId)!){ hubResult in
                self.devicesObject = hubResult
                dispatchGroup.leave()
            }
            
            dispatchGroup.enter()
            self.getAlerts(groupId: (groupObject.groups![groupNum].id)!){ alertsResult in
                self.alertsObject = alertsResult
                //print(alertsResult)
                dispatchGroup.leave()
            }
            
            self.deviceGroupsObject = self.getDeviceGroups()
            
            dispatchGroup.notify(queue: .main) {
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
            }
        }else{
            print("Unsuccessful refresh no group object exists")
            self.refreshControl?.endRefreshing()
        }
        
        
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
        
        //sending the data with each cell based on ell type
        switch indexPath.row {
        case 0:
            cell.cellType = .alertsCell
            cell.alertsData = alertsObject
            cell.innerTableView.reloadData()
        case 1:
            cell.cellType = .devicesCell
            cell.deviceData = devicesObject
            cell.innerTableView.isScrollEnabled = true
            cell.innerTableView.reloadData()
        case 2:
            cell.cellType = .groupsCell
            cell.deviceGroupData = deviceGroupsObject
            cell.innerTableView.reloadData()
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

    func getGroups(completion: @escaping (ReactorAPIGroupResult?) -> Void) -> Void{
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
                completion(getGroupResults)
            case .failure(let error):
                print("the error \(error)")
            }
        }
    }
    
    func getAlerts(groupId: Int, completion: @escaping (ReactorAPIAlerts?) -> Void) -> Void{
        mainRequestClient.getAlerts(from: .getAlertsForGroup(groupId.description)){ result in
            switch result{
            case .success(let reactorAPIAlerts):
                guard let getAlertsResults = reactorAPIAlerts else {
                    print("Unable to get Alerts")
                    return
                }
                completion(getAlertsResults)
            case .failure(let error):
                print("the error \(error)")
            }
        }
    }
    
    func getHub(hubId: String, completion: @escaping (ReactorAPIHubResult?) -> Void) -> Void{
        mainRequestClient.getHub(from: .getHubInfo(hubId)) { result in
            switch result{
            case .success(let reactorAPIResult):
                guard let getHubResults = reactorAPIResult else {
                    print("Unable to get Group")
                    return
                }
                completion(getHubResults)
            case .failure(let error):
                print("the error \(error)")
            }
        }
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
    
    func callOutletDeviceSequeFromCell(currDevice: ReactorAPIDevice){
        device = currDevice
        self.performSegue(withIdentifier: "outletDeviceDetailSegue", sender: self)
    }
    
    func callAlertDetailSegueFromCell(){
        self.performSegue(withIdentifier: "alertDetailSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "outletDeviceDetailSegue", let destinationVC = segue.destination as?  OutletDeviceDetailViewController{
            destinationVC.device = self.device
        }
        if segue.identifier == "showAllAlerts", let destinationVC = segue.destination as? AllAlertsTableViewController {
            destinationVC.data = alertsObject
        }
    }

}
