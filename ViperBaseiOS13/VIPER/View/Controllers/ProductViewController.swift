//
//  ProductViewController.swift
//  ViperBaseiOS13
//
//  Created by Deepika on 27/11/19.
//  Copyright © 2019 CSS. All rights reserved.
//

import UIKit
import ObjectMapper

enum TokenDetailsEnum {
    
    static let tokenRequest = "tokenrequest"
    static let token = "token"
}

enum BuyOrInvest {
    
    static let buy = "BUY"
    static let invest = "INVEST"
    static let product = "Product"
    static let token = "Token"
    
}

class ProductViewController: UIViewController {
    
    var tokenId : Int?
    @IBOutlet weak var catogriesLbl: UILabel!
    @IBOutlet weak var nameOfAssetsLbl: UILabel!
    @IBOutlet weak var valueTypeLbl: UILabel!
    @IBOutlet weak var borderSilderView: UIView!
    @IBOutlet weak var inverstorsLbl: UILabel!
    @IBOutlet weak var investedLbl: UILabel!
    @IBOutlet weak var availableLbl: UILabel!
    @IBOutlet weak var endVal: UILabel!
    @IBOutlet weak var middleValLbl: UILabel!
    @IBOutlet weak var startValLbl: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var investButton: UIButton!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var titleLbl: UILabel!
    var isFromTokenRequest: Bool?
    @IBOutlet weak var totlPriceLbl: UILabel!
    @IBOutlet weak var price: UIStackView!
    @IBOutlet weak var labelProductValue: UILabel!
    var imageURLArray =  [String]()
    var testTxt = ""
    var productID = Int()
    var productDetails : TokenDetailsEntity?
    @IBOutlet weak var labelProductName: UILabel!
    @IBOutlet weak var labelBackedAsset: UILabel!
    @IBOutlet weak var labelDescriptionValue: UILabel!
    @IBOutlet weak var labelCoinSymbol: UILabel!
    @IBOutlet weak var labelInvestAmount: UILabel!
    @IBOutlet weak var labelEarnAmount: UILabel!
    var id = 0
    private lazy var loader  : UIView = {
        
        return createActivityIndicator(self.view)
        
    }()
    var successDict: SuccessDict?
    let userType = UserDefaults.standard.value(forKey: UserDefaultsKey.key.isFromInvestor) as? String
    
    
    var isFromMyProduct = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        borderSilderView.setCirclerCornerRadius()
        borderSilderView.layer.borderColor = UIColor.lightGray.cgColor
        borderSilderView.layer.borderWidth = 0.5
        
        let nibPost = UINib(nibName: XIB.Names.GridCell, bundle: nil)
        collectionView.register(nibPost, forCellWithReuseIdentifier: XIB.Names.GridCell)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
        
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView.alwaysBounceHorizontal = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView.delegate = self
        collectionView.dataSource = self
        price.addBackground(color: UIColor(hex: primaryColor))
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        investButton.setGradientBackground()
        buyButton.setGradientBackground()
        buyButton.setTitle(Constants.string.buy.localize().uppercased(), for: .normal)
        investButton.setTitle(Constants.string.invest.localize().uppercased(), for: .normal)
        descriptionLbl.text = nullStringToEmpty(string: testTxt)
       
        UIView.animate(withDuration: 1.0) {
            self.progressView.setProgress(1.0, animated: true)
        }
        
        titleLbl.text = id == 0 ? Constants.string.TokenizedAssetsDetail.localize().uppercased() : Constants.string.TokenizedAssetsDetail.localize().uppercased()
        
        descriptionLbl.textColor = UIColor(hex: lightTextColor)
        progressView.progress = 0.5
        progressView.tintColor = UIColor(hex: primaryColor)
        progressView.layer.cornerRadius = 4
        progressView.clipsToBounds = true
        progressView.layer.sublayers![1].cornerRadius = 4
        progressView.subviews[1].clipsToBounds = true
        
        endVal.textColor = UIColor(hex: darkTextColor)
        middleValLbl.textColor = UIColor(hex: darkTextColor)
        startValLbl.textColor = UIColor(hex: darkTextColor)
        investedLbl.textColor = UIColor(hex: primaryColor)
        availableLbl.textColor = UIColor(hex: primaryColor)
        inverstorsLbl.textColor = UIColor(hex: primaryColor)
        //= userType == UserType.campaigner.rawValue
        
        
         let user = userType == UserType.campaigner.rawValue ? "campaigner" : "investor"
        
        switch  nullStringToEmpty(string: user) {
        case "investor":
            
            if isFromMyProduct {
                buyButton.isHidden = true
            } else {
                buyButton.isHidden = false
            }
            
        default:
             buyButton.isHidden = true
        }
       
    }
    
    func getProductDetails(id:Int?) {
        
        if isFromTokenRequest == true {
            let url = "\(Base.tokenDetail.rawValue)/\(id ?? 0)\(Base.details.rawValue)\(TokenDetailsEnum.tokenRequest)"
            self.presenter?.HITAPI(api: url, params: nil, methodType:.GET, modelClass: TokenDetailsEntity.self, token: true)
            self.loader.isHidden = false
        } else {
            let url = "\(Base.tokenDetail.rawValue)/\(id ?? 0)\(Base.details.rawValue)\(TokenDetailsEnum.token)"
            self.presenter?.HITAPI(api: url, params: nil, methodType:.GET, modelClass: TokenDetailsEntity.self, token: true)
            self.loader.isHidden = false
        }
    }
    
    @IBAction func goBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func buyClick(_ sender: UIButton) {
        
                 let customAlertViewController = BuyTokenViewController(nibName: "BuyTokenViewController", bundle: nil)
                   customAlertViewController.type = nullStringToEmpty(string: BuyOrInvest.invest)
                   customAlertViewController.ids = tokenId ?? 0
                   customAlertViewController.delegate = self
                   customAlertViewController.tokenDetails = productDetails
                   customAlertViewController.productOrToken = nullStringToEmpty(string: BuyOrInvest.product)
                   customAlertViewController.providesPresentationContextTransitionStyle = true;
                   customAlertViewController.definesPresentationContext = true;
                   customAlertViewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                   customAlertViewController.view.backgroundColor = UIColor(white: 0, alpha: 0.25)
                   self.present(customAlertViewController, animated: false, completion: nil)
        
        
        //getInvestBuyTransaction(type: nullStringToEmpty(string: BuyOrInvest.buy), ids: productDetails?.id ?? 0)
        
    }
    
    @IBAction func investClick(_ sender: UIButton) {
       
        let customAlertViewController = TokenAssetsAmountViewController(nibName: "TokenAssetsAmountViewController", bundle: nil)
        customAlertViewController.type = nullStringToEmpty(string: BuyOrInvest.invest)
        customAlertViewController.ids = productDetails?.id ?? 0
        customAlertViewController.delegate = self
        customAlertViewController.productOrToken = nullStringToEmpty(string: BuyOrInvest.token)
        customAlertViewController.cryptoEntity = self.productDetails?.payment_method_type ?? []
        customAlertViewController.providesPresentationContextTransitionStyle = true;
        customAlertViewController.definesPresentationContext = true;
        customAlertViewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        customAlertViewController.view.backgroundColor = UIColor(white: 0, alpha: 0.25)
        self.present(customAlertViewController, animated: false, completion: nil)
        
    }
    
    func setValue(data:TokenDetailsEntity?) {
        
        self.labelProductName.text = nullStringToEmpty(string: data?.tokenname)
        self.labelProductValue.text = "\(deafaultCurrency) \(data?.tokenvalue ?? 0.0)"
        self.labelCoinSymbol.text = nullStringToEmpty(string: data?.tokensymbol)
        self.labelBackedAsset.text = nullStringToEmpty(string: data?.asset?.asset_type?.name)
        self.labelInvestAmount.text = "\(deafaultCurrency) \(data?.tokenvalue ?? 0)"
        self.labelEarnAmount.text = "0.0"
        
        self.catogriesLbl.text = nullStringToEmpty(string: data?.asset?.category?.category_name)
        nameOfAssetsLbl.text = nullStringToEmpty(string: data?.asset?.asset_title)
        valueTypeLbl.text = " \(deafaultCurrency) \(data?.asset?.asset_value?.round(to: 2) ?? 0.0) "
        
        
        self.labelDescriptionValue.text = nullStringToEmpty(string: data?.asset?.description)
        self.imageURLArray.append(nullStringToEmpty(string: data?.token_image))
        
        if data?.asset?.asset_child_image?.count ?? 0 > 0 {
            for item in data?.asset?.asset_child_image ?? [] {
                self.imageURLArray.append(nullStringToEmpty(string: item.image))
            }
        }
        
        self.collectionView.reloadData()
        
    }
    
}

//MARK: - Collection view delegate
extension ProductViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageURLArray.count  > 0 ? imageURLArray.count  : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: XIB.Names.GridCell, for: indexPath) as! GridCell
        
        cell.backgroundColor = .clear
        let imgEntity =  imageURLArray[indexPath.row]
        let url = URL.init(string: baseUrl + "/" +  nullStringToEmpty(string: imgEntity))
        cell.webImgView.sd_setImage(with: url , placeholderImage: nil)
        cell.decriptionLbl.text = ""
//        cell.readyView.isHidden = true
        cell.webImgView.cornerRadius = 8
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
}

extension ProductViewController : PresenterOutputProtocol {
    
    func getInvestBuyTransaction(type: String, ids: Int) {
        
        var params = [String: AnyObject]()
        params[TransactionParam.keys.token_id] = ids as AnyObject
        params[TransactionParam.keys.type] = nullStringToEmpty(string: type) as AnyObject
        
      
        
        self.loader.isHidden = true
        print(">>> params",params)
        
        self.presenter?.HITAPI(api: Base.investBuyTransaction.rawValue, params: params , methodType: .POST, modelClass: SuccessDict.self, token: true)
        
    }
    
    func showSuccess(api: String, dataArray: [Mappable]?, dataDict: Mappable?, modelClass: Any) {
        
        self.loader.isHidden = true
        self.productDetails = dataDict as? TokenDetailsEntity
        setValue(data: self.productDetails)
        
        if nullStringToEmpty(string: api) ==  Base.investBuyTransaction.rawValue {
            
            self.loader.isHidden = true
            self.successDict = dataDict as? SuccessDict
            
            if self.successDict?.success != nil {
                
                ToastManager.show(title: nullStringToEmpty(string: self.successDict?.success?.msg), state: .success)
                self.dismiss(animated: true, completion: nil)
                
             
            }
        }
        
    }
    
    func showError(error: CustomError) {
        
        self.loader.isHidden = true
        ToastManager.show(title:  nullStringToEmpty(string: error.localizedDescription.trimString()), state: .error)
    }
    
}

extension UIStackView {
    
    func addBackground(color: UIColor) {
        
        let subview = UIView(frame: bounds)
        subview.backgroundColor = color
        subview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        applyShadowView(view: subview)
        subview.layer.cornerRadius = 8
        subview.maskToBounds = true
        subview.setGradientBackgroundForView()
        insertSubview(subview, at: 0)
    }
    
}


extension ProductViewController : RefreshDelegate {
    func didReceiveRefresh(isRefresh: Bool, successDict: SuccessDict) {
        if isRefresh {
            
            self.getProductDetails(id: productID)
            
            if successDict.merchant != nil {
                       guard let vc = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.WebViewController) as? WebViewController else { return }
                       vc.successInfo = successDict
                       self.navigationController?.pushViewController(vc, animated: true)
                       }
        }
    }
}
