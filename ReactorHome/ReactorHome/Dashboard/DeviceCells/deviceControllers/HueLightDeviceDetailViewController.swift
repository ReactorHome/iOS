//
//  HueLightDeviceDetailViewController.swift
//  ReactorHome
//
//  Created by Will Mock on 4/4/18.
//  Copyright © 2018 Mock. All rights reserved.
//

import UIKit

class HueLightDeviceDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    var device: ReactorAPIDevice?
    
    let mainRequestClient = ReactorMainRequestClient()
    let preferences = UserDefaults.standard
    
    let cellTitleArray = ["Status","Connection","Hardware ID","Manufacturer","Model"]
    var valueArray: [String] = []
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var slider: UISlider!
    @IBAction func sliderAction(_ sender: Any) {
        if let hubId = preferences.string(forKey: "hub_id"), let hardware_id = device?.hardware_id{
            mainRequestClient.updateHueLightBrightness(from: .updateHueLight(hubId), hardware_id: hardware_id, brightness: Int(slider.value), completion: { result in
                switch result{
                case .success(_):
                    print("Updated brightness")
                case .failure(let error):
                    print("the error is \(error)")
                }
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        slider.isContinuous = false
        slider.maximumValue = 254.00
        slider.minimumValue = 1.00
        
        self.title = device?.name!
        if let value = device?.brightness{
            slider.setValue(Float(value), animated: true)
        }
        
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
                slider.isEnabled = true
            }else{
                valueArray.append("Offline")
                slider.isEnabled = false
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "hueLightInfoCell")
        cell?.textLabel?.text = cellTitleArray[indexPath.row]
        cell?.detailTextLabel?.text = valueArray[indexPath.row]
        return cell!
    }
    
    //hueLightInfoCell

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
