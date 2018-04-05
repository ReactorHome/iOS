//
//  DashboardTableViewCell.swift
//  ReactorHome
//
//  Created by Will Mock on 2/20/18.
//  Copyright © 2018 Mock. All rights reserved.
//

import UIKit

class DashboardTableViewCell: UITableViewCell, UITableViewDataSource, UITableViewDelegate {
    
    var delegate: DashboardCellSegueProtocol!
    
    var cellType: DashboardCellType?
    
    var deviceGroupData: ReactorAPIDeviceGroupsResult?
    var deviceData: ReactorAPIHubResult?
    var alertsData: ReactorAPIAlerts?
    
    @IBOutlet var innerTableView: UITableView!
    @IBOutlet var sectionTitleText: UILabel!
    @IBOutlet var buttonOutlet: UIButton!
    
    @IBAction func buttonAction(_ sender: Any) {
        //all of these prints are only for testing that I successfully passed the data. can be removed.
//        print("button action works!")
//        print("deviceData: ")
//        print(deviceData)
//        print("deviceGroupData: ")
//        print(deviceGroupData)
//        print("alertsData: ")
//        print(alertsData)
        
        if(self.delegate != nil){ //Just to be safe.
            self.delegate.callSegueFromCell(cellType: cellType!)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        innerTableView.delegate = self
        innerTableView.dataSource = self
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let devices = deviceData?.devices!{
            //print("selected \(devices[indexPath.row].name!)")
            self.innerTableView.deselectRow(at: indexPath, animated: true)
            self.delegate.callOutletDeviceSequeFromCell(currDevice: devices[indexPath.row])
        }
        self.innerTableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let cellType = cellType {
            switch cellType {
            case .alertsCell:
                return 3
            case .devicesCell:
                if let deviceData = deviceData, let actualDeviceData = deviceData.devices{
                        return actualDeviceData.count
                }else{
                    return 3
                }
            case .groupsCell:
                return 3
            default:
               return 3
            }
        }else{
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cellType = cellType {
            
            switch cellType {
            case .alertsCell:
                let cell = tableView.dequeueReusableCell(withIdentifier: "alertbasiccell") as! AlertBasicTableViewCell
                
                cell.titleLabel.text = "Alert!"
                
                
                
                return cell
            case .devicesCell:
                if let devices = deviceData?.devices!{
                    switch devices[indexPath.row].type! {
                    case 1://this means outlet
                        let cell = tableView.dequeueReusableCell(withIdentifier: "devicebasiccell") as! DeviceBasicTableViewCell
                        
                        cell.titleLabel.text = devices[indexPath.row].name
                        cell.hardware_id = devices[indexPath.row].hardware_id
                        cell.stateSwicth.setOn(devices[indexPath.row].on!, animated: true)
                        
                        //logic for if the device becomes disconnected
                        if(!devices[indexPath.row].connected!){
                            cell.stateSwicth.setOn(false, animated: true)
                            cell.stateSwicth.isEnabled = false
                            self.delegate.showDisabledAlert(deviceName: devices[indexPath.row].name!)
                        }else{
                            cell.stateSwicth.isEnabled = true
                        }
                        
                        return cell
                    //ADD MORE DEVICE TYPES HERE
                    default:
                        let cell = tableView.dequeueReusableCell(withIdentifier: "devicebasiccell") as! DeviceBasicTableViewCell
                        cell.titleLabel.text = "UNSUPPORTED DEVICE"
                        return cell
                    }
                    
                }else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "devicebasiccell") as! DeviceBasicTableViewCell
                    cell.titleLabel.text = "Device"
                    return cell
                }
                
            case .groupsCell:
                let cell = tableView.dequeueReusableCell(withIdentifier: "groupbasiccell") as! GroupBasicTableViewCell
                
                cell.titleLabel.text = "Group"
                
                return cell
            default:
                //this case should never occur
                let cell = tableView.dequeueReusableCell(withIdentifier: "alertbasiccell") as! AlertBasicTableViewCell
                return cell
            }
        }else{
            let errorCell = UITableViewCell()
            print("Error in DashboardTableViewCell returning errorCell = empty UITableViewCell")
            return errorCell
        }
    }

}
