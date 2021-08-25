//
//  MyInvestmentsDetailVC.swift
//  ViperBaseiOS13
//
//  Created by Admin on 08/03/21.
//  Copyright © 2021 CSS. All rights reserved.

import ObjectMapper
import UIKit
import MXParallaxHeader

class MyInvestmentsDetailVC: UIViewController {
    
    enum MyInvestmentsDetailCellType: String{
        case productImageCell
        case productDescCell
        case productDateCell
        case assetDetailInfoCell
        case productInvestmentCell
        case InvestmentsProfitCell
        case assetsSupplyTableCell
    }
    
    
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var statusRadioImgView: UIImageView!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var buyProductBtn: UIButton!
    @IBOutlet weak var investBtn: UIButton!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var headerImgView: UIImageView!
    @IBOutlet weak var liveView: UIView!
    @IBOutlet var headerView: UIView!
    @IBOutlet weak var mainTableView: UITableView!
    
    
    // MARK: - Variables
    //===========================
    let userType = UserDefaults.standard.value(forKey: UserDefaultsKey.key.isFromInvestor) as? String
    var productModel: ProductModel?
    private lazy var loader  : UIView = {
        return createActivityIndicator(self.view)
    }()
    var investmentType: MyInvestmentType = .MyProductInvestment
    var cellTypes : [MyInvestmentsDetailCellType] = [.productDescCell,.productDateCell,.productInvestmentCell]
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.liveView.roundCorners([.layerMaxXMaxYCorner,.layerMaxXMinYCorner], radius: liveView.frame.height / 2.0)
        bottomView.addShadowToTopOrBottom(location: .top, color: UIColor.black16)
        investBtn.setCornerRadius(cornerR: 4.0)
        buyProductBtn.setCornerRadius(cornerR: 4.0)
    }
    
    // MARK: - IBActions
    //===========================
    @IBAction func investBtnAction(_ sender: UIButton) {
        let vc = ProductDetailPopUpVC.instantiate(fromAppStoryboard: .Products)
        vc.isForBuyAndToken = (investmentType == .MyProductInvestment) ? .InvestProduct : .InvestToken
        vc.productModel = productModel
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.popOrDismiss(animation: true)
    }
    
    @IBAction func buyProductBtnAction(_ sender: UIButton) {
        let vc = ProductDetailPopUpVC.instantiate(fromAppStoryboard: .Products)
        vc.isForBuyAndToken = (investmentType == .MyProductInvestment) ? .InvestProduct : .InvestToken
        vc.productModel = productModel
        self.present(vc, animated: true, completion: nil)
    }
}

// MARK: - Extension For Functions
//===========================
extension MyInvestmentsDetailVC {
    
    private func initialSetup() {
        self.setUpForProductAndTokenPage()
        self.setFooterView()
        self.setupTableView()
        self.parallelHeaderSetUp()
    }
    
    private func setupTableView(){
        self.mainTableView.registerCell(with: ProductDetailDescriptionCell.self)
        self.mainTableView.registerCell(with: ProductDetailDateCell.self)
        self.mainTableView.registerCell(with: ProductDetailInvestmentCell.self)
        self.mainTableView.registerCell(with: InvestmentsProfitTableCell.self)
        self.mainTableView.registerCell(with: AssetsDetailInfoCell.self)
        self.mainTableView.registerCell(with: AssetsSupplyTableCell.self)
        self.mainTableView.delegate = self
        self.mainTableView.dataSource = self
    }
    
    private func setUpForProductAndTokenPage(){
        if investmentType == .MyProductInvestment {
            investBtn.isHidden = false
            self.liveView.backgroundColor = (productModel?.product_status == 1) ? #colorLiteral(red: 0.1411764706, green: 0.6352941176, blue: 0.6666666667, alpha: 1) : (productModel?.product_status == 2) ? #colorLiteral(red: 0.09019607843, green: 0.6705882353, blue: 0.3568627451, alpha: 1) : #colorLiteral(red: 0.09019607843, green: 0.6705882353, blue: 0.3568627451, alpha: 1)
            self.statusRadioImgView.image = (productModel?.product_status == 1) ? #imageLiteral(resourceName: "icRadioSelected") : (productModel?.product_status == 2) ? #imageLiteral(resourceName: "radioCheckSelected") : #imageLiteral(resourceName: "radioCheckSelected")
            self.statusLbl.text = (productModel?.product_status == 1) ? "Live" : (productModel?.status == 2) ? "Closed" : "Matured"
            self.buyProductBtn.setTitle(" Buy " + ProductCreate.keys.products, for: .normal)
            self.cellTypes = [.productDescCell,.productDateCell,.productInvestmentCell,.InvestmentsProfitCell]
            self.hitProductDetailAPI()
        } else {
            investBtn.isHidden = true
            self.liveView.backgroundColor = (productModel?.token_status == 1) ? #colorLiteral(red: 0.1411764706, green: 0.6352941176, blue: 0.6666666667, alpha: 1) : (productModel?.token_status == 2) ? #colorLiteral(red: 0.09019607843, green: 0.6705882353, blue: 0.3568627451, alpha: 1) : #colorLiteral(red: 0.09019607843, green: 0.6705882353, blue: 0.3568627451, alpha: 1)
            self.statusRadioImgView.image = (productModel?.token_status == 1) ? #imageLiteral(resourceName: "icRadioSelected") : (productModel?.token_status == 2) ? #imageLiteral(resourceName: "icRadioSelected") : #imageLiteral(resourceName: "icRadioSelected")
            self.statusLbl.text = (productModel?.token_status == 1) ? "Live" : "Live"
            self.buyProductBtn.setTitle(" Buy " + ProductCreate.keys.tokens_assets, for: .normal)
            self.cellTypes = [.productDescCell,.assetDetailInfoCell,.productDateCell,.assetsSupplyTableCell]
            self.hitTokensDetailAPI()
        }
    }
    
    private func parallelHeaderSetUp() {
        let parallexHeaderHeight = isDeviceIPad ? CGFloat(450.0) : CGFloat(325.0)
        self.mainTableView.sectionHeaderHeight = CGFloat.leastNormalMagnitude
        self.headerView.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: self.view.frame.size.width, height: isDeviceIPad ? 450.0 : 325.0)
        self.mainTableView.parallaxHeader.view = self.headerView
        self.mainTableView.parallaxHeader.minimumHeight = 0.0 // 64
        self.mainTableView.parallaxHeader.height = parallexHeaderHeight
        self.mainTableView.parallaxHeader.mode = .fill
//        self.mainTableView.parallaxHeader.mode = MXParallaxHeaderMode.fill
        mainTableView.parallaxHeader.view.widthAnchor.constraint(equalTo: mainTableView.widthAnchor).isActive = true
        self.headerView.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11.0, *) {
            mainTableView.contentInsetAdjustmentBehavior = .always
        }
    }
    
    private func setFont(){
        self.investBtn.borderColor = UIColor.rgb(r: 255, g: 31, b: 45)
        self.investBtn.borderLineWidth = 1.0
        self.buyProductBtn.setTitleColor(.white, for: .normal)
        if  investmentType == .MyProductInvestment {
            self.buyProductBtn.backgroundColor = (productModel?.investment_product_total ?? 0.0) != 0.0 ?  UIColor.rgb(r: 235, g: 235, b: 235)
                : UIColor.rgb(r: 255, g: 31, b: 45)
            self.buyProductBtn.isUserInteractionEnabled = (productModel?.investment_product_total ?? 0.0) != 0.0 ?  false
                : true
        } else {
            self.buyProductBtn.backgroundColor = (productModel?.tokenrequest?.avilable_token ?? 0) == 0 ?  UIColor.rgb(r: 235, g: 235, b: 235)
                : UIColor.rgb(r: 255, g: 31, b: 45)
            self.buyProductBtn.isUserInteractionEnabled = (productModel?.tokenrequest?.avilable_token ?? 0) == 0 ?  false
                : true
        }
         self.statusLbl.font =  isDeviceIPad ? .setCustomFont(name: .bold, size: .x17) : .setCustomFont(name: .bold, size: .x13)
        self.buyProductBtn.titleLabel?.font  = isDeviceIPad ? .setCustomFont(name: .medium, size: .x18) : .setCustomFont(name: .medium, size: .x14)
        self.investBtn.titleLabel?.font  = isDeviceIPad ? .setCustomFont(name: .medium, size: .x18) : .setCustomFont(name: .medium, size: .x14)
    }
    
    private func setFooterView(){
        let footerView = UIView()
        footerView.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 150.0)
        self.mainTableView.tableFooterView = footerView
        let imgEntity = investmentType == .MyProductInvestment ?  productModel?.product_image ?? "" : productModel?.token_image ?? ""
//        let url = URL(string: baseUrl + "/" +  nullStringToEmpty(string: imgEntity))
        let url = URL(string: nullStringToEmpty(string: imgEntity))
        self.headerImgView.sd_setImage(with: url , placeholderImage: nil)
    }
    
    private func getProgressPercentage() -> Double{
        let investValue =   (productModel?.investment_product_total ?? 0.0 )
        let totalValue =  (productModel?.total_product_value ?? 0.0)
        return (investValue / totalValue) * 100
    }
    
    private func getProgressPerForYourInvestment() -> Double{
        let earnings =   (productModel?.earnings ?? 0.0 )
        let invested_amount =  (productModel?.invested_amount ?? 0.0)
        if invested_amount == 0.0 {
            return 0.0
        }
        return ((earnings  * 100) / invested_amount)
    }
    
    private func hitProductDetailAPI(){
          self.loader.isHidden = false
          self.presenter?.HITAPI(api: "/\(Base.productsDetail.rawValue)/\(productModel?.id ?? 0)", params: nil, methodType: .GET, modelClass: ProductModel.self, token: true)
      }
    
    private func hitTokensDetailAPI(){
        self.loader.isHidden = false
        self.presenter?.HITAPI(api: "/\(Base.tokensDetail.rawValue)/\(productModel?.id ?? 0)", params: nil, methodType: .GET, modelClass: ProductDetailsEntity.self, token: true)
    }
}

// MARK: - Extension For TableView
//===========================
extension MyInvestmentsDetailVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellTypes.endIndex
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch cellTypes[indexPath.row] {
        case .productDescCell:
            let cell = tableView.dequeueCell(with: ProductDetailDescriptionCell.self, indexPath: indexPath)
            switch investmentType {
            case .MyProductInvestment:
                cell.productTitleLbl.text = productModel?.product_title ?? ""
                cell.priceLbl.text = "$ " + "\(productModel?.total_product_value ?? 0.0)"
                cell.productDescLbl.text = "\(productModel?.product_description ?? "")"
            default:
                cell.productLbl.text = ProductCreate.keys.token
                cell.productDetailLbl.text = ProductCreate.keys.tokenDetail
                cell.productTitleLbl.text = productModel?.tokenname ?? ""
                cell.priceLbl.text = "$ " + "\(productModel?.tokenvalue ?? 0.0)"
                cell.productDescLbl.text = "\(productModel?.asset?.description ?? "")"
            }
            return cell
        case .assetDetailInfoCell:
            let cell = tableView.dequeueCell(with: AssetsDetailInfoCell.self, indexPath: indexPath)
            cell.configureCell(model: productModel ?? ProductModel(json: [:]))
            return cell
        case .productDateCell:
            let cell = tableView.dequeueCell(with: ProductDetailDateCell.self, indexPath: indexPath)
            switch investmentType {
            case .MyProductInvestment:
                cell.setCellForInvestmentDetailPage()
                cell.configureCell(model: self.productModel ?? ProductModel(json: [:]))
            default:
                cell.bottomStackView.isHidden = true
                cell.configureCellForAssetsDetailPage(model: self.productModel ?? ProductModel(json: [:]))
            }
            return cell
        case .productInvestmentCell:
            let cell = tableView.dequeueCell(with: ProductDetailInvestmentCell.self, indexPath: indexPath)
            switch investmentType {
            case .MyProductInvestment:
                cell.overAllInvestmentLbl.text = "$ " + "\(productModel?.investment_product_total ?? 0.0)"
                cell.progressPercentageValue = self.getProgressPercentage().round(to: 2)
                cell.progressValue.text = "\(self.getProgressPercentage().round(to: 1))" + "%"
            default:
                cell.overAllInvestmentLbl.text = "$ " + "\(productModel?.investment_product_total ?? 0.0)"
            }
            return cell
        case .assetsSupplyTableCell:
            let cell = tableView.dequeueCell(with: AssetsSupplyTableCell.self, indexPath: indexPath)
            if userType == UserType.investor.rawValue {
                cell.configureCellForInvestor(model: productModel ?? ProductModel(json: [:]))
            } else {
                cell.configureCellForCampaigner(model: productModel?.asset ?? Asset(json: [:]),productModel: productModel ?? ProductModel(json: [:]) )
            }
            return cell
        default:
            let cell = tableView.dequeueCell(with: InvestmentsProfitTableCell.self, indexPath: indexPath)
            cell.progressPercentageValue = self.getProgressPerForYourInvestment().round(to: 2)
            cell.configureCell(model: productModel ?? ProductModel(json: [:]))
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - Extension For PresenterOutputProtocol
//===========================
extension MyInvestmentsDetailVC : PresenterOutputProtocol {
    
    func showSuccess(api: String, dataArray: [Mappable]?, dataDict: Mappable?, modelClass: Any) {
        switch api {
        case "/\(Base.productsDetail.rawValue)/\(productModel?.id ?? 0)":
            self.loader.isHidden = true
            self.productModel = dataDict as? ProductModel
            self.setFont()
            self.mainTableView.reloadData()
        case "/\(Base.tokensDetail.rawValue)/\(productModel?.id ?? 0)":
            self.loader.isHidden = true
            if let productDetailData = dataDict as? ProductDetailsEntity {
                self.productModel = productDetailData.data
                self.setFont()
            }
            self.mainTableView.reloadData()
        default:
            break
        }
    }
    
    func showError(error: CustomError) {
        self.loader.isHidden = true
        ToastManager.show(title:  nullStringToEmpty(string: error.localizedDescription.trimString()), state: .error)
    }
}
