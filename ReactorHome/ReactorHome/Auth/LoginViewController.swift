//
//  LoginViewController.swift
//  ReactorHome
//
//  Created by Will Mock on 2/5/18.
//  Copyright © 2018 Mock. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    let client = ReactorOauthClient()
    let client2 = ReactorMainRequestClient()
    
    @IBOutlet var usernameField: UITextField!
    @IBOutlet var passwordField: UITextField!
    
    @IBAction func loginButton(_ sender: Any) {
        let username = usernameField.text
        let password = passwordField.text
        
        if (username == "" || password == "") {
            showInvalidAlert()
        }else{
            doLoginRequest(username: username, password: password)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func doLoginRequest(username:String?, password:String?){
        
        //unwrapping the username and password so we dont need to in the rest of the function
        guard let username = username,let password = password else{
            print("username or password nil")
            return
        }
        
        client.getOauthToken(from: .oauth, username: username, password: password) { result in
            switch result {
            case .success(let reactorAPIResult):
                guard let oauthResults = reactorAPIResult else {
                    print("There was an error")
                    self.showInvalidAlert()
                    return
                }
                
                //setting access_token
                let preferences = UserDefaults.standard
                preferences.set(oauthResults.access_token, forKey: "access_token")
                
                print(oauthResults.access_token)
                
                //setting expires_at
                let currentDateTime = Date()
                let expires_in = TimeInterval(oauthResults.expires_in!)
                let expires_at = currentDateTime.addingTimeInterval(expires_in)
                preferences.set(expires_at, forKey: "expires_at")
                
                //setting refresh_token
                preferences.set(oauthResults.refresh_token, forKey: "refresh_token")
                
                self.performSegue(withIdentifier: "loginSegue", sender: self)
                
            case .failure(let error):
                print("the error \(error)")
                self.showInvalidAlert()
            }
        }
    }
    
    //show an alert for an invalid username or password
    func showInvalidAlert(){
        let alert = UIAlertController(title: "Invalid Username or Password", message: "Please try again", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
