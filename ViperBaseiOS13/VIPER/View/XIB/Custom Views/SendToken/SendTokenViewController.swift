//
//  SendTokenViewController.swift
//  ViperBaseiOS13
//
//  Created by Deepika on 15/05/20.
//  Copyright © 2020 CSS. All rights reserved.
//

import UIKit
import QRCodeReader
import ObjectMapper

class SendTokenViewController: UIViewController {
    @IBOutlet weak var cancelBut: UIButton!
       @IBOutlet weak var okBut: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var addreesTxtFld: UITextField!
    @IBOutlet weak var addreesView: UIView!
    @IBOutlet weak var amountTxtFld: UITextField!
    @IBOutlet weak var outerView: UIView!
    private lazy var loader  : UIView = {
          return createActivityIndicator(self.view)
      }()
     var successDict: SuccessDict?
       var delegate: RefreshDelegate?
    lazy var readerVC: QRCodeReaderViewController = {
          let builder = QRCodeReaderViewControllerBuilder {
              $0.reader = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
          }
          
          return QRCodeReaderViewController(builder: builder)
      }()
      var qrString = String()
    var token: Tokens?
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addreesView.applyEffectToView()
        amountTxtFld.keyboardType = .decimalPad
        addreesTxtFld.delegate = self
        amountTxtFld.delegate = self
        outerView.applyEffectToView()
       okBut.setTitle(Constants.string.OK.localize().uppercased(), for: .normal)
       okBut.setGradientBackground()
        titleLbl.text = nullStringToEmpty(string: token?.token_details?.tokensymbol)
       cancelBut.borderLineWidth = 0.5
       cancelBut.borderColor = UIColor(hex: primaryColor)
       cancelBut.cornerRadius = 8
       cancelBut.setTitle(Constants.string.Cancel.localize().uppercased(), for: .normal)
       cancelBut.setTitleColor( UIColor(hex: primaryColor), for: .normal)
    }


    @IBAction func openQRScanner(_ sender: UIButton) {
       let controller = Router.main.instantiateViewController(withIdentifier:"ScannerViewController") as! ScannerViewController
              controller.delegate = self
              self.present(controller, animated: true, completion: nil)
    }
    
    
       @IBAction func okClickEvent(_ sender: UIButton) {
             view.endEditingForce()
                  guard let amount = amountTxtFld.text, !amount.isEmpty else {
                      ToastManager.show(title:  ErrorMessage.list.enterAmount.localize(), state: .error)
                      return
                  }
        
           guard let address = addreesTxtFld.text, !address.isEmpty else {
               
               ToastManager.show(title:  ErrorMessage.list.enterAddress.localize(), state: .error)
               return
           }
       

           let doubleamount = Double(nullStringToEmpty(string: amount)) ?? 0.0
           let tokenAcquire = token?.token_acquire ?? 0.0

           if doubleamount > tokenAcquire  {
               ToastManager.show(title:  nullStringToEmpty(string: "Amount is greater than token acquire"), state: .error)
           } else {

            getInvestBuyTransaction(token_id: token?.id ?? 0, amount: doubleamount,toaddress: nullStringToEmpty(string: address))
           
         }
       }
       
       @IBAction func cancelClickEvent(_ sender: UIButton) {
           self.dismiss(animated: true, completion: nil)
       }
}

//MARK: - UITextField Delegate
extension SendTokenViewController: UITextFieldDelegate {
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        view.endEditingForce()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditingForce()
        return true
    }
    
}

extension SendTokenViewController : PresenterOutputProtocol {
    
    func getInvestBuyTransaction(token_id: Int, amount: Double,toaddress: String) {
        
        var params = [String: AnyObject]()
        params[TransactionParam.keys.token_id] = token_id as AnyObject
        params["amount"] = amount as AnyObject
         params["toaddress"] = nullStringToEmpty(string: toaddress) as AnyObject
       
        self.loader.isHidden = false
        print(">>> params",params)
        
        self.presenter?.HITAPI(api: Base.sendCoin.rawValue, params: params , methodType: .POST, modelClass: SuccessDict.self, token: true)
        
    }
    
    func showSuccess(api: String, dataArray: [Mappable]?, dataDict: Mappable?, modelClass: Any) {
        
        self.loader.isHidden = true
        self.successDict = dataDict as? SuccessDict
        ToastManager.show(title:  nullStringToEmpty(string: self.successDict?.success?.msg), state: .success)
        
        self.dismiss(animated:true, completion: { [weak self] in
                    
                    
                                    guard let self = self else {
                                        return
                    }
            self.delegate?.didReceiveRefresh(isRefresh: true, successDict: self.successDict!)
                    
                    
                    })
        
    }
    
    func showError(error: CustomError) {
        
        self.loader.isHidden = true
        ToastManager.show(title:  nullStringToEmpty(string: error.localizedDescription.trimString()), state: .error)
    }
    
}

// MARK: - QRCodeReaderViewController Delegate Methods
extension SendTokenViewController: QRCodeReaderViewControllerDelegate {
    
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        print(reader.codeReader.metadataOutput)
        print(result.value)
        print(result.metadataType)
        qrString = result.value
        reader.stopScanning()
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
        addreesTxtFld.text = nullStringToEmpty(string: qrString)
    }

    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
        
        dismiss(animated: true, completion: nil)
    }
}
extension SendTokenViewController: PopupVCDelegate {
    func dismisspopupview(qrCodeStr: String) {
        addreesTxtFld.text = nullStringToEmpty(string: qrCodeStr)
        qrString = qrCodeStr
    }
    
    
}
