//
//  OutletDeviceDetailViewController.swift
//  ReactorHome
//
//  Created by Will Mock on 4/4/18.
//  Copyright © 2018 Mock. All rights reserved.
//

import UIKit

class OutletDeviceDetailViewController: UIViewController {

    var device: ReactorAPIDevice?
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        print(device)
        self.title = device?.name!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
