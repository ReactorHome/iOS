//
//  HueViewController.swift
//  ReactorHome
//
//  Created by Will Mock on 4/17/18.
//  Copyright © 2018 Mock. All rights reserved.
//

import UIKit

class HueViewController: UIViewController {
    
    let mainRequestClient = ReactorMainRequestClient()
    let preferences = UserDefaults.standard
    
    var host: String?
    
    var eventsResult: ReactorAPIEventsResult?
    
    var bridgeEvents: [ReactorAPIEvent] = []

    @IBAction func addHueButton(_ sender: Any) {
        let hubId = preferences.string(forKey: "hub_id")
        
        if let hubId = hubId{
            mainRequestClient.registerHueBridge(from: .registerHueBridge(hubId), host: host!, completion: { result in
                switch result{
                case .success:
                    //print("Registered Bridge")
                    self.showSuccessAlert()
                case .failure(let error):
                    print("the error \(error)")
                }
            })
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        if let groupId = preferences.string(forKey: "group_Id"){
            mainRequestClient.getEvents(from: .getEventsForGroup(groupId)) { result in
                switch result{
                case .success(let reactorAPIEvents):
                    guard let getEventsResults = reactorAPIEvents else {
                        print("Unable to get Events")
                        return
                    }
                    
                    self.eventsResult = getEventsResults
                    
                    for item in getEventsResults.events!{
                        if item.json != nil{
                            self.bridgeEvents.append(item)
                        }
                    }
                    
                    self.host = self.bridgeEvents.last?.json?.host
                case .failure(let error):
                    print("the error \(error)")
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showSuccessAlert(){
        let alert = UIAlertController(title: "Added Bridge Successfully!", message: "Request to add the Hue Bridge has been successfully sent.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { result in
            self.navigationController?.popViewController(animated: true)
        }))
        
        self.present(alert, animated: true)
    }
}
