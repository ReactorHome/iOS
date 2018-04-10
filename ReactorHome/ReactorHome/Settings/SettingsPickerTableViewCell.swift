//
//  SettingsPickerTableViewCell.swift
//  ReactorHome
//
//  Created by Will Mock on 4/10/18.
//  Copyright © 2018 Mock. All rights reserved.
//

import UIKit

class SettingsPickerTableViewCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var textField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
