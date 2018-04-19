//
//  SettingsViewController.swift
//  ReactorHome
//
//  Created by Will Mock on 4/9/18.
//  Copyright © 2018 Mock. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,  UIPickerViewDelegate, UIPickerViewDataSource{

    let mainRequestClient = ReactorMainRequestClient()
    let preferences = UserDefaults.standard

    let thePicker = UIPickerView()
    
    var resultGroups: [ReactorAPIGroupObject]?
    var groupObject: ReactorAPIGroupObject?
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var topLabel: UILabel!
    @IBOutlet var leftLabel: UILabel!
    @IBOutlet var rightLabel: UILabel!
    
    let cellTitleArray = ["Hub Info", "Default Hub", "Manage Users"]
    //change for picker
    var pickerSelection: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        thePicker.delegate = self
        thePicker.dataSource = self
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        
        refreshData()
    }
    
    func refreshData() {
        let prefGroup = preferences.integer(forKey: "set_group_Id")
        print(prefGroup)
        getGroups { result in
            if let groups = result?.groups{
                self.resultGroups = groups
                self.groupObject = groups[prefGroup]
            }
            
            self.topLabel.text = self.groupObject?.name
            self.rightLabel.text = ((self.groupObject?.accountList?.count)!+1).description
            self.leftLabel.text = self.groupObject?.owner?.firstName
            self.tableView.reloadData()
        }
    }
    
    override func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellTitleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath)
            cell.textLabel?.text = cellTitleArray[indexPath.row]
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "settingsPickerCell", for: indexPath) as! SettingsPickerTableViewCell
            cell.textLabel?.text = cellTitleArray[indexPath.row]
            cell.textField.inputView = thePicker
            cell.textField.text = pickerSelection ?? groupObject?.name
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath)
            cell.textLabel?.text = cellTitleArray[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            performSegue(withIdentifier: "settingsBasicDetailSegue", sender: self)
        case 1:
            print("changeing hub")
        case 2:
            performSegue(withIdentifier: "settingsUserControlSegue", sender: self)
        default:
            print("No Segue Specified")
        }
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if let groups = resultGroups {
            return groups.count
        }else{
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let groups = resultGroups else {
            return ""
        }
        return groups[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let groups = resultGroups else {
            print("could not unwrap resultGroups")
            return
        }
        pickerSelection = groups[row].name
        preferences.set(row, forKey: "set_group_Id")
        refreshData()
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
        
        if segue.identifier == "settingsUserControlSegue", let destinationVC = segue.destination as? SettingsUserStatusViewController {
            destinationVC.title = "Add User"
        }
        
    }

}
