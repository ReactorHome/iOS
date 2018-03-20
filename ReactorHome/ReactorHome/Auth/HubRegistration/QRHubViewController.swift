//
//  QRHubViewController.swift
//  ReactorHome
//
//  Created by Will Mock on 3/20/18.
//  Copyright © 2018 Mock. All rights reserved.
//

import UIKit
import AVFoundation

class QRHubViewController: UIViewController {
    
    @IBOutlet var topBar: UIView!
    
    let client = ReactorMainRequestClient()
    var captureSession = AVCaptureSession()
    
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?
    
    private let supportedCodeTypes = [AVMetadataObject.ObjectType.upce,
                                      AVMetadataObject.ObjectType.code39,
                                      AVMetadataObject.ObjectType.code39Mod43,
                                      AVMetadataObject.ObjectType.code93,
                                      AVMetadataObject.ObjectType.code128,
                                      AVMetadataObject.ObjectType.ean8,
                                      AVMetadataObject.ObjectType.ean13,
                                      AVMetadataObject.ObjectType.aztec,
                                      AVMetadataObject.ObjectType.pdf417,
                                      AVMetadataObject.ObjectType.itf14,
                                      AVMetadataObject.ObjectType.dataMatrix,
                                      AVMetadataObject.ObjectType.interleaved2of5,
                                      AVMetadataObject.ObjectType.qr]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get the back-facing camera for capturing videos
        var deviceDiscoverySession = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .back)
        
        if (deviceDiscoverySession == nil){//code for iphone 10?
            deviceDiscoverySession = AVCaptureDevice.default(.builtInDualCamera, for: AVMediaType.video, position: .back)
        }
        
        guard let captureDevice = deviceDiscoverySession else {
            print("Failed to get the camera device")
            return
        }
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Set the input device on the capture session.
            captureSession.addInput(input)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
            //            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
        
        // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer!)
        
        // Start video capture.
        captureSession.startRunning()
        
        // Move the message label and top bar to the front
        view.bringSubview(toFront: topBar)
        
        // Initialize QR Code Frame to highlight the QR code
        qrCodeFrameView = UIView()
        
        if let qrCodeFrameView = qrCodeFrameView {
            qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
            qrCodeFrameView.layer.borderWidth = 2
            view.addSubview(qrCodeFrameView)
            view.bringSubview(toFront: qrCodeFrameView)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Helper methods
    // TODO: WILL NEED TO EDIT HERE
    func launchApp(decodedMessage: String) {
        
        if presentedViewController != nil {
            return
        }
        
        if !decodedMessage.contains(":"){
            invalidQRAlert()
        }else{
            validQRSubmission(decodedMessage: decodedMessage)
        }
        
        //print(decodedMessage)
        
        //this is where I will make the request to add the hub to the user account
        
        
        
    }
    
    func validQRSubmission(decodedMessage: String) {
        let alertPrompt = UIAlertController(title: "Enter a name for your Hub!", message: "Name your hub! (Examples: My Home, 561 Trestle Ct., Work)", preferredStyle: .alert)
        
        alertPrompt.addTextField { (textField) in
            textField.text = "My Home"
        }
        
        let action = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: { (action) -> Void in
        })
        
        let action2 = UIAlertAction(title: "Register", style: UIAlertActionStyle.default, handler: { (action) -> Void in
            let textField = alertPrompt.textFields![0]
            if let name = textField.text{
                self.addHubRequest(name: name, decodedMessage: decodedMessage)
            }
            //do self.callSegue() inside of the completion for add hub request
        })
        
        alertPrompt.addAction(action)
        alertPrompt.addAction(action2)
        present(alertPrompt, animated: true, completion: nil)
    }
    
    func callSegue() {
        performSegue(withIdentifier: "QRSegue", sender: self)
    }
    
    //TODO: Actually make this add a hub
    func addHubRequest(name: String, decodedMessage: String){
        //client.
        print("Name: \(name) Addr: \(decodedMessage)")
    }
    
    func invalidQRAlert() {
        let alertPrompt = UIAlertController(title: "Could not scan QR code", message: "Invalid QR code", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) -> Void in
        })
        
        alertPrompt.addAction(action)
        present(alertPrompt, animated: true, completion: nil)
    }
}

extension QRHubViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if supportedCodeTypes.contains(metadataObj.type) {
            // If the found metadata is equal to the QR code metadata (or barcode) then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
                launchApp(decodedMessage: metadataObj.stringValue!)
            }
        }
    }
}

