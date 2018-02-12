//
//  RegisterViewController.swift
//  ReactorHome
//
//  Created by Will Mock on 2/9/18.
//  Copyright © 2018 Mock. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet var userNameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var confirmPasswordTextField: UITextField!
    
    let client = ReactorRegisterUserClient()
    
    @IBAction func registerButton(_ sender: Any) {
        guard let firstName = firstNameTextField.text, let lastName = lastNameTextField.text, let username = userNameTextField.text, let email = emailTextField.text, let password = passwordTextField.text, let confirmPassword = confirmPasswordTextField.text else{
            showEmptyFieldsAlert()
            return
        }
        
        guard let validEmail = validateEmail(field: email) else{
            showMalformedEmailAlert()
            return
        }
        
        if(password != confirmPassword){
            showNonMatchingPasswordsAlert()
            return
        }
        
        client.registerNewUser(from: .register, username: username, email: validEmail, firstName: firstName, lastName: lastName, password: password){ result in
            switch result {
            case .success(let successResult):
                print("success is \(successResult)")
                
                self.showSuccessfulUserRegistrationAlert()
                
            case .failure(let error):
                print("the error \(error)")
            }
        }
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //email vaildator function
    func validateEmail(field: String?) -> String? {
        guard let trimmedText = field?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            return nil
        }
        
        guard let dataDetector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue) else {
            return nil
        }
        
        let range = NSMakeRange(0, NSString(string: trimmedText).length)
        let allMatches = dataDetector.matches(in: trimmedText,
                                              options: [],
                                              range: range)
        
        if allMatches.count == 1,
            allMatches.first?.url?.absoluteString.contains("mailto:") == true
        {
            return trimmedText
        }
        return nil
    }
    
    func showSuccessfulUserRegistrationAlert(){
        let alert = UIAlertController(title: "Account Successfully Created!", message: "Press OK to continue to the login screen.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default){ action in
            self.performSegue(withIdentifier: "registerSegue", sender: self)
        })
        
        self.present(alert, animated: true)
    }
    
    //alert for no entries in required fields AKA all are required
    func showEmptyFieldsAlert(){
        let alert = UIAlertController(title: "Please fill in all fields", message: "All fields are required. Please fill in all fields and try again.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    //alert to show if the passwords do not match
    func showNonMatchingPasswordsAlert(){
        let alert = UIAlertController(title: "Passwords do not match", message: "The Password and Confirm Password fields do not match. Please try again.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true)
    }
    //malformed email error
    func showMalformedEmailAlert(){
        let alert = UIAlertController(title: "Email Invalid", message: "Please enter a vaild email address.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    //user already exists error
    func showUsernameAlreadyExistsAlert(){
        let alert = UIAlertController(title: "Username already exists!", message: "Please try again with a different username.", preferredStyle: .alert)
        
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
