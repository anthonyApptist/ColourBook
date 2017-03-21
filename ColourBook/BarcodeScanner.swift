//
//  BarcodeScanner.swift
//  ColourBookScanner
//
//  Created by Anthony Ma on 15/11/2016.
//  Copyright © 2016 Anthony Ma. All rights reserved.
//

import UIKit
import AVFoundation

//protocol BarcodeDelegate {
//    func barcodeScanned(barcode: String)
//}

class BarcodeScanner: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
//    var delegate: BarcodeDelegate?
    
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    var captureSession: AVCaptureSession!
    
    var captureDevice: AVCaptureDevice!
    
    var deviceInput: AVCaptureDeviceInput!
    
    var code: String?
    
    var barcodeFrame: UIView!
    
    var exitCameraGesture: UISwipeGestureRecognizer!
    
    var tapToFocus: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCamera()
        
        // swipe gesture to exit camera
        
        exitCameraGesture = UISwipeGestureRecognizer.init(target: self, action: #selector(swipeDownGestureFunction))
        
        exitCameraGesture.direction = UISwipeGestureRecognizerDirection.down
        
        view.addGestureRecognizer(exitCameraGesture)
        
        /*
        // barcode frame?
        
        barcodeFrame = UIView()
        
        barcodeFrame.layer.borderColor = UIColor.green.cgColor
        
        barcodeFrame.layer.borderWidth = 2
        
        view.addSubview(barcodeFrame)
         
        view.bringSubview(toFront: barcodeFrame)
        */
        
        // tap to focus
        
        tapToFocus = UITapGestureRecognizer.init(target: self, action: #selector(tapFunction))
        
        tapToFocus.numberOfTapsRequired = 1
        
        tapToFocus.numberOfTouchesRequired = 1
        
        view.addGestureRecognizer(tapToFocus)
        
    }
    
    private func setupCamera() {
        
        captureSession = AVCaptureSession()
        
        captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        do {
            deviceInput = try AVCaptureDeviceInput(device: captureDevice)
        }
        catch {
            return
        }
        
        if captureSession.canAddInput(deviceInput) {
            captureSession.addInput(deviceInput)
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
            
//            barcodeFrame.frame = readableObject.bounds
            
//            view.layer.addSublayer(barcodeFrame.layer)
            
            print(code!)
            
            self.code = code!
            
//            self.barcodeTrimmedFrom(code: code!)
            
            captureSession.stopRunning()
            
            self.goToPostScanView(code: self.code!)
        }
    }
    
    func barcodeTrimmedFrom(code: String) {
        
        let trimmedCode = code.trimmingCharacters(in: NSCharacterSet.whitespaces)
        
        let trimmedCodeString = "\(trimmedCode)"
        var trimmedCodeAddZero: String
        
        trimmedCodeAddZero = "0" + "\(trimmedCodeString)"
            
        self.code = trimmedCodeAddZero
        
    }
    
    // swipe function
    
    func swipeDownGestureFunction() {
        
        // dismiss camera view
        
        self.dismiss(animated: true, completion: nil)
    }
    
    // tap to zoom
    
    func tapFunction() {

        let focusPoint: CGPoint = (self.previewLayer as  AVCaptureVideoPreviewLayer).captureDevicePointOfInterest(for: tapToFocus.location(in: self.view))
        
        print(focusPoint)
        
        do {
            try captureDevice?.lockForConfiguration()
            
            if captureDevice.isFocusPointOfInterestSupported {
                
                captureDevice.focusPointOfInterest = focusPoint

                captureDevice.focusMode = AVCaptureFocusMode.autoFocus
            }
            
            if captureDevice.isExposurePointOfInterestSupported {
                
                captureDevice.exposurePointOfInterest = focusPoint
                
                captureDevice.exposureMode = AVCaptureExposureMode.autoExpose
            }
            
            captureDevice?.unlockForConfiguration()
            
        } catch {
            //handle error
            
            print(error.localizedDescription)
            
            return
        }
        
    }
    
    
    
    func goToPostScanView(code: String) {
        
        let postScanView = PostScanViewController()
        
        postScanView.barcode =  "0023906012809" //code

        
        self.present(postScanView, animated: true)
        
    }
    
}
