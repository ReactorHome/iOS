//
//  SettingsUserStatusViewController.swift
//  ReactorHome
//
//  Created by Will Mock on 4/10/18.
//  Copyright © 2018 Mock. All rights reserved.
//

import UIKit

class SettingsUserStatusViewController: UIViewController {
    
    let mainRequestClient = ReactorMainRequestClient()
    let preferences = UserDefaults.standard
    
    @IBOutlet var inputField: UITextField!
    
    @IBAction func addUserButton(_ sender: Any) {
        let groupId = preferences.integer(forKey: "group_Id")
        mainRequestClient.addUserToGroup(from: .addUserToGroup(groupId.description), userName: inputField.text!) { result in
            switch result{
            case .success(let reactorAPIResult):
                print("success \(reactorAPIResult)")
            case .failure(let error):
                print("the error \(error)")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    

}
