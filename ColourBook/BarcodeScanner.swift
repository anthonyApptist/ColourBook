//
//  BarcodeScanner.swift
//  ColourBookScanner
//
//  Created by Anthony Ma on 15/11/2016.
//  Copyright © 2016 Anthony Ma. All rights reserved.
//

import UIKit
import AVFoundation

protocol BarcodeDelegate {
    func barcodeScanned(barcode: String)
}

class BarcodeScanner: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var delegate: BarcodeDelegate?
    
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    var captureSession: AVCaptureSession!
    
    var code: String?
    
    var barcodeFrame: UIView!
    
    var exitCameraGesture: UISwipeGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        exitCameraGesture = UISwipeGestureRecognizer.init(target: self, action: #selector(swipeDownGestureFunction))
        
        exitCameraGesture.direction = UISwipeGestureRecognizerDirection.down
        
        barcodeFrame = UIView()
        
        barcodeFrame.layer.borderColor = UIColor.green.cgColor
        
        barcodeFrame.layer.borderWidth = 2
        
        view.addSubview(barcodeFrame)
        
        view.bringSubview(toFront: barcodeFrame)
        
        view.addGestureRecognizer(exitCameraGesture)
        
        setupCamera()
        
    }
    
    private func setupCamera() {
        
        captureSession = AVCaptureSession()
        
        let videoCaptureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        let videoInput: AVCaptureDeviceInput?
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        }
        catch {
            return
        }
        
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        }
        else {
            scanningUnavailable()
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            
            metadataOutput.metadataObjectTypes = [AVMetadataObjectTypeEAN13Code]
            
        }
        else {
            scanningUnavailable()
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        previewLayer.frame = view.layer.bounds
        
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        view.layer.addSublayer(previewLayer)
        
        captureSession.startRunning()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (captureSession.isRunning == false) {
            captureSession.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (captureSession.isRunning == true) {
            captureSession.stopRunning()
        }
    }
    
    // MARK: scanning unavailable
    
    func scanningUnavailable() {
        let alert = UIAlertController(title: "Can't scan", message: "No device available for scanning", preferredStyle: .alert)
        let alertAction = UIAlertAction.init(title: "OK", style: .default, handler: nil)
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)
        captureSession = nil
    }
    
    // MARK: delegate function
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        // This is the delegate'smethod that is called when a code is read
        for metadata in metadataObjects {
            
            let readableObject = metadata as! AVMetadataMachineReadableCodeObject
            
            let code = readableObject.stringValue
            
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            
            barcodeFrame.frame = readableObject.bounds
            
            view.layer.addSublayer(barcodeFrame.layer)
            
            print(code!)
            
            barcodeTrimmedFrom(code: code!)
            
            captureSession.stopRunning()
            
            goToPostScanView(code: self.code!)
        }
    }
    
    func barcodeTrimmedFrom(code: String) {
        
        let trimmedCode = code.trimmingCharacters(in: NSCharacterSet.whitespaces)
        
        let trimmedCodeString = "\(trimmedCode)"
        var trimmedCodeNoZero: String
        
        if trimmedCodeString.hasPrefix("0") && trimmedCodeString.characters.count > 1 {
            trimmedCodeNoZero = String(trimmedCodeString.characters.dropFirst())
           
            self.code = trimmedCodeNoZero
            
            /*
            let alert = UIAlertController(title: "Barcode Scanned", message: trimmedCodeNoZero, preferredStyle: .alert)
            
            let alertAction = UIAlertAction(title: "OK", style: .destructive, handler: nil)
            
            alert.addAction(alertAction)
            
            present(alert, animated: true, completion: nil)
            */
        }
            
        else {
            
            /*
            let alert = UIAlertController(title: "Barcode Scanned", message: code, preferredStyle: .alert)
            
            let alertAction = UIAlertAction(title: "OK", style: .destructive, handler: nil)
            
            alert.addAction(alertAction)
            
            present(alert, animated: true, completion: nil)
            */
        }
    }
    
    func swipeDownGestureFunction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func goToPostScanView(code: String) {
        
       let postScanView = PostScanViewController()
        
       postScanView.barcode = "0023906001698"

       self.present(postScanView, animated: true)
        
    }
    
}


