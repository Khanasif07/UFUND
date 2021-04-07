//
//  SubmitAssetsProductsVC.swift
//  ViperBaseiOS13
//
//  Created by Admin on 30/03/21.
//  Copyright © 2021 CSS. All rights reserved.
//

import UIKit
import ObjectMapper

class SubmitAssetsProductsVC: UIViewController {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var sendRequestBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var bottomBtnView: UIView!
    @IBOutlet weak var btnStackView: UIView!
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var addProductBtn: UIButton!
    @IBOutlet weak var addAssetBtn: UIButton!
    // MARK: - Variables
    //===========================
    var tokenVC : AddAssetsVC!
    var productVC : AddProductsVC!
    lazy var loader  : UIView = {
        return createActivityIndicator(self.view)
    }()
    var isPruductSelected = false {
        didSet {
            if isPruductSelected {
                self.addProductBtn.setTitleColor(.white, for: .normal)
                self.addAssetBtn.setTitleColor(.darkGray, for: .normal)
                self.addProductBtn.backgroundColor = #colorLiteral(red: 1, green: 0.1215686275, blue: 0.1764705882, alpha: 1)
                self.addAssetBtn.setBackGroundColor(color: .clear)
            } else {
                self.addProductBtn.setTitleColor(.darkGray, for: .normal)
                self.addAssetBtn.setTitleColor(.white, for: .normal)
                self.addProductBtn.setBackGroundColor(color: .clear)
                self.addAssetBtn.backgroundColor = #colorLiteral(red: 1, green: 0.1215686275, blue: 0.1764705882, alpha: 1)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        bottomBtnView.addShadowToTopOrBottom(location: .top,color: UIColor.black16)
        btnStackView.setCornerRadius(cornerR: btnStackView.frame.height / 2.0)
        addAssetBtn.setCornerRadius(cornerR: addAssetBtn.frame.height / 2.0)
        addProductBtn.setCornerRadius(cornerR: addProductBtn.frame.height / 2.0)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - IBActions
    //===========================
    @IBAction func addProductBtnAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.mainScrollView.setContentOffset(CGPoint(x: UIScreen.main.bounds.width,y: 0), animated: true)
        self.view.layoutIfNeeded()
    }
    
    @IBAction func cancelBtnAction(_ sender: UIButton) {
        self.popOrDismiss(animation: true)
    }
    
    @IBAction func sendRequestBtnAction(_ sender: UIButton) {
        if isPruductSelected {
            if self.productVC.isCheckParamsData(){
                self.hitSendRequestApi()
            }
        } else {
            if self.tokenVC.isCheckParamsData(){
                self.hitSendRequestApi()
            }
        }
    }
    
    @IBAction func addBtnAction(_ sender: Any) {
        self.view.endEditing(true)
        self.mainScrollView.setContentOffset(CGPoint.zero, animated: true)
        self.view.layoutIfNeeded()
    }
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.popOrDismiss(animation: true)
    }
    
}

// MARK: - Extension For Functions
//===========================
extension SubmitAssetsProductsVC {
    
    private func initialSetup(){
        self.setUpFont()
        self.configureScrollView()
        self.instantiateViewController()
        self.getCategoryList()
//        self.getAssetTokenTypeList()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func configureScrollView(){
        self.isPruductSelected = false
        self.mainScrollView.contentSize = CGSize(width: 2 * UIScreen.main.bounds.width, height: 1)
        self.mainScrollView.delegate = self
        self.mainScrollView.isPagingEnabled = true
    }
    
    private func instantiateViewController() {
        //instantiate the CategoriesTokenVC
        self.tokenVC = AddAssetsVC.instantiate(fromAppStoryboard: .Products)
        self.tokenVC.view.frame.origin = CGPoint.zero
        self.mainScrollView.frame = self.tokenVC.view.frame
        self.mainScrollView.addSubview(self.tokenVC.view)
        self.addChild(self.tokenVC)
        
        //instantiate the CategoriesProductsVC
        self.productVC = AddProductsVC.instantiate(fromAppStoryboard: .Products)
        self.productVC.view.frame.origin = CGPoint(x: UIScreen.main.bounds.width, y: 0)
        self.mainScrollView.frame = self.productVC.view.frame
        self.mainScrollView.addSubview(self.productVC.view)
        self.addChild(self.productVC)
    }
    
    private func setUpFont(){
        DispatchQueue.main.async {
            [self.cancelBtn,self.sendRequestBtn].forEach { (btn) in
                btn?.layer.masksToBounds = true
                btn?.layer.borderWidth = 1.0
                btn?.layer.borderColor = #colorLiteral(red: 1, green: 0.1215686275, blue: 0.1764705882, alpha: 1)
                btn?.layer.cornerRadius = 2.0
            }
        }
        self.sendRequestBtn.setTitleColor(.white, for: .normal)
        self.sendRequestBtn.backgroundColor = #colorLiteral(red: 1, green: 0.1215686275, blue: 0.1764705882, alpha: 1)
        self.btnStackView.backgroundColor = #colorLiteral(red: 0.937254902, green: 0.9176470588, blue: 0.9176470588, alpha: 0.7010701185)
        self.btnStackView.borderLineWidth = 1.5
        self.btnStackView.borderColor = #colorLiteral(red: 0.6196078431, green: 0.6196078431, blue: 0.6196078431, alpha: 0.1007089439)
    }
    
    private func getCategoryList(){
        self.loader.isHidden = false
        self.presenter?.HITAPI(api: Base.categories.rawValue, params: [ProductCreate.keys.category_type: 1], methodType: .GET, modelClass: CategoriesModel.self, token: true)
        self.presenter?.HITAPI(api: Base.categories.rawValue, params: [ProductCreate.keys.category_type: 2], methodType: .GET, modelClass: CategoriesModel.self, token: true)
    }
    
    private func getAssetTokenTypeList() {
        self.presenter?.HITAPI(api: Base.asset_token_types.rawValue, params: [ProductCreate.keys.type: 1], methodType: .GET, modelClass: AssetTokenTypeEntity.self, token: true)
        self.presenter?.HITAPI(api: Base.asset_token_types.rawValue, params: [ProductCreate.keys.type: 2], methodType: .GET, modelClass: AssetTokenTypeEntity.self, token: true)
    }
    
    public func hitSendRequestApi(){
        self.loader.isHidden = false
        if isPruductSelected {
            let params = self.productVC.addProductModel.getDictForAddProduct()
            let documentData : [String:(Data,String,String)] =   [ProductCreate.keys.regulatory_investigator:(self.productVC.imgDataArray[0].1,"regulatory.pdf",FileType.pdf.rawValue),
                                                                  ProductCreate.keys.document :(self.productVC.imgDataArray[1].1,"document.pdf",FileType.pdf.rawValue),
                                                                  ProductCreate.keys.product_image :(self.productVC.imgDataArray[2].1,"Product.jpg",FileType.image.rawValue),
                                                                  
            ]
            self.presenter?.UploadData(api: Base.campaigner_create_product.rawValue, params: params, imageData: documentData , methodType: .POST, modelClass: SuccessDict.self, token: true)
        } else {
            let params = self.tokenVC.addAssetModel.getDictForAddAsset()
            let documentData: [String:(Data,String,String)] =   [ProductCreate.keys.regulatory_investigator:(tokenVC.imgDataArray[0].1,"regulatory.pdf",FileType.pdf.rawValue),
                                                                 ProductCreate.keys.document :(tokenVC.imgDataArray[1].1,"document.pdf",FileType.pdf.rawValue),
                                                                 ProductCreate.keys.asset_image :(tokenVC.imgDataArray[2].1,"Asset.jpg",FileType.image.rawValue),
                                                                 ProductCreate.keys.token_image :(tokenVC.imgDataArray[3].1,"Token.jpg",FileType.image.rawValue)
            ]
            
            self.presenter?.UploadData(api: Base.campaigner_create_asset.rawValue, params: params, imageData: documentData , methodType: .POST, modelClass: SuccessDict.self, token: true)
        }
        self.loader.isHidden = false
        
    }
}

//    MARK:- ScrollView delegate
//    ==========================
extension SubmitAssetsProductsVC: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.mainScrollView.contentOffset.x <= self.mainScrollView.frame.width / 2 {
            isPruductSelected = false
        }
        else {
            isPruductSelected = true
        }
    }
}

//    MARK:- PresenterOutputProtocol
//    ==========================
extension SubmitAssetsProductsVC : PresenterOutputProtocol {
    func showSuccess(api: String, dataArray: [Mappable]?, dataDict: Mappable?, modelClass: Any) {}
    func showSuccessWithParams(statusCode: Int,params: [String:Any],api: String, dataArray: [Mappable]?, dataDict: Mappable?,modelClass: Any){
        self.loader.isHidden = true
        switch api {
        case Base.campaigner_create_product.rawValue:
            self.popOrDismiss(animation: true)
        case Base.campaigner_create_asset.rawValue:
            self.popOrDismiss(animation: true)
        case Base.categories.rawValue:
            if params[ProductCreate.keys.category_type] as? Int == 1 {
                if let addionalModel = dataDict as? CategoriesModel{
                    self.productVC.categoryListing = addionalModel.data ?? []
                }
            } else if params[ProductCreate.keys.category_type] as? Int == 2  {
                if let addionalModel = dataDict as? CategoriesModel{
                    self.tokenVC.categoryListing = addionalModel.data ?? []
                }
                getAssetTokenTypeList()
            }else{}
        case Base.asset_token_types.rawValue:
            if params[ProductCreate.keys.type] as? Int == 1 {
                if let addionalModel = dataDict as? AssetTokenTypeEntity {
                    self.tokenVC.assetTypeListing = addionalModel.data ?? []
                }
            } else if params[ProductCreate.keys.type] as? Int == 2{
                if let addionalModel = dataDict as? AssetTokenTypeEntity{
                    self.tokenVC.tokenTypeListing = addionalModel.data ?? []
                }
            }else{}
        default:
            print("Do Nothing")
        }
        
    }
    
    func showError(error: CustomError) {
        self.loader.isHidden = true
        ToastManager.show(title:  nullStringToEmpty(string: error.localizedDescription.trimString()), state: .success)
    }
    
}