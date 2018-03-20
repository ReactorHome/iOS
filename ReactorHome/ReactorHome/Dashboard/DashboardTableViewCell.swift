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
    
    //var data: 
    
    @IBOutlet var innerTableView: UITableView!
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
        innerTableView.delegate = self
        innerTableView.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cellType = cellType {
            switch cellType {
            case .alertsCell:
                //will need to make the request to get the alerts and the determine type in here... this may not be architected exactly correctly yet, but basic concept is here
                let cell = tableView.dequeueReusableCell(withIdentifier: "alertbasiccell") as! AlertBasicTableViewCell
                
                cell.titleLabel.text = "Alert!"
                
                return cell
            case .devicesCell:
                let cell = tableView.dequeueReusableCell(withIdentifier: "devicebasiccell") as! DeviceBasicTableViewCell
                
                cell.titleLabel.text = "Device"
                
                return cell
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
