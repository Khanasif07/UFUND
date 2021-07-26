//
//  ProductDetailPopUpVC.swift
//  ViperBaseiOS13
//
//  Created by Admin on 25/02/21.
//  Copyright © 2021 CSS. All rights reserved.
//

import UIKit
import ObjectMapper

enum IsForBuyAndToken {
    case InvestToken
    case BuyProduct
    case InvestProduct
}

class ProductDetailPopUpVC: UIViewController {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var selectAmtMethodTitlelbl: UILabel!
    @IBOutlet weak var totalProductAmtTitlelbl: UILabel!
    @IBOutlet weak var adminCommTitleLbl: UILabel!
    @IBOutlet weak var totalPayAmtTitleLbl: UILabel!
    @IBOutlet weak var qtyTxtField: UITextField!
    @IBOutlet weak var investPerView: UIView!
    @IBOutlet weak var quantityView: UIView!
    @IBOutlet weak var incrView: UIView!
    @IBOutlet weak var decrView: UIView!
    @IBOutlet weak var totalProductPriceTitleLbl: UILabel!
    @IBOutlet weak var totalProductAmt: UILabel!
    @IBOutlet weak var totalPayableAmt: UILabel!
    @IBOutlet weak var tokenImgView: UIImageView!
    @IBOutlet weak var tokenPriceLbl: UILabel!
    @IBOutlet weak var tokenPriceValueLbl: UILabel!
    @IBOutlet weak var paymentMethodTxtField: UITextField!
    @IBOutlet weak var payableAmountValueLbl: UILabel!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var dataContainerView: UIView!
    @IBOutlet weak var buyNowBtn: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var coinLbl: UILabel!
    @IBOutlet weak var qtyValueLbl: UILabel!
    @IBOutlet weak var tokenQtyLbl: UILabel!
    
    // MARK: - Variables
    //===========================
    var isForBuyAndToken: IsForBuyAndToken = .BuyProduct
    private lazy var loader  : UIView = {
              return createActivityIndicator(self.view)
          }()
    var totalPayableAmtValue : Double = 0.0
    var productModel: ProductModel?
    var walletBalance: WalletBalance?
    var selectedPaymentMethod: Payment_method?
    var selectedPaymentMethodAssets: String?
    var currentValInvPer : Int = 5 {
        didSet{
            switch isForBuyAndToken {
            case .BuyProduct:
                self.buyNowBtnTitle = "Buy Now"
                self.qtyValueLbl.text = "\(01)"
                self.adminCommTitleLbl.text = "Admin Commision" + " (\(productModel?.commission_per ?? 0)) " + "%"
                let percentageValue = (Double(currentValInvPer) * (productModel?.total_product_value ?? 0.0))
                self.totalProductAmt.text = "$ " + "\(productModel?.total_product_value ?? 0.0)"
                let adminCommissionPer = productModel?.commission_per ?? 0
                let adminCommission = (Double(productModel?.total_product_value ?? 0.0) * Double(adminCommissionPer)) / 100
                self.payableAmountValueLbl.text = "$ " + "\(adminCommission)"
                self.totalPayableAmtValue = percentageValue + adminCommission
                self.totalPayableAmt.text =  "$ " + "\(totalPayableAmtValue)"
                self.incrView.isHidden = true
                self.decrView.isHidden = true
            case .InvestProduct:
                 self.buyNowBtnTitle = "Invest"
                 self.incrView.isHidden = false
                 self.decrView.isHidden = false
                 self.adminCommTitleLbl.text = "Admin Commision" + " (\(productModel?.commission_per ?? 0)) " + "%"
                 self.qtyValueLbl.text = "\(currentValInvPer)" + "%"
                 let percentageValue = (Double(currentValInvPer) * (productModel?.total_product_value ?? 0.0)) / 100
                 self.totalProductAmt.text = "$ " + "\(percentageValue)"
                 let adminCommissionPer = productModel?.commission_per ?? 0
                 let adminCommission = (Double(percentageValue) * Double(adminCommissionPer)) / 100
                 self.payableAmountValueLbl.text = "$ " + "\(adminCommission)"
                 self.totalPayableAmtValue = percentageValue + adminCommission
                 self.totalPayableAmt.text =  "$ " + "\(totalPayableAmtValue)"
            default:
                self.buyNowBtnTitle = "Buy Now"
                self.incrView.isHidden = false
                self.decrView.isHidden = false
                self.tokenPriceValueLbl.text = "$ " + "\(productModel?.tokenvalue ?? 0.0)"
                self.adminCommTitleLbl.text = "Admin Commision" + " (\(productModel?.commission_per ?? 0)) " + "%"
                self.qtyTxtField.text = "\(currentValInvPer)"
                let percentageValue = (Double(currentValInvPer) * (productModel?.tokenvalue ?? 0.0))
                self.totalProductAmt.text = "$ " + "\(percentageValue)"
                let adminCommissionPer = productModel?.commission_per ?? 0
                let adminCommission = ((percentageValue) * Double(adminCommissionPer)) / 100
                self.payableAmountValueLbl.text = "$ " + "\(adminCommission)"
                let totalPayableAmt = adminCommission + percentageValue
                self.totalPayableAmt.text =  "$ " + "\(totalPayableAmt)"
                self.totalPayableAmtValue = totalPayableAmt
            }
        }
    }
    var buyNowBtnTitle: String = "Buy Now"
    var button = UIButton()
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.buyNowBtn.setTitle(buyNowBtnTitle, for: .normal)
        self.buyNowBtn.setCornerRadius(cornerR: self.buyNowBtn.frame.height / 2)
        self.cancelBtn.setCornerRadius(cornerR: self.cancelBtn.frame.height / 2)
        self.dataContainerView.dropShadow(cornerRadius: 10, color: UIColor.black16, offset: CGSize(width: 0.5, height: 0.5), opacity: 1, shadowRadius: 5)
    }
    
    // MARK: - IBActions
    //===========================
    @IBAction func buyNowAction(_ sender: Any) {
        self.hitBuyInvestTransactionAPI()
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.popOrDismiss(animation: true)
    }
    
    @IBAction func qtyMinusAction(_ sender: UIButton) {
        if self.currentValInvPer !=  1{
            self.currentValInvPer -=  1
        }
    }
    
    @IBAction func qtyPlusAction(_ sender: UIButton) {
        let totalRemaining = self.productModel?.tokenrequest?.avilable_token ?? 0
        if self.currentValInvPer !=  totalRemaining{
            self.currentValInvPer +=  1
        }
    }
    
    @IBAction func perMinusAction(_ sender: UIButton) {
        if self.currentValInvPer !=  5{
        self.currentValInvPer -=  5
        }
    }
    
    @IBAction func perPlusAction(_ sender: Any) {
        if self.currentValInvPer !=  95{
        self.currentValInvPer +=  5
    }
    }
    
}

// MARK: - Extension For Functions
//===========================
extension ProductDetailPopUpVC {
    
    private func initialSetup() {
        self.dataSetUp()
        self.setFont()
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 5)
        paymentMethodTxtField.delegate = self
        paymentMethodTxtField.text = ""
        paymentMethodTxtField.setButtonToRightView(btn: button, selectedImage: #imageLiteral(resourceName: "dropDownButton"), normalImage: #imageLiteral(resourceName: "dropDownButton"), size: CGSize(width: 20, height: 20))
        self.cancelBtn.backgroundColor = .white
        self.cancelBtn.setTitleColor(#colorLiteral(red: 1, green: 0.1215686275, blue: 0.1764705882, alpha: 1), for: .normal)
        self.cancelBtn.borderColor = #colorLiteral(red: 1, green: 0.1215686275, blue: 0.1764705882, alpha: 1)
        self.cancelBtn.borderLineWidth = 1.0
        self.qtyTxtField.delegate = self
        self.qtyTxtField.keyboardType = .numberPad
    }
    
    private func hitWalletAPI(){
        self.loader.isHidden = false
        self.presenter?.HITAPI(api: Base.wallet.rawValue, params: nil, methodType: .GET, modelClass: WalletEntity.self, token: true)
    }
    
    private func hitBuyInvestTransactionAPI(){
        self.loader.isHidden = false
        var params  = [String : Any]()
        if isForBuyAndToken == .InvestToken {
            params = [Constants.string.amount.localize(): "\(self.totalPayableAmtValue)",Constants.string.payment_mode.localize(): self.selectedPaymentMethodAssets ?? "",ProductCreate.keys.product_id: self.productModel?.id ?? 0] as [String : Any]
        }else {
            params = [Constants.string.amount.localize(): "\(self.totalPayableAmtValue)",Constants.string.payment_mode.localize(): self.selectedPaymentMethod?.value ?? "",ProductCreate.keys.product_id: self.productModel?.id ?? 0] as [String : Any]
        }
        switch isForBuyAndToken{
        case .BuyProduct:
             params[ProductCreate.keys.type]  = "BUY"
        case .InvestToken:
             params[ProductCreate.keys.type]  = "BUY"
        case .InvestProduct:
            params[ProductCreate.keys.type]  = "INVEST"
        }
        self.presenter?.HITAPI(api: Base.invest_buy_transaction.rawValue, params: params, methodType: .POST, modelClass: WalletEntity.self, token: true)
    }
    
    
    private func setFont(){
        self.titleLbl.font = isDeviceIPad ? .setCustomFont(name: .medium, size: .x20) : .setCustomFont(name: .medium, size: .x16)
        self.coinLbl.font = isDeviceIPad ? .setCustomFont(name: .medium, size: .x16) : .setCustomFont(name: .medium, size: .x12)
        self.tokenPriceLbl.font = isDeviceIPad ? .setCustomFont(name: .regular, size: .x16) : .setCustomFont(name: .regular, size: .x12)
        self.tokenPriceValueLbl.font = isDeviceIPad ? .setCustomFont(name: .semiBold, size: .x20) : .setCustomFont(name: .semiBold, size: .x16)
        self.tokenQtyLbl.font = isDeviceIPad ? .setCustomFont(name: .regular, size: .x18) : .setCustomFont(name: .regular, size: .x14)
        self.qtyTxtField.font = isDeviceIPad ? .setCustomFont(name: .semiBold, size: .x20) : .setCustomFont(name: .semiBold, size: .x16)
        self.totalPayableAmt.font = isDeviceIPad ? .setCustomFont(name: .semiBold, size: .x20) : .setCustomFont(name: .semiBold, size: .x16)
        self.totalProductAmt.font = isDeviceIPad ? .setCustomFont(name: .semiBold, size: .x20) : .setCustomFont(name: .semiBold, size: .x16)
        self.payableAmountValueLbl.font = isDeviceIPad ? .setCustomFont(name: .semiBold, size: .x20) : .setCustomFont(name: .semiBold, size: .x16)
        self.cancelBtn.titleLabel?.font = isDeviceIPad ? .setCustomFont(name: .medium, size: .x18) : .setCustomFont(name: .medium, size: .x14)
        self.buyNowBtn.titleLabel?.font = isDeviceIPad ? .setCustomFont(name: .semiBold, size: .x18) : .setCustomFont(name: .semiBold, size: .x14)
        [selectAmtMethodTitlelbl,totalProductAmtTitlelbl,adminCommTitleLbl,totalPayAmtTitleLbl].forEach { (lbl) in
            lbl?.font = isDeviceIPad ? .setCustomFont(name: .regular, size: .x16) : .setCustomFont(name: .regular, size: .x12)
        }
    }
    
    private func dataSetUp(){
        switch isForBuyAndToken {
        case .BuyProduct:
            self.investPerView.isHidden = false
            self.quantityView.isHidden = true
            self.tokenPriceLbl.text = "Product Price"
            self.titleLbl.text = self.productModel?.product_title ?? ""
            self.totalProductPriceTitleLbl.text = "Total Product Amount"
            self.tokenQtyLbl.text = "Product Quantity"
            self.tokenPriceValueLbl.text = "$ " +  "\(productModel?.total_product_value ?? 0.0)"
            self.currentValInvPer = 1
            let imgEntity =  productModel?.product_image ?? ""
            let url = URL(string: nullStringToEmpty(string: imgEntity))
            self.tokenImgView?.sd_setImage(with: url , placeholderImage: nil)
        case .InvestProduct:
            self.currentValInvPer = 5
            self.investPerView.isHidden = false
            self.quantityView.isHidden = true
            self.titleLbl.text = self.productModel?.product_title ?? ""
            self.tokenPriceLbl.text = "Product Price"
            self.totalProductPriceTitleLbl.text = "Total Product Amount"
            self.tokenQtyLbl.text = "Product\nInvestment"
            self.tokenPriceValueLbl.text = "$ " +  "\(productModel?.total_product_value ?? 0.0)"
            let imgEntity =  productModel?.product_image ?? ""
            let url = URL(string: nullStringToEmpty(string: imgEntity))
            self.tokenImgView?.sd_setImage(with: url , placeholderImage: nil)
        default:
            self.currentValInvPer = 1
            self.investPerView.isHidden = true
            self.quantityView.isHidden = false
            self.titleLbl.text = self.productModel?.asset?.asset_title ?? ""
            self.tokenPriceLbl.text =  "Token Price"
            self.totalProductPriceTitleLbl.text = "Total Token Amount"
            self.tokenQtyLbl.text = "Token Quantity"
            self.tokenPriceValueLbl.text = "$ " + "\(productModel?.tokenvalue ?? 0.0)"
            let imgEntity =  productModel?.token_image ?? ""
            let url = URL(string:  nullStringToEmpty(string: imgEntity))
            self.tokenImgView?.sd_setImage(with: url , placeholderImage: nil)
        }
    }
    
    private func getPaymentMethodListing(){
        self.loader.isHidden = false
        self.presenter?.HITAPI(api: Base.paymentMethods.rawValue, params: [:], methodType: .GET, modelClass: Payment_method_Entity.self, token: true)
    }
}

// MARK: - Extension For Functions
//===========================
extension ProductDetailPopUpVC : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if  textField == paymentMethodTxtField {
            self.view.endEditing(true)
            guard let vc = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.ProductSortVC) as? ProductSortVC else { return }
            vc.delegate = self
           if isForBuyAndToken == .InvestToken {
                vc.usingForSort = .filter
                vc.sortArray = [(Constants.string.btc,false),(Constants.string.eth,false),(Constants.string.walletCaps,false)]
                vc.sortTypeApplied = self.selectedPaymentMethodAssets ?? ""
            }else {
                vc.usingForSort = .paymentMethods
                vc.sortTypePaymentListing = self.productModel?.payment_method_type ?? []
                vc.selectedPaymentMethod = self.selectedPaymentMethod ?? Payment_method()
            }
            self.present(vc, animated: true, completion: nil)
        } else if textField == qtyTxtField {
            
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if   textField == qtyTxtField {
            let totalRemaining = self.productModel?.tokenrequest?.avilable_token ?? 0
            let newText = (textField.text! as NSString).replacingCharacters(in: range, with: string) as String
            if let num = Int(newText), num >= 0 && num <= totalRemaining {
                return true
            } else {
                return false
            }
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case paymentMethodTxtField:
            view.endEditingForce()
        case qtyTxtField:
            self.currentValInvPer = Int(textField.text ?? "0") ?? 0
        default:
            view.endEditingForce()
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case paymentMethodTxtField:
            view.endEditingForce()
            return true
        case qtyTxtField:
            self.currentValInvPer = Int(textField.text ?? "0") ?? 0
            return true
        default:
            view.endEditingForce()
             return true
        }
    }
}

// MARK: - Extension For Functions
//===========================
extension ProductDetailPopUpVC : PresenterOutputProtocol {
    func showSuccess(api: String, dataArray: [Mappable]?, dataDict: Mappable?, modelClass: Any) {
        self.loader.isHidden = true
        switch api {
        case Base.paymentMethods.rawValue:
            let productModelEntity = dataDict as? Payment_method_Entity
            if let payment_methods = productModelEntity?.data {
                self.productModel?.payment_method_type = payment_methods
                self.selectedPaymentMethod =
                    self.productModel?.payment_method_type?.first ?? Payment_method()
                self.paymentMethodTxtField.text = self.selectedPaymentMethod?.value ?? ""
            }
        case Base.wallet.rawValue:
            let walletData = dataDict as? WalletEntity
            if let data = walletData?.balance {
                self.walletBalance = data
                switch selectedPaymentMethod?.value {
                case "ETH":
                    let ethBalance =  self.walletBalance?.eth ?? 0.0
                    if ethBalance >= self.totalPayableAmtValue{
                         self.hitBuyInvestTransactionAPI()
                    } else {
                         let vc = MyWalletDepositVC.instantiate(fromAppStoryboard: .Wallet)
                         self.present(vc, animated: true, completion: nil)
                    }
                case "BTC":
                    let btcBalance =  self.walletBalance?.btc ?? 0.0
                    if btcBalance >= self.totalPayableAmtValue{
                        self.hitBuyInvestTransactionAPI()
                    } else {
                         let vc = MyWalletDepositVC.instantiate(fromAppStoryboard: .Wallet)
                        self.present(vc, animated: true, completion: nil)
                    }
                case "WALLET":
                    let paypalBalance =  self.walletBalance?.wallet ?? 0.0
                    if paypalBalance >= self.totalPayableAmtValue{
                        self.hitBuyInvestTransactionAPI()
                    } else {
                         let vc = MyWalletDepositVC.instantiate(fromAppStoryboard: .Wallet)
                         self.present(vc, animated: true, completion: nil)
                    }
                default:
                    print("Do Nothing")
                }
                print(data)
            }
        case Base.invest_buy_transaction.rawValue:
            self.popOrDismiss(animation: true)
            
        default:
            self.loader.isHidden = true
        }
    }
    
    func showError(error: CustomError) {
        self.loader.isHidden = true
    }
}
 

// MARK: - Extension For Functions
//===========================
extension ProductDetailPopUpVC : ProductSortVCDelegate {
    func sortingAppliedInPaymentType(sortType: Payment_method) {
        self.selectedPaymentMethod = sortType
        self.paymentMethodTxtField.text = self.selectedPaymentMethod?.value ?? ""
    }
    
    func sortingApplied(sortType: String) {
        self.selectedPaymentMethodAssets = sortType
        self.paymentMethodTxtField.text = self.selectedPaymentMethodAssets ?? ""
    }
}

