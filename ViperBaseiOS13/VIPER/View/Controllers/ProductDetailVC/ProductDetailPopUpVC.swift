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
    var productModel: ProductModel?
    var selectedPaymentMethod: Payment_method?
    var currentValInvPer : Int = 5 {
        didSet{
            switch isForBuyAndToken {
            case .BuyProduct:
                self.buyNowBtnTitle = "Buy Now"
                self.qtyValueLbl.text = "\(01)"
                let percentageValue = (Double(currentValInvPer) * (productModel?.total_product_value ?? 0.0)) / 100
                self.totalProductAmt.text = "$ " + "\(productModel?.total_product_value ?? 0.0)"
                self.totalPayableAmt.text =  "$ " + "\(percentageValue + 50)"
                self.incrView.isHidden = true
                self.decrView.isHidden = true
            case .InvestProduct:
                 self.buyNowBtnTitle = "Invest"
                self.incrView.isHidden = false
                self.decrView.isHidden = false
                self.qtyValueLbl.text = "\(currentValInvPer)" + "%"
                let percentageValue = (Double(currentValInvPer) * (productModel?.total_product_value ?? 0.0)) / 100
                self.totalProductAmt.text = "$ " + "\(percentageValue)"
                self.payableAmountValueLbl.text = "$ " + "\(50)"
                self.totalPayableAmt.text =  "$ " + "\(percentageValue + 50)"
            default:
                self.buyNowBtnTitle = "Buy Now"
                self.incrView.isHidden = false
                self.decrView.isHidden = false
                self.qtyTxtField.text = "\(currentValInvPer)"
                let percentageValue = (Double(currentValInvPer) * (productModel?.tokenrequest?.asset?.asset_value ?? 0.0))
                self.totalProductAmt.text = "$ " + "\(percentageValue)"
                self.payableAmountValueLbl.text = "$ " + "\(50)"
                self.totalPayableAmt.text =  "$ " + "\(percentageValue + 50)"
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
        if self.currentValInvPer !=  100{
        self.currentValInvPer +=  5
    }
    }
    
}

// MARK: - Extension For Functions
//===========================
extension ProductDetailPopUpVC {
    
    private func initialSetup() {
        self.dataSetUp()
        self.getPaymentMethodListing()
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 5)
        paymentMethodTxtField.delegate = self
        paymentMethodTxtField.setButtonToRightView(btn: button, selectedImage: #imageLiteral(resourceName: "dropDownButton"), normalImage: #imageLiteral(resourceName: "dropDownButton"), size: CGSize(width: 20, height: 20))
        self.cancelBtn.backgroundColor = .white
        self.cancelBtn.setTitleColor(#colorLiteral(red: 1, green: 0.1215686275, blue: 0.1764705882, alpha: 1), for: .normal)
        self.cancelBtn.borderColor = #colorLiteral(red: 1, green: 0.1215686275, blue: 0.1764705882, alpha: 1)
        self.cancelBtn.borderLineWidth = 1.0
        self.qtyTxtField.delegate = self
        self.qtyTxtField.keyboardType = .numberPad
    }
    
    private func dataSetUp(){
        switch isForBuyAndToken {
        case .BuyProduct:
            self.investPerView.isHidden = false
            self.quantityView.isHidden = true
            self.tokenPriceLbl.text = "Product Price"
            self.totalProductPriceTitleLbl.text = "Total Product Amount"
            self.tokenQtyLbl.text = "Product Quantity"
            self.tokenPriceValueLbl.text = "$ " +  "\(productModel?.total_product_value ?? 0.0)"
            self.currentValInvPer = 1
        case .InvestProduct:
            self.currentValInvPer = 5
            self.investPerView.isHidden = false
            self.quantityView.isHidden = true
            self.tokenPriceLbl.text = "Product Price"
            self.totalProductPriceTitleLbl.text = "Total Product Amount"
            self.tokenQtyLbl.text = "Product\nInvestment"
            self.tokenPriceValueLbl.text = "$ " +  "\(productModel?.total_product_value ?? 0.0)"
        default:
            self.currentValInvPer = 1
            self.investPerView.isHidden = true
            self.quantityView.isHidden = false
            self.tokenPriceLbl.text =  "Token Price"
            self.totalProductPriceTitleLbl.text = "Total Token Amount"
            self.tokenQtyLbl.text = "Token Quantity"
            self.tokenPriceValueLbl.text = "$ " + "\(productModel?.tokenrequest?.asset?.asset_value ?? 0.0)"
        }
        let imgEntity =  productModel?.product_image ?? ""
        let url = URL(string: baseUrl + "/" +  nullStringToEmpty(string: imgEntity))
        self.tokenImgView?.sd_setImage(with: url , placeholderImage: nil)
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
            vc.usingForSort = .paymentMethods
            vc.sortTypePaymentListing = self.productModel?.payment_method_type ?? []
            vc.selectedPaymentMethod = self.selectedPaymentMethod ?? Payment_method()
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
                self.paymentMethodTxtField.text = self.selectedPaymentMethod?.key ?? ""
            }
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
        self.paymentMethodTxtField.text = self.selectedPaymentMethod?.key ?? ""
    }
}

