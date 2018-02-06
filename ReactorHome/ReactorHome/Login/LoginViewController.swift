//
//  LoginViewController.swift
//  ReactorHome
//
//  Created by Will Mock on 2/5/18.
//  Copyright © 2018 Mock. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet var usernameField: UITextField!
    @IBOutlet var passwordField: UITextField!
    
    @IBAction func loginButton(_ sender: Any) {
        let username = usernameField.text
        let password = passwordField.text
        
        let alert = UIAlertController(title: "Invalid Username or Password", message: "Please try again", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        if (username == "" || password == "") {
            self.present(alert, animated: true)
        }
        
        doLoginRequest(username: username, password: password)
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
        //print("username:\(username!) and password:\(password!)")
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
