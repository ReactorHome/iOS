//
//  DashboardTableViewCell.swift
//  ReactorHome
//
//  Created by Will Mock on 2/20/18.
//  Copyright © 2018 Mock. All rights reserved.
//

import UIKit

class DashboardTableViewCell: UITableViewCell {
    
    var delegate: DashboardCellSegueProtocol!
    
    var cellType: DashboardCellType?
    
    @IBOutlet var sectionTitleText: UILabel!
    @IBOutlet var buttonOutlet: UIButton!
    
    @IBAction func buttonAction(_ sender: Any) {
        print("button action works!")
        
        if(self.delegate != nil){ //Just to be safe.
            self.delegate.callSegueFromCell(cellType: cellType!)
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
