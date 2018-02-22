//
//  AlertTableViewCell.swift
//  ReactorHome
//
//  Created by Will Mock on 10/17/17.
//  Copyright © 2017 Mock. All rights reserved.
//

import UIKit

class AlertTableViewCell: UITableViewCell, UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "alertcell", for: indexPath)
        
        cell.textLabel?.text = "Testing"
        
        return cell
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
