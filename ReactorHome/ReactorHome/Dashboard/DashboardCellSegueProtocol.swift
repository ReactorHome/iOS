//
//  DashboardCellSegueProtocol.swift
//  ReactorHome
//
//  Created by Will Mock on 2/20/18.
//  Copyright © 2018 Mock. All rights reserved.
//

import Foundation

protocol DashboardCellSegueProtocol {
    func callSegueFromCell(cellType: DashboardCellType)
    //func showDisabledAlert(deviceName: String)
    func callOutletDeviceSequeFromCell(currDevice: ReactorAPIDevice)
    func callAlertDetailSegueFromCell(selectedAlertIndex: Int)
}
