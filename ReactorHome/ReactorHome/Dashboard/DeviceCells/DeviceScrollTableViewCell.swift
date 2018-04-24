//
//  DeviceScrollTableViewCell.swift
//  ReactorHome
//
//  Created by Will Mock on 4/19/18.
//  Copyright © 2018 Mock. All rights reserved.
//

import UIKit

class DeviceScrollTableViewCell: UITableViewCell {

    let mainRequestClient = ReactorMainRequestClient()
    let preferences = UserDefaults.standard
    
    var hardware_id: String?
    var deviceType: DeviceCellType?
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var tempInput: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
