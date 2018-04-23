//
//  AlertDetailViewController.swift
//  ReactorHome
//
//  Created by Will Mock on 4/23/18.
//  Copyright © 2018 Mock. All rights reserved.
//

import UIKit

class AlertDetailViewController: UIViewController {

    let mainRequestClient = ReactorMainRequestClient()
    let preferences = UserDefaults.standard
    
    var fileName: String?
    
    @IBOutlet var imageView: UIImageView!
    
    @IBAction func markUnsafeButton(_ sender: Any) {
        
    }
    
    @IBAction func markSafeButton(_ sender: Any) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let fileName = fileName, let url = URL(string: "https://api.myreactorhome.com/user/api/cloud/face/image/\(fileName)"){
                imageView.contentMode = .scaleAspectFit
                downloadImage(url: url)
        }
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    
    func downloadImage(url: URL) {
        print("Download Started")
        getDataFromUrl(url: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                self.imageView.image = UIImage(data: data)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
