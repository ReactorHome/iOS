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
    
    let mainRequestClient = ReactorMainRequestClient()
    let preferences = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if groupObject == nil{
            print("getting groups")
            groupObject = getGroups()
        }
        print("viewDidLoad")
        print(groupObject)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if groupObject == nil{
            showErrorAlert()
        }
        print("viewWillAppear")
        print(groupObject)
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
                
            case .failure(let error):
                print("the error \(error)")
            }
        }
        return returnValue
    }
    
    func showErrorAlert(){
        let alert = UIAlertController(title: "Something went wrong!", message: "There was an error loading your data. Please try relaunching the app", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true)
    }

}
