//
//  TokenAssetsAmountViewController.swift
//  ViperBaseiOS13
//
//  Created by Deepika on 25/02/20.
//  Copyright © 2020 CSS. All rights reserved.
//

import UIKit
import ObjectMapper
import iOSDropDown

class Invest {
    
    var percent: Int?
    var value: Double?
    var earn: Double?
    
    init(percent: Int?,value: Double?,earn: Double? ) {
        
        self.percent = percent
        self.value = value
        self.earn = earn
        
    }
    
}

protocol RefreshDelegate {
    func didReceiveRefresh(isRefresh: Bool,successDict: SuccessDict)
}

class TokenAssetsAmountViewController: UIViewController {
    
  
    @IBOutlet weak var paymentView: UIView!
    @IBOutlet weak var paymentModeTxtFld: DropDown!
    @IBOutlet weak var earningLbl: UILabel!
    var urlBase: String?
    @IBOutlet weak var childView: UIView!
    @IBOutlet weak var dropDownButton: UIButton!
    @IBOutlet weak var amountTxtFld: DropDown!
    @IBOutlet weak var amountView: UIView!
    @IBOutlet weak var cancelBut: UIButton!
    @IBOutlet weak var okBut: UIButton!
    @IBOutlet weak var transLbl: UILabel!
    private lazy var loader  : UIView = {
             return createActivityIndicator(self.view)
    }()
    var ids: Int?
    var type: String?
    var productOrToken: String?
    var successDict: SuccessDict?
    var productDetails: ProductModel?
    var invests = [Invest]()
    var amountString = [String]()
    var amountIndex = [Int]()
    var earningPercent: String?
    var paymentMode: String?
    var cryptoCoin = [String]()//["BTC","ETH","FIAT"]
    var cryptoIndex = [Int]()
    var cryptoEntity = [Payment_method_type]()
    var delegate: RefreshDelegate?
    
    @IBOutlet weak var cashBut: UIButton!
    @IBAction func openPaymetnMode(_ sender: UIButton) {
        
        if cashBut.tag == 101 {
                     paymentModeTxtFld.showList()
                     cashBut.tag = 0
                 } else {
            
                     paymentModeTxtFld.hideList()
                     cashBut.tag = 101
                 }
      }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        paymentView.applyEffectToView()
        amountView.applyEffectToView()
        amountTxtFld.applyEffectToTextField(placeHolderString: Constants.string.amountUSD.localize())
        transLbl.text = Constants.string.transAmount.localize()
        okBut.setTitle(Constants.string.OK.localize().uppercased(), for: .normal)
        okBut.setGradientBackground()
        
        cancelBut.borderLineWidth = 0.5
        cancelBut.borderColor = UIColor(hex: primaryColor)
        cancelBut.cornerRadius = 8
        cancelBut.setTitle(Constants.string.Cancel.localize().uppercased(), for: .normal)
        cancelBut.setTitleColor( UIColor(hex: primaryColor), for: .normal)
        
        amountTxtFld.isUserInteractionEnabled = false
       
        
        amountTxtFld.didSelect{(selectedText , index ,id) in
                         
                         self.amountTxtFld.text = selectedText
                         print("Selected String: \(selectedText) \n index: \(index) \n Id: \(id)")
                       
                       
                       if self.invests.count > 0 {
                              
                           let entity = self.invests[index]
                           
                           print(">>>entity",entity.percent)
                           self.earningPercent = String(entity.percent ?? 0)
                           
                           self.earningLbl.text = "Earn: " + String(entity.earn ?? 0.0)
                              
                           print(">>>entity", self.earningPercent)
                        
                       }
                      
                         
            
                   }
        
        
        
        for value in self.cryptoEntity ??  [] {
                                                       
                self.cryptoCoin.append(nullStringToEmpty(string: value.name))
                self.cryptoIndex.append(1)
                                                       
        }
        
        
        paymentModeTxtFld.optionArray = cryptoCoin
                               paymentModeTxtFld.optionIds = cryptoIndex
        
        paymentModeTxtFld.isUserInteractionEnabled = false
              
               
               paymentModeTxtFld.didSelect{(selectedText , index ,id) in
                                
                                self.paymentModeTxtFld.text = selectedText
                                print("Selected String: \(selectedText) \n index: \(index) \n Id: \(id)")
        
                                  self.paymentMode = selectedText
                                
                          }
        
        
                       
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.getProductDetails(id: ids)
    }
    @IBAction func cancelClickEvent(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
   
    @IBAction func openDropDrown(_ sender: UIButton) {

           if dropDownButton.tag == 101 {
               amountTxtFld.showList()
               dropDownButton.tag = 0
           } else {
               amountTxtFld.hideList()
               dropDownButton.tag = 101
           }
       }
    
    override func viewDidLayoutSubviews() {
           super.viewDidLayoutSubviews()
          
           dropDownButton.tag = 101
           amountTxtFld.arrowColor = .clear
        
    cashBut.tag = 101
                  paymentModeTxtFld.arrowColor = .clear
           
    }
    
    
    @IBAction func okClickEvent(_ sender: UIButton) {
        
        guard let paymentModes = paymentModeTxtFld.text, !paymentModes.isEmpty else {
                   
                   ToastManager.show(title:  ErrorMessage.list.enterpaymentMode.localize(), state: .error)
                   return
        }
        
        
        guard let amount = amountTxtFld.text, !amount.isEmpty else {
            
            ToastManager.show(title:  ErrorMessage.list.enterAmount.localize(), state: .error)
            return
        }
        
        var params = [String: AnyObject]()
        
        if productOrToken == nullStringToEmpty(string: BuyOrInvest.token) {
            
            params[TransactionParam.keys.token_id] = self.ids as AnyObject
            
        } else {
            
            params[TransactionParam.keys.product_id] = self.ids as AnyObject
        }
        
        params[TransactionParam.keys.type] = self.type as AnyObject
        params[TransactionParam.keys.amount] = nullStringToEmpty(string: self.earningPercent) as AnyObject
        getInvestBuyTransaction(type: nullStringToEmpty(string: self.type), ids: self.ids ?? 0, amount: nullStringToEmpty(string: self.earningPercent), paymentMode: paymentModes)
        
    }
}


//MARK: - PresenterOutputProtocol
extension TokenAssetsAmountViewController: PresenterOutputProtocol {
    
    func getProductDetails(id:Int?) {
        let url = "\(Base.productDetails.rawValue)/\(id ?? 0)"
        urlBase = url
        self.presenter?.HITAPI(api: nullStringToEmpty(string: urlBase), params: nil, methodType:.GET, modelClass: ProductModel.self, token: true)
        self.loader.isHidden = false
    }
    
    func showSuccess(api: String, dataArray: [Mappable]?, dataDict: Mappable?, modelClass: Any) {
        
        print(">>>api",api)
        switch api {

        case Base.investBuyTransaction.rawValue:

            self.loader.isHidden = true
            self.successDict = dataDict as? SuccessDict

            if self.successDict?.success != nil {

                ToastManager.show(title: nullStringToEmpty(string: self.successDict?.success?.msg), state: .success)
               
                
                
                self.dismiss(animated:true, completion: { [weak self] in
                
                
                                guard let self = self else {
                                    return
                }
                    self.delegate?.didReceiveRefresh(isRefresh: true, successDict: self.successDict!)
                
                
                })
            }
            
        
        case nullStringToEmpty(string: urlBase):
            
            self.loader.isHidden = true
                       self.productDetails = dataDict as? ProductModel
                       
                       
                       for i in stride(from: 10, through: self.productDetails?.pending_invest_per ?? 0, by: 10) {
                           
                           print(">>>>>self.productDetails?.pending_invest_per",i)
                           
                           let values = calculatePercentage(value: self.productDetails?.total_product_value ?? 0.0, percentageVal: Double(i))
                                 print(">>>>>percent",i)
                           print(">>>values",values)
                           let earning = calculatePercentage(value: Double(self.productDetails?.final_profit_invest_per ?? 0) , percentageVal:  self.productDetails?.total_product_value ?? 0.0)
                           print(">>>earning",earning)
                           let earningFinal = calculatePercentage(value: Double (i), percentageVal: earning)
                             print(">>>earningFinal",earningFinal)
                           self.invests.append(Invest.init(percent: i, value: values.round(to: 2), earn: earningFinal.round(to: 2) ))
                           
                       }
                   
                   
                       
                   if self.invests.count > 0 {
                   
                       for indexItem in self.invests {
                           
                           let percentage = String(indexItem.percent ?? 0)
                           let values = String(indexItem.value ?? 0.0)
                           amountString.append(nullStringToEmpty(string: percentage) + "% - $" + nullStringToEmpty(string: values))
                           amountIndex.append(indexItem.percent ?? 0)
                       }
                   }
                  
                      
                   
                   
                   amountTxtFld.optionArray = amountString
                   amountTxtFld.optionIds = amountIndex
                   
                   amountTxtFld.text = nullStringToEmpty(string: amountString.first)
                   earningLbl.text = "Earn: " + String(self.invests.first?.earn ?? 0.0)
                   self.earningPercent = String(self.invests.first?.percent ?? 0)
            
            print(">>>>> self.invests", self.invests.first?.percent)
            print(">>>> self.earningPercent ",self.earningPercent)
            

            default:
                break

        }
         
    
    }
    
    func showError(error: CustomError) {
        
        self.loader.isHidden = true
        ToastManager.show(title:  nullStringToEmpty(string: error.localizedDescription.trimString()), state: .error)
        self.dismiss(animated: true, completion: nil)
    }
    
    func getInvestBuyTransaction(type: String, ids: Int, amount: String, paymentMode: String) {
        let val = self.cryptoEntity.filter({($0.name?.contains(nullStringToEmpty(string: self.paymentModeTxtFld.text)))!})
        self.paymentMode = nullStringToEmpty(string: val.last?.value)
        
        
        var params = [String: AnyObject]()
        params[TransactionParam.keys.product_id] = ids as AnyObject
        params[TransactionParam.keys.type] = nullStringToEmpty(string: type) as AnyObject
        params[TransactionParam.keys.amount] = nullStringToEmpty(string: amount) as AnyObject
        params[TransactionParam.keys.payment_mode] = nullStringToEmpty(string:  self.paymentMode) as AnyObject
        self.loader.isHidden = true
        print(">>> params",params)
        self.presenter?.HITAPI(api: Base.investBuyTransaction.rawValue, params: params , methodType: .POST, modelClass: SuccessDict.self, token: true)
        
    }
    
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//            
//           let touch = touches.first
//           
//           if touch?.view != self.childView {
//               
//               dismiss(animated: true, completion: nil)
//               
//           }
//           
//       }
    
}


public func calculatePercentage(value:Double,percentageVal:Double)-> Double {
    let val = value * percentageVal
    return val / 100.0
}



