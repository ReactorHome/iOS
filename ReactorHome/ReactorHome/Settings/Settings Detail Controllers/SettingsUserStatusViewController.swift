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
        if let username = inputField.text{
            mainRequestClient.addUserToGroup(from: .addUserToGroup(groupId.description), userName: username) { result in
                switch result{
                case .success(let reactorAPIResult):
                    print("success \(reactorAPIResult)")
                    self.showAddedUserAlert()
                case .failure(let error):
                    print("the error \(error)")
                    self.showInvalidUserAlert()
                }
            }
        }else{
            self.showInvalidUserAlert()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func showInvalidUserAlert(){
        let alert = UIAlertController(title: "Invalid Username", message: "Please try again", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    func showAddedUserAlert(){
        let alert = UIAlertController(title: "Added User to Group!", message: "Successfully Added User to Group.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true)
    }
    
}
