//
//  SettingsViewController.swift
//  ReactorHome
//
//  Created by Will Mock on 4/9/18.
//  Copyright © 2018 Mock. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
    let mainRequestClient = ReactorMainRequestClient()
    let preferences = UserDefaults.standard
    
    var groupObject: ReactorAPIGroupObject?
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var topLabel: UILabel!
    @IBOutlet var leftLabel: UILabel!
    @IBOutlet var rightLabel: UILabel!
    
    let cellTitleArray = ["Hub Info", "Change Default Hub", "Manage Users"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let prefGroup = preferences.integer(forKey: "set_group_Id")
        
        getGroups { result in
            if let groups = result?.groups{
                self.groupObject = groups[prefGroup]
            }
            
            self.topLabel.text = self.groupObject?.name
            self.rightLabel.text = ((self.groupObject?.accountList?.count)!+1).description
            self.leftLabel.text = self.groupObject?.owner?.firstName
            
            //print(self.groupObject)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellTitleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath)
        cell.textLabel?.text = cellTitleArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            performSegue(withIdentifier: "settingsBasicDetailSegue", sender: self)
        default:
            print("No Segue Specified")
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
                completion(getGroupResults)
            case .failure(let error):
                print("the error \(error)")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "settingsBasicDetailSegue", let destinationVC = segue.destination as? SettingsBasicDetailTableViewController {
            destinationVC.groupObject = groupObject
            destinationVC.title = "Hub Info"
        }
    }

}
