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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
