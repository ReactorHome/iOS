//
//  AddScheduleTableViewController.swift
//  ReactorHome
//
//  Created by Will Mock on 4/21/18.
//  Copyright © 2018 Mock. All rights reserved.
//

//"deviceType": 0,
//"groupId": 1,
//"deviceId": "",
//"attribute_name": "",
//"attribute_value": "",
//"minute":0,
//"hour": 0,
//"monday": false,
//"tuesday": false,
//"wednesday": false,
//"thursday": false,
//"friday": false,
//"saturday": false,
//"sunday": false

import UIKit

class AddScheduleTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    let mainRequestClient = ReactorMainRequestClient()
    let preferences = UserDefaults.standard
    
    let devicePicker = UIPickerView()
    let statePicker = UIPickerView()
    let timePicker = UIPickerView()
    let repeatPicker = UIPickerView()
    
    var devicePickerSelection: String?
    var statePickerSelection: String?
    var timePickerSelection: String?
    var repeatPickerSelection: String?
    var repeatArraySelection: [String] = []
    
    //Data for the request
    var devicePickerSelectionDeviceType: Int?
    var devicePickerSelectionDeviceID: String?
    var groupId: Int?
    var hourValue: String?
    var minuteValue: String?
    var timeOfDay: String?
    
    let cellTitleNames = ["Device","State","Time","Repeat"]
    
    let binaryArray = ["On", "Off"]
    
    var devicesObject: [ReactorAPIDevice]?
    
    @IBAction func sendScheduleAction(_ sender: Any) {
        
        var attributeName: String?
        var attributeValue: String?
        
        switch devicePickerSelectionDeviceType {
        case 0:
            //attribute name for TP_Link
            attributeName = "on"
            if (statePickerSelection == "On"){
                attributeValue = true.description
            }else{
                attributeValue = false.description
            }
        case 1:
            //attribute name for Hue Lights
            attributeName = "on"
            if (statePickerSelection == "On"){
                attributeValue = true.description
            }else{
                attributeValue = false.description
            }
        case 2:
            break
        default:
            break
        }
        
        //days of the week
        var mondayBool = false
        var tuesdayBool = false
        var wednesdayBool = false
        var thursdayBool = false
        var fridayBool = false
        var saturdayBool = false
        var sundayBool = false
        
        if !repeatArraySelection.isEmpty{
            
            for item in repeatArraySelection{
                
                if item == "M"{
                    mondayBool = true
                }
                
                if item == "T"{
                    tuesdayBool = true
                }
                
                if item == "W"{
                    wednesdayBool = true
                }
                
                if item == "Th"{
                    thursdayBool = true
                }
                
                if item == "F"{
                    fridayBool = true
                }
                
                if item == "S"{
                    saturdayBool = true
                }
                
                if item == "Su"{
                    sundayBool = true
                }
                
            }
        }
        
        if let devicePickerSelectionDeviceType = devicePickerSelectionDeviceType, let groupId = groupId, let devicePickerSelectionDeviceID = devicePickerSelectionDeviceID, let attributeName = attributeName, let attributeValue = attributeValue, let timeOfDay = timeOfDay, let hourValue = hourValue, let minuteValue = minuteValue{
            
            var hourInteger: Int = 0
            let minuteInteger = Int(minuteValue)
            
            switch timeOfDay {
            case "AM":
                hourInteger = Int(hourValue)!
                if hourValue == "12"{
                    hourInteger = 0
                }
            case "PM":
                if hourValue != "12"{
                    hourInteger = Int(hourValue)! + 12
                }
            default:
                break
            }
            
            mainRequestClient.newScheduledEvents(from: .newScheduledEvent, deviceType: devicePickerSelectionDeviceType, groupId: groupId, deviceId: devicePickerSelectionDeviceID, attribute_name: attributeName, attribute_value: attributeValue, hour: hourInteger, minute: minuteInteger!, monday: mondayBool, tuesday: tuesdayBool, wednesday: wednesdayBool, thursday: thursdayBool, friday: fridayBool, saturday: saturdayBool, sunday: sundayBool) { result in
                switch result{
                case .success:
                    self.showSuccessAlert()
                case .failure(let error):
                    print("the error \(error)")
                    self.showErrorAlert()
                }
            }
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        //setting up picker views
        devicePicker.delegate = self
        devicePicker.dataSource = self
        
        statePicker.delegate = self
        devicePicker.tag = 100
        statePicker.dataSource = self
        statePicker.tag = 200
        timePicker.delegate = self
        timePicker.dataSource = self
        timePicker.tag = 300
        repeatPicker.delegate = self
        repeatPicker.dataSource = self
        repeatPicker.tag = 400
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        
        if let hubId = preferences.string(forKey: "hub_id"){
            getHub(hubId: hubId){ hubResult in
                if let devices = hubResult?.devices{
                    self.devicesObject = devices
                    
                    self.devicePickerSelection = devices[0].name
                    self.statePickerSelection = self.binaryArray[0]
                    self.timePickerSelection = "1:00 AM"
                    self.repeatPickerSelection = ""
                    
                    //data for default request
                    self.devicePickerSelectionDeviceID = devices[0].id
                    self.devicePickerSelectionDeviceType = devices[0].type
                    self.groupId = self.preferences.integer(forKey: "group_Id")
                    self.repeatArraySelection = []
                    
                    self.hourValue = "1"
                    self.minuteValue = "00"
                    self.timeOfDay = "AM"
                    
                    
                    self.tableView.reloadData()
                }
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return cellTitleNames.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "scheduledEventCell", for: indexPath) as! addScheduleEventTableViewCell

        cell.textLabel?.text = cellTitleNames[indexPath.row]
        switch indexPath.row {
        case 0:
            cell.inputField.inputView = devicePicker
            cell.inputField.text = devicePickerSelection
        case 1:
            cell.inputField.inputView = statePicker
            cell.inputField.text = statePickerSelection
        case 2:
            cell.inputField.inputView = timePicker
            cell.inputField.text = timePickerSelection
        case 3:
            cell.inputField.inputView = repeatPicker
            cell.inputField.text = repeatPickerSelection
        default:
            cell.inputField.inputView = devicePicker
            cell.inputField.text = devicePickerSelection
        }
        return cell
    }
    
    override func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        switch pickerView.tag {
        case 100:
            return 1
        case 200:
            return 1
        case 300:
            return 3
        case 400:
            return 7
        default:
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 100:
            if let devices = devicesObject{
                return devices.count
            }else{
                return 1
            }
        case 200:
            let deviceIndex = devicePicker.selectedRow(inComponent: 0)
            if let devices = devicesObject{
                switch devices[deviceIndex].type {
                case 0:
                    return 2
                case 1:
                    return 2
                case 2:
                    let tempArray = Array(50...90)
                    return tempArray.count
                default:
                    return 1
                }
            }else{
                return 1
            }
        case 300:
            switch component{
            case 0:
                return 12
            case 1:
                return 12
            case 2:
                return 2
            default:
                return 1
            }
        case 400:
            return 2
        default:
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 100:
            if let devices = devicesObject{
                return devices[row].name
            }else{
                return "Unknown"
            }
        case 200:
            let deviceIndex = devicePicker.selectedRow(inComponent: 0)
            if let devices = devicesObject{
                switch devices[deviceIndex].type {
                case 0:
                    return binaryArray[row]
                case 1:
                    return binaryArray[row]
                case 2:
                    let tempArray = Array(50...90)
                    return tempArray[row].description
                default:
                    return "Unknown"
                }
            }
        case 300:
            switch component{
            case 0:
                let numArray = Array(1...12)
                return numArray[row].description
            case 1:
                let numArray = ["00","05","10","15","20","25","30","35","40","45","50","55"]
                return numArray[row]
            case 2:
                let timeOfDayArray = ["AM", "PM"]
                return timeOfDayArray[row]
            default:
                return "Unknown"
            }
        case 400:
            let mondayArray = ["X", "M"]
            let tuesdayArray = ["X", "T"]
            let wednesdayArray = ["X", "W"]
            let thursdayArray = ["X", "Th"]
            let fridayArray = ["X", "F"]
            let saturdayArray = ["X", "S"]
            let sundayArray = ["X", "Su"]
            switch component{
            case 0:
                return mondayArray[row]
            case 1:
                return tuesdayArray[row]
            case 2:
                return wednesdayArray[row]
            case 3:
                return thursdayArray[row]
            case 4:
                return fridayArray[row]
            case 5:
                return saturdayArray[row]
            case 6:
                return sundayArray[row]
            default:
                return "Unknown"
            }
        default:
            return "Unknown"
        }
        return ""
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let binaryArray = ["On", "Off"]
        switch pickerView.tag {
        case 100:
            if let devices = devicesObject{
                devicePickerSelection = devices[row].name
                devicePickerSelectionDeviceID = devices[row].id
            }else{
                devicePickerSelection = "Unknown"
            }
        case 200:
            let deviceIndex = devicePicker.selectedRow(inComponent: 0)
            if let devices = devicesObject{
                switch devices[deviceIndex].type {
                case 0:
                    statePickerSelection = binaryArray[row]
                case 1:
                    statePickerSelection = binaryArray[row]
                case 2:
                    let tempArray = Array(50...90)
                    statePickerSelection = tempArray[row].description
                default:
                    statePickerSelection = "Unknown"
                }
            }
        case 300:
            let hourArray = Array(1...12)
            let minArray = ["00","05","10","15","20","25","30","35","40","45","50","55"]
            let timeOfDayArray = ["AM", "PM"]
            let hourString = hourArray[pickerView.selectedRow(inComponent: 0)]
            let minString = minArray[pickerView.selectedRow(inComponent: 1)]
            let timeOfDayString = timeOfDayArray[pickerView.selectedRow(inComponent: 2)]
            
            hourValue = hourString.description
            minuteValue = minString
            timeOfDay = timeOfDayString
            
            let finalTime = "\(hourString):\(minString) \(timeOfDayString)"
            
            timePickerSelection = finalTime
        case 400:
            var array = [String]()
            let mondayArray = ["X", "M"]
            let tuesdayArray = ["X", "T"]
            let wednesdayArray = ["X", "W"]
            let thursdayArray = ["X", "Th"]
            let fridayArray = ["X", "F"]
            let saturdayArray = ["X", "S"]
            let sundayArray = ["X", "Su"]
            array.append(mondayArray[pickerView.selectedRow(inComponent: 0)])
            array.append(tuesdayArray[pickerView.selectedRow(inComponent: 1)])
            array.append(wednesdayArray[pickerView.selectedRow(inComponent: 2)])
            array.append(thursdayArray[pickerView.selectedRow(inComponent: 3)])
            array.append(fridayArray[pickerView.selectedRow(inComponent: 4)])
            array.append(saturdayArray[pickerView.selectedRow(inComponent: 5)])
            array.append(sundayArray[pickerView.selectedRow(inComponent: 6)])
            
            repeatArraySelection = array
            
            var finalString = ""
            for item in array{
                if item != "X"{
                    finalString.append(item)
                }
            }
            
            repeatPickerSelection = finalString
            
        default:
            return
        }
        tableView.reloadData()
    }
    
    func showSuccessAlert(){
        let alert = UIAlertController(title: "Successfully scheduled event!", message: "Event will occur at the specified time", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { result in
            self.navigationController?.popViewController(animated: true)
        }))
        
        self.present(alert, animated: true)
    }
    
    func showErrorAlert(){
        let alert = UIAlertController(title: "Something went wrong!", message: "There was an error processing your request. Please try again", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true)
    }
}
