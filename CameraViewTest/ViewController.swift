//
//  ViewController.swift
//  CameraViewTest
//
//  Created by comps on 1/18/15.
//  Copyright (c) 2015 Carleton College. All rights reserved.
//
import UIKit
import AVFoundation

class ViewController: UIViewController {
    @IBOutlet weak var webView: UIWebView!
    
    let captureSession = AVCaptureSession()
    var previewLayer : AVCaptureVideoPreviewLayer?
    
    // If we find a device we'll store it here for later use
    var captureDevice : AVCaptureDevice?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = NSURL(string: "http://cmc307-08.mathcs.carleton.edu/~comps/backend/teapot/indexTest.py")
        //let url = NSURL(string: "http://cmc307-08.mathcs.carleton.edu/~comps/backend/walkAround/webapp.py?latitude=0&longitude=0&altitude=30&pitch=0&yaw=0&roll=0")
        let request = NSURLRequest(URL: url!)
        webView.loadRequest(request)
        webView.opaque = false
        webView.backgroundColor = UIColor.clearColor()
        println(webView.frame.maxX)
        
        
        // Do any additional setup after loading the view, typically from a nib.
        captureSession.sessionPreset = AVCaptureSessionPresetHigh
        
        let devices = AVCaptureDevice.devices()
        
        // Loop through all the capture devices on this phone
        for device in devices {
            // Make sure this particular device supports video
            if (device.hasMediaType(AVMediaTypeVideo)) {
                // Finally check the position and confirm we've got the back camera
                if(device.position == AVCaptureDevicePosition.Back) {
                    captureDevice = device as? AVCaptureDevice
                    if captureDevice != nil {
                        println("Capture device found")
                        beginSession()
                    }
                }
            }
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func configureDevice() {
        if let device = captureDevice {
            device.lockForConfiguration(nil)
            device.focusMode = .Locked
            device.unlockForConfiguration()
        }
        
    }
    
    func beginSession() {
        
        configureDevice()
        
        var err : NSError? = nil
        captureSession.addInput(AVCaptureDeviceInput(device: captureDevice, error: &err))
        
        if err != nil {
            println("error: \(err?.localizedDescription)")
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.view.layer.addSublayer(previewLayer)
        previewLayer?.frame = self.view.layer.frame
        self.view.bringSubviewToFront(webView)
        captureSession.startRunning()
    }



}

