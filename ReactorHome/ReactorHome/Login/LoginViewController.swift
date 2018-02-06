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
    
    @IBAction func signupButton(_ sender: Any) {
        return
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func doLoginRequest(username:String?, password:String?){
        print("username:\(username!) and password:\(password!)")
        
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
                
                //print(oauthResults)
                
                let preferences = UserDefaults.standard
                
                preferences.set(oauthResults.access_token, forKey: "access_token")
                preferences.set(oauthResults.expires_in, forKey: "expires_in")
                preferences.set(oauthResults.refresh_token, forKey: "refresh_token")
                
                //testing putting user prefs into system defaults WORKS
//                print(preferences.string(forKey: "access_token")!)
//                print(preferences.string(forKey: "expires_in")!)
//                print(preferences.string(forKey: "refresh_token")!)
                
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
