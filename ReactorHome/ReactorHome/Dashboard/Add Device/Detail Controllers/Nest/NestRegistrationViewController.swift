//
//  NestRegistrationViewController.swift
//  ReactorHome
//
//  Created by Will Mock on 4/23/18.
//  Copyright © 2018 Mock. All rights reserved.
//

import UIKit

class NestRegistrationViewController: UIViewController {

    @IBOutlet var inputField: UITextField!
    @IBAction func doneButtonAction(_ sender: Any) {
        if inputField.text != nil{
            //request goes here
            self.navigationController?.popToRootViewController(animated: true)
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
    
    func showSuccessAlert(){
        let alert = UIAlertController(title: "Successfully registered with Nest!", message: "Click okay to return to the dashboard.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { result in
            self.navigationController?.popToRootViewController(animated: true)
        }))
        
        self.present(alert, animated: true)
    }
    
    func showErrorAlert(){
        let alert = UIAlertController(title: "Something went wrong!", message: "There was an error processing your request. Please try again.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { result in
            self.navigationController?.popViewController(animated: true)
        }))
        
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
