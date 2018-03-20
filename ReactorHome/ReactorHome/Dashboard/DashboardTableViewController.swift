//
//  DashboardTableViewController.swift
//  ReactorHome
//
//  Created by Will Mock on 10/17/17.
//  Copyright © 2017 Mock. All rights reserved.
//

import UIKit

class DashboardTableViewController: UITableViewController, DashboardCellSegueProtocol{

    
    let mainRequestClient = ReactorMainRequestClient()
    let preferences = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if preferences.string(forKey: "group_Id") == nil {
            setGroupNumber()
        }
        print("Group ID: ")
        print(preferences.string(forKey: "group_Id"))
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
    
    //Making request and setting the group number to the first group in the list... maybe allow them to adjust in settings?
    func setGroupNumber() {
        self.mainRequestClient.getGroup(from: .getUsersGroups){ result in
            switch result{
            case .success(let reactorAPIResult):
                guard let getGroupResults = reactorAPIResult else {
                    print("Unable to get Group")
                    return
                }
                
                if let group = getGroupResults.groups?[0]{
                    self.preferences.set(group.id, forKey: "group_Id")
                }
                
            case .failure(let error):
                print("the error \(error)")
            }
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

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
