//
//  OutletDeviceDetailViewController.swift
//  ReactorHome
//
//  Created by Will Mock on 4/4/18.
//  Copyright © 2018 Mock. All rights reserved.
//

import UIKit

class OutletDeviceDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var device: ReactorAPIDevice?
    
    let cellTitleArray = ["Status","Connection","Hardware ID","Manufacturer","Model"]
    var valueArray: [String] = []
    
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

//        print(device)
        self.title = device?.name!
        
        if let status = device?.on{
            if status{
                valueArray.append("On")
            }else{
                valueArray.append("Off")
            }
        }
        
        if let connection = device?.connected{
            if connection{
                valueArray.append("Online")
            }else{
                valueArray.append("Offline")
            }
        }
        
        valueArray.append(device?.hardware_id! ?? "unknown")
        valueArray.append(device?.manufacturer! ?? "unknown")
        valueArray.append(device?.model! ?? "unknown")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "outletInfoCell")
        cell?.textLabel?.text = cellTitleArray[indexPath.row]
        cell?.detailTextLabel?.text = valueArray[indexPath.row]
        return cell!
    }
}
