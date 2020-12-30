//
//  ProdDetailViewController.swift
//  ViperBaseiOS13
//
//  Created by Deepika on 27/11/19.
//  Copyright © 2019 CSS. All rights reserved.
//

import UIKit
import ObjectMapper
import SDWebImage

 
class ProdDetailViewController: UIViewController {

    @IBOutlet weak var maturityDateLbl: UILabel!
    @IBOutlet weak var startDateVal: UILabel!
    @IBOutlet weak var endDateVal: UILabel!
    @IBOutlet weak var investProgressBar: UIProgressView!
    @IBOutlet weak var investEndLbl: UILabel!
    @IBOutlet weak var investMiddleLbl: UILabel!
    @IBOutlet weak var investStartLbl: UILabel!
    @IBOutlet weak var investmentBoardSilder: UIView!
    @IBOutlet weak var yourInvestLbl: UILabel!
    @IBOutlet weak var orvallLbl: UILabel!
    @IBOutlet weak var yourInvestment: UIView!
    @IBOutlet weak var eanCode: UILabel!
    @IBOutlet weak var hsCode: UILabel!
    @IBOutlet weak var brandName: UILabel!
    @IBOutlet weak var catogrieName: UILabel!
    var productID = Int()
    var productDetails : ProductModel?
    @IBOutlet weak var borderSilderView: UIView!
    @IBOutlet weak var inverstorsLbl: UILabel!
    @IBOutlet weak var investedLbl: UILabel!
    @IBOutlet weak var availableLbl: UILabel!
    @IBOutlet weak var endVal: UILabel!
    @IBOutlet weak var middleValLbl: UILabel!
    @IBOutlet weak var startValLbl: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var stackView: UIStackView!
    
    var isFromMyProduct = false 
   
    @IBAction func buyClick(_ sender: UIButton) {
       
         //getInvestBuyTransaction(type: nullStringToEmpty(string: BuyOrInvest.buy), ids: productDetails?.id ?? 0)
        let customAlertViewController = BuyTokenViewController(nibName: "BuyTokenViewController", bundle: nil)
                          customAlertViewController.type = nullStringToEmpty(string: BuyOrInvest.buy)
        customAlertViewController.ids = productID
        customAlertViewController.isFromProductBuy = true
                          customAlertViewController.delegate = self
                          customAlertViewController.productDetails = productDetails
                          customAlertViewController.productOrToken = nullStringToEmpty(string: BuyOrInvest.product)
                          customAlertViewController.providesPresentationContextTransitionStyle = true;
                          customAlertViewController.definesPresentationContext = true;
                          customAlertViewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                          customAlertViewController.view.backgroundColor = UIColor(white: 0, alpha: 0.25)
                          self.present(customAlertViewController, animated: false, completion: nil)
    
        
    }
    
    @IBAction func investClick(_ sender: UIButton) {
        let customAlertViewController = TokenAssetsAmountViewController(nibName: "TokenAssetsAmountViewController", bundle: nil)
        customAlertViewController.type = nullStringToEmpty(string: BuyOrInvest.invest)
        customAlertViewController.ids = productDetails?.id ?? 0
        customAlertViewController.delegate = self
        customAlertViewController.productOrToken = nullStringToEmpty(string: BuyOrInvest.product)
        customAlertViewController.cryptoEntity = self.productDetails?.payment_method_type ?? []
        customAlertViewController.providesPresentationContextTransitionStyle = true;
        customAlertViewController.definesPresentationContext = true;
        customAlertViewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        customAlertViewController.view.backgroundColor = UIColor(white: 0, alpha: 0.25)
        self.present(customAlertViewController, animated: false, completion: nil)
    }
    private lazy var loader  : UIView = {
        
    return createActivityIndicator(self.view)
        
    }()
    @IBOutlet weak var investButton: UIButton!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBAction func goBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    var imageURLArray =  [String]()
    @IBOutlet weak var labelProductName: UILabel!
       
    let userType = UserDefaults.standard.value(forKey: UserDefaultsKey.key.isFromInvestor) as? String
     
    @IBOutlet weak var totlPriceLbl: UILabel!
    @IBOutlet weak var price: UIStackView!
    var webUrlImages :[UIImage] = [#imageLiteral(resourceName: "notifyBg"),#imageLiteral(resourceName: "bg3"),#imageLiteral(resourceName: "bg2")]
    var testTxt = ""
    var successDict: SuccessDict?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        borderSilderView.setCirclerCornerRadius()
        borderSilderView.layer.borderColor = UIColor.lightGray.cgColor
        borderSilderView.layer.borderWidth = 0.5
        
        investmentBoardSilder.setCirclerCornerRadius()
           investmentBoardSilder.layer.borderColor = UIColor.lightGray.cgColor
           investmentBoardSilder.layer.borderWidth = 0.5
        
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
        
//        buyButton.isHidden = userType == UserType.campaigner.rawValue
//               investButton.isHidden = userType == UserType.campaigner.rawValue
        
       
        
        price.addBackground(color: UIColor(hex: primaryColor))
        
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        investButton.setGradientBackground()
        buyButton.setGradientBackground()
        buyButton.setTitle(Constants.string.buy.localize().uppercased(), for: .normal)
        investButton.setTitle(Constants.string.invest.localize().uppercased(), for: .normal)
        descriptionLbl.text = nullStringToEmpty(string: testTxt)
        
        titleLbl.text = Constants.string.ProductsDetails.localize().uppercased()
        descriptionLbl.textColor = UIColor(hex: darkTextColor)
    
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
        
        
        investProgressBar.tintColor = UIColor(hex: primaryColor)
        investProgressBar.layer.cornerRadius = 4
        investProgressBar.clipsToBounds = true
        investProgressBar.layer.sublayers![1].cornerRadius = 4
        investProgressBar.subviews[1].clipsToBounds = true
        
        investEndLbl.textColor = UIColor(hex: darkTextColor)
        investStartLbl.textColor = UIColor(hex: darkTextColor)
        investMiddleLbl.textColor = UIColor(hex: darkTextColor)
        
        yourInvestLbl.text = Constants.string.yourInvestment.localize()
        orvallLbl.text = Constants.string.overrallInvestment.localize()
        
        
        if userType == UserType.campaigner.rawValue {
                            yourInvestment.isHidden = true
               } else {
                   yourInvestment.isHidden = false
               }
       
    }
    
    func getProductDetails(id:Int?) {
        let url = "\(Base.productDetails.rawValue)/\(id ?? 0)"
        self.presenter?.HITAPI(api: url, params: nil, methodType:.GET, modelClass: ProductModel.self, token: true)
        self.loader.isHidden = false

    }
}

//MARK: - Collection view delegate
extension ProdDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
   
    func numberOfSections(in collectionView: UICollectionView) -> Int {
       return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageURLArray.count > 0 ? imageURLArray.count : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: XIB.Names.GridCell, for: indexPath) as! GridCell
        cell.backgroundColor = .clear
        
        let url = URL.init(string: baseUrl + "/" +  nullStringToEmpty(string: imageURLArray[indexPath.row]))
        cell.webImgView.sd_setImage(with: url , placeholderImage: nil)
        cell.decriptionLbl.text = ""
        cell.readyView.isHidden = true
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

extension ProdDetailViewController : PresenterOutputProtocol
{
    
    func getInvestBuyTransaction(type: String, ids: Int) {
        
        var params = [String: AnyObject]()
        params[TransactionParam.keys.product_id] = ids as AnyObject
        params[TransactionParam.keys.type] = nullStringToEmpty(string: type) as AnyObject
        self.loader.isHidden = true
        print(">>> params",params)
        
        self.presenter?.HITAPI(api: Base.investBuyTransaction.rawValue, params: params , methodType: .POST, modelClass: SuccessDict.self, token: true)
    }
    
    
    func showSuccess(api: String, dataArray: [Mappable]?, dataDict: Mappable?, modelClass: Any) {
        
        
        self.loader.isHidden = true
        self.productDetails = dataDict as? ProductModel
        setValue(data: self.productDetails)
        
        if nullStringToEmpty(string: api) ==  Base.investBuyTransaction.rawValue {
            self.loader.isHidden = true
            self.successDict = dataDict as? SuccessDict
            
            if self.successDict?.success != nil {
                
                ToastManager.show(title: nullStringToEmpty(string: self.successDict?.success?.msg), state: .success)
                self.dismiss(animated: true, completion: nil)
                getProductDetails(id: productID )
            }
        }
        
    }
    
    func showError(error: CustomError) {
        
        self.loader.isHidden = true
        ToastManager.show(title:  nullStringToEmpty(string: error.localizedDescription.trimString()), state: .error)
              
    }
    
    
 
    func setValue(data:ProductModel?) {
        
       
        self.endVal.text = " $\(data?.total_product_value ?? 0)"
        let middle = (data?.total_product_value ?? 0) / 2
        self.middleValLbl.text = "$\(middle)"
        
        
        
        self.investEndLbl.text = " $\(data?.total_product_value ?? 0)"
        let middleInvest = (data?.invested_amount ?? 0.0) / 2
        self.investMiddleLbl.text = "$\(middleInvest)"
        
        
       
        UIView.animate(withDuration: 1.0) {
            self.progressView.setProgress(1.0 , animated: true)
        }
        
        UIView.animate(withDuration: 1.0) {
            self.investProgressBar.setProgress(1.0 , animated: true)
        }
        
        print("middle",middle)
        
        let count =  (data?.investment_product_total ?? 0.0 ) / (data?.total_product_value ?? 0)
        progressView.progress = Float(count)
        
        
        let Investcount =  (data?.invested_amount ?? 0.0 ) / (data?.total_product_value ?? 0)
        investProgressBar.progress = Float(Investcount)
        
        self.startDateVal.text = nullStringToEmpty(string: data?.start_date)
        self.endDateVal.text = nullStringToEmpty(string: data?.end_date)
        self.maturityDateLbl.text = nullStringToEmpty(string: data?.maturity_date)
        
        
        self.labelProductName.text = data?.product_title
        self.totlPriceLbl.text = " " + "\(deafaultCurrency) \(data?.total_product_value?.round(to: 2) ?? 0)" + " "
        self.investedLbl.text = "$" + "\(data?.investment_product_total?.round(to: 2) ?? 0.0 )" + "\n"  + "Invested"
        
        if userType == UserType.campaigner.rawValue {
                                    self.inverstorsLbl.text =  "\(data?.product_investment_count ?? 0 )" + "\n" + "Investors"
                      } else {
                          self.inverstorsLbl.text =  "\(data?.earnings ?? 0 )" + "\n" + "You Earn"
                      }
        
        
      
        let aval = data?.total_product_value ?? 0.0 - (data?.investment_product_total ?? 0.0)
        self.availableLbl.text = "$" + "\(aval.round(to: 2))" + "\n"  + "Available"
        self.descriptionLbl.text = nullStringToEmpty(string: data?.product_description)
        self.imageURLArray.append(nullStringToEmpty(string: data?.product_image))
        
        self.eanCode.text = nullStringToEmpty(string: data?.ean_upc_code)
        self.hsCode.text = nullStringToEmpty(string: data?.hs_code)
        self.brandName.text = nullStringToEmpty(string: data?.brand)
        self.catogrieName.text = nullStringToEmpty(string: data?.category?.category_name)
        
        if data?.product_child_image?.count ?? 0 > 0 {
            
            for item in data?.product_child_image ?? [] {
                
                self.imageURLArray.append(nullStringToEmpty(string: item.image))
                
            }
        }
        
 
        print(">>>>>>data?.investment_product_total",data?.investment_product_total)
        print(">>>>>>payment_method_type",data?.payment_method_type)
        
        
        
        if isFromMyProduct == true {
            buyButton.isHidden = true
            investButton.isHidden = true
        } else {
            
            if userType == UserType.campaigner.rawValue {
                              buyButton.isHidden = true
                              investButton.isHidden = true
                
               
                   } else {
                       
                       if (data?.investment_product_total ?? 0.0)   == (data?.total_product_value ?? 0.0) {

                                  buyButton.isHidden = false
                                  investButton.isHidden = true

                               } else {
                                  
                                   buyButton.isHidden = true
                                   investButton.isHidden = false
                               }
                   }
            
        }
        
        
        
        self.collectionView.reloadData()
        
       
    }
    
}


extension ProdDetailViewController : RefreshDelegate {
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



