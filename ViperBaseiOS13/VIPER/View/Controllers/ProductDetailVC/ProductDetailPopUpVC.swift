//
//  ProductDetailPopUpVC.swift
//  ViperBaseiOS13
//
//  Created by Admin on 25/02/21.
//  Copyright © 2021 CSS. All rights reserved.
//

import UIKit
import ObjectMapper

class ProductDetailPopUpVC: UIViewController {
    
    // MARK: - IBOutlets
    //===========================
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
    private lazy var loader  : UIView = {
              return createActivityIndicator(self.view)
          }()
    var productModel: ProductModel?
    var selectedPaymentMethod: Payment_method?
    var currentValInvPer : Int = 20 {
        didSet{
            self.qtyValueLbl.text = "\(currentValInvPer)" + "%"
            let percentageValue = (Double(currentValInvPer) * (productModel?.total_product_value ?? 0.0)) / 100
            self.payableAmountValueLbl.text = "$ " + "\(percentageValue)"
        }
    }
    var buyNowBtnTitle: String = "Buy Now"
    var button = UIButton()
    var isForBuyproduct = false {
        didSet{
            if isForBuyproduct{
                self.buyNowBtnTitle = "Buy Now"
            }else {
                self.buyNowBtnTitle = "Invest"
            }
        }
    }
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
        if self.currentValInvPer !=  0{
        self.currentValInvPer -=  1
        }
    }
    
    @IBAction func qtyPlusAction(_ sender: Any) {
        if self.currentValInvPer !=  100{
        self.currentValInvPer +=  1
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
        self.currentValInvPer = 20
    }
    
    private func dataSetUp(){
        self.tokenQtyLbl.text = self.isForBuyproduct ? "Token Quantity" : "Investment Percentage (%)"
        let imgEntity =  productModel?.product_image ?? ""
        let url = URL(string: baseUrl + "/" +  nullStringToEmpty(string: imgEntity))
        self.tokenImgView?.sd_setImage(with: url , placeholderImage: nil)
        self.tokenPriceValueLbl.text = "$ " +  "\(productModel?.total_product_value ?? 0.0)"
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
            self.view.endEditingForce()
            self.view.endEditing(true)
            guard let vc = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.ProductSortVC) as? ProductSortVC else { return }
            vc.delegate = self
            vc.usingForSort = .paymentMethods
            vc.sortTypePaymentListing = self.productModel?.payment_method_type ?? []
            vc.selectedPaymentMethod = self.selectedPaymentMethod ?? Payment_method()
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        view.endEditingForce()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditingForce()
        return true
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

