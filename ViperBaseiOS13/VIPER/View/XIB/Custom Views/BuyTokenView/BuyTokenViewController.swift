//
//  BuyTokenViewController.swift
//  ViperBaseiOS13
//
//  Created by Deepika on 15/05/20.
//  Copyright © 2020 CSS. All rights reserved.
//

import UIKit
import ObjectMapper
import iOSDropDown

class BuyTokenViewController: UIViewController {
    
    @IBOutlet weak var modeView: UIView!
    @IBOutlet weak var selectpaymetTxtFld: DropDown!
    @IBOutlet weak var tokenLbl: UILabel!
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var amountTxtFld: UITextField!
    var ids: Int?
    var type: String?
    var productOrToken: String?
    var successDict: SuccessDict?
    var productDetails: ProductModel?
    var tokenDetails : TokenDetailsEntity?
    var delegate: RefreshDelegate?
    private lazy var loader  : UIView = {
        return createActivityIndicator(self.view)
    }()
    @IBOutlet weak var amountViewa: UIView!
    var cryptoCoin = [String]()
    var cryptoIndex = [Int]()
    var cryptoEntity = [Payment_method_type]()
    var paymentMode: String?
    
    var isFromProductBuy = false
    
    @IBOutlet weak var cancelBut: UIButton!
    @IBOutlet weak var okBut: UIButton!
    
    @IBOutlet weak var amounHeight: NSLayoutConstraint!
    @IBOutlet weak var cashBut: UIButton!
    @IBAction func openPaymetnMode(_ sender: UIButton) {
        
        if cashBut.tag == 101 {
            selectpaymetTxtFld.showList()
            cashBut.tag = 0
        } else {
            
            selectpaymetTxtFld.hideList()
            cashBut.tag = 101
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isFromProductBuy {
            amountViewa.isHidden = true
            tokenLbl.text = ""
            amounHeight.constant = 0
            
        } else {
             amountViewa.isHidden = false
            let availAmounts = String(tokenDetails?.avilable_token  ?? 0.0)
                tokenLbl.text = "Available tokens: " + nullStringToEmpty(string: availAmounts)
            amounHeight.constant = 60
        }
        
        cashBut.tag = 101
        modeView.applyEffectToView()
        amountTxtFld.keyboardType = .decimalPad
        amountTxtFld.delegate = self
        outerView.applyEffectToView()
    
        okBut.setTitle(Constants.string.OK.localize().uppercased(), for: .normal)
        okBut.setGradientBackground()
        
        cancelBut.borderLineWidth = 0.5
        cancelBut.borderColor = UIColor(hex: primaryColor)
        cancelBut.cornerRadius = 8
        cancelBut.setTitle(Constants.string.Cancel.localize().uppercased(), for: .normal)
        cancelBut.setTitleColor( UIColor(hex: primaryColor), for: .normal)
        
        
        if isFromProductBuy {
//                 self.cryptoEntity = self.productDetails?.payment_method_type ?? []
//
//                                             print("**self.productDetails?.payment_method_type",self.productDetails?.payment_method_type)
//
//                              for value in self.productDetails?.payment_method_type ??  [] {
//
//                                                self.cryptoCoin.append(nullStringToEmpty(string: value.name))
//                                                 self.cryptoIndex.append(1)
//
//                                          }
                   
               } else {
                    self.cryptoEntity = self.tokenDetails?.payment_method_type ?? []
                           
                           print("**self.productDetails?.payment_method_type",self.tokenDetails?.payment_method_type)
                           
            for value in self.tokenDetails?.payment_method_type ??  [] {
                               
                               self.cryptoCoin.append(nullStringToEmpty(string: value.name))
                               self.cryptoIndex.append(1)
                               
                           }
               }
        
        print("**scryptoCoin",cryptoCoin)
        
       
        
       
        selectpaymetTxtFld.arrowColor = .clear
        selectpaymetTxtFld.isUserInteractionEnabled = false
        
        
        selectpaymetTxtFld.didSelect{(selectedText , index ,id) in
            
            self.selectpaymetTxtFld.text = selectedText
            print("Selected String: \(selectedText) \n index: \(index) \n Id: \(id)")
            
           
            
        }
        
        
        selectpaymetTxtFld.optionArray = cryptoCoin
        selectpaymetTxtFld.optionIds = cryptoIndex
    }
    
    @IBAction func okClickEvent(_ sender: UIButton) {
        
        guard let paymentModes = selectpaymetTxtFld.text, !paymentModes.isEmpty else {
            
            ToastManager.show(title:  ErrorMessage.list.enterpaymentMode.localize(), state: .error)
            return
        }
        
        
       if isFromProductBuy {
        
            getInvestBuyTransaction(type: nullStringToEmpty(string: "BUY"), ids: ids ?? 0,token: 0.0)
           
       } else {
        
          guard let amount = amountTxtFld.text, !amount.isEmpty else {
                               ToastManager.show(title:  ErrorMessage.list.enterAmount.localize(), state: .error)
                               return
                           }
                           
                           let doubleamount = Double(nullStringToEmpty(string: amount)) ?? 0.0
                           let availAmount = tokenDetails?.avilable_token  ?? 0.0
                           
                           if doubleamount > availAmount  {
                               ToastManager.show(title:  nullStringToEmpty(string: "Amount is greater than available tokens"), state: .error)
                           } else {
                               
                               getInvestBuyTransaction(type: nullStringToEmpty(string: "BUY"), ids: ids ?? 0,token: availAmount)
                           }
        
        
        }
        
      
        
    }
    
    @IBAction func cancelClickEvent(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension BuyTokenViewController : PresenterOutputProtocol {
    
    func getInvestBuyTransaction(type: String, ids: Int,token: Double) {
        
        if isFromProductBuy {
            let val = self.cryptoEntity.filter({($0.name?.contains(nullStringToEmpty(string: self.selectpaymetTxtFld.text)))!})
            self.paymentMode = nullStringToEmpty(string: val.last?.value)
            
        } else {
            let val = self.cryptoEntity.filter({($0.name?.contains(nullStringToEmpty(string: self.selectpaymetTxtFld.text)))!})
            self.paymentMode = nullStringToEmpty(string: val.last?.value)
        }
        
        
        
        
        var params = [String: AnyObject]()
        
        if isFromProductBuy {
            params[TransactionParam.keys.product_id] = ids as AnyObject
        } else {
            params[TransactionParam.keys.token_id] = ids as AnyObject
        }
        
        
        params[TransactionParam.keys.type] = nullStringToEmpty(string: type) as AnyObject
        params["request_token"] = token as AnyObject
        params["payment_mode"] = self.paymentMode as AnyObject
        
        
        self.loader.isHidden = false
        print(">>> params",params)
        
        self.presenter?.HITAPI(api: Base.investBuyTransaction.rawValue, params: params , methodType: .POST, modelClass: SuccessDict.self, token: true)
        
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

//MARK: - UITextField Delegate
extension BuyTokenViewController: UITextFieldDelegate {
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        view.endEditingForce()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditingForce()
        return true
    }
    
}
