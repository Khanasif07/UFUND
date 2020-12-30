//
//  ScannerViewController.swift
//  KeyperX
//
//  Created by Prabha on 10/10/18.
//  Copyright © 2018 Prabha. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox

struct QRData {
    var codeString: String?
}

protocol PopupVCDelegate {
    func dismisspopupview(qrCodeStr:String) -> Void
}

class ScannerViewController: UIViewController,AVCaptureMetadataOutputObjectsDelegate {

    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerLbl: UILabel!
    var delegate: PopupVCDelegate?
    @IBOutlet weak var scannerView: QRScannerView! {
        didSet {
            scannerView.delegate = self
        }
    }
    
    var qrData: String? = nil {
        didSet {
            if qrData != nil {
                self.dismiss(animated:true, completion: { [weak self] in
                    
                    guard let self = self else {
                        return
                    }
                    
                    self.delegate?.dismisspopupview(qrCodeStr: nullStringToEmpty(string: self.qrData))
                })
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.view.backgroundColor = UIColor.white
      
       
        headerLbl.text = "Scan"
        
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
      
    }
    
    private func showCameraPermissionPopup() {
        let cameraMediaType = AVMediaType.video
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: cameraMediaType)
        
        switch cameraAuthorizationStatus {
        case .denied:
            NSLog("cameraAuthorizationStatus=denied")
            break
        case .authorized:
            NSLog("cameraAuthorizationStatus=authorized")
            break
        case .restricted:
            NSLog("cameraAuthorizationStatus=restricted")
            break
        case .notDetermined:
            NSLog("cameraAuthorizationStatus=notDetermined")
            
            // Prompting user for the permission to use the camera.
            AVCaptureDevice.requestAccess(for: cameraMediaType) { granted in
                DispatchQueue.main.sync {
                    if granted {
                        // do something
                        print("*** GRANTED")
                        
                            
                        
                        
                    } else {
                        // do something else
                           print("***NOT GRANTED")
                    }
                }
            }
        }
    }

   
    @IBAction func backBtnAct(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}


extension ScannerViewController: QRScannerViewDelegate {
    func qrScanningDidStop() {
        let buttonTitle = scannerView.isRunning ? "STOP" : "SCAN"
       
    }
    
    func qrScanningDidFail() {
        
        print("Scanning Failed. Please try again")
//        presentAlert(withTitle: "Error", message: "Scanning Failed. Please try again")
    }
    
    func qrScanningSucceededWithCode(_ str: String?) {
        self.qrData = nullStringToEmpty(string: str)
        print(" self.qrData", self.qrData)
    }
    
    
    
}




