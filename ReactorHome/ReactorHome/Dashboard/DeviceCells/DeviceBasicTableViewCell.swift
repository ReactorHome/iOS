//
//  DeviceBasicTableViewCell.swift
//  ReactorHome
//
//  Created by Will Mock on 2/23/18.
//  Copyright © 2018 Mock. All rights reserved.
//

import UIKit

class DeviceBasicTableViewCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var stateSwicth: UISwitch!
   
    let mainRequestClient = ReactorMainRequestClient()
    let preferences = UserDefaults.standard
    
    var hardware_id: String?
    var deviceType: DeviceCellType?
    
    @IBAction func changeStateSwitch(_ sender: Any) {
        if let deviceType = deviceType{
            switch deviceType{
            case .hueLightCell:
                if let hubId = preferences.string(forKey: "hub_id"), let hardware_id = hardware_id{
                    mainRequestClient.updateHueLight(from: .updateHueLight(hubId), hardware_id: hardware_id, on: stateSwicth.isOn, completion: { result in
                        switch result{
                        case .success(_):
                            print("Succesfully sent Hue Light state change")
                        case .failure(let error):
                            print("the error is \(error)")
                        }
                    })
                }
            case .tpLinkCell:
                if let hubId = preferences.string(forKey: "hub_id"), let hardware_id = hardware_id{
                    mainRequestClient.updateOutlet(from: .updateOutlet(hubId), hardware_id: hardware_id, on: stateSwicth.isOn, completion: { result in
                        switch result{
                        case .success(_):
                            print("Succesfully sent TP_Link device state change")
                        case .failure(let error):
                            print("the error is \(error)")
                        }
                    })
                }
            default:
                print("UNKNOWN DEVICE CHANGE REQUEST IN DEVICEBASICTABLEVIEWCELL")
            }
        }
        
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
