//
//  ProductDetailVC.swift
//  ViperBaseiOS13
//
//  Created by Admin on 19/02/21.
//  Copyright © 2021 CSS. All rights reserved.
//

import UIKit

class ProductDetailVC: UIViewController {
    
    enum ProductDetailCellType: String{
        case productImageCell
        case productDescCell
        case productDateCell
        case productInvestmentCell
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
    
    let userType = UserDefaults.standard.value(forKey: UserDefaultsKey.key.isFromInvestor) as? String
    var cellTypes = [ProductDetailCellType.productDescCell,ProductDetailCellType.productDateCell,ProductDetailCellType.productInvestmentCell]
    
    // MARK: - Variables
    //===========================
    var productModel: ProductModel?
    
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
        vc.isForBuyproduct = false
        vc.productModel = productModel
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.popOrDismiss(animation: true)
    }
    
    @IBAction func buyProductBtnAction(_ sender: UIButton) {
        let vc = ProductDetailPopUpVC.instantiate(fromAppStoryboard: .Products)
        vc.isForBuyproduct = true
        vc.productModel = productModel
        self.present(vc, animated: true, completion: nil)
    }
}

// MARK: - Extension For Functions
//===========================
extension ProductDetailVC {
    
    private func initialSetup() {
        self.setFont()
        self.setFooterView()
        self.mainTableView.registerCell(with: ProductDetailDescriptionCell.self)
        self.mainTableView.registerCell(with: ProductDetailDateCell.self)
        self.mainTableView.registerCell(with: ProductDetailInvestmentCell.self)
        self.mainTableView.delegate = self
        self.mainTableView.dataSource = self
        self.mainTableView.tableHeaderView = headerView
        let imgEntity =  productModel?.product_image ?? ""
        let url = URL(string: baseUrl + "/" +  nullStringToEmpty(string: imgEntity))
        self.headerImgView.sd_setImage(with: url , placeholderImage: nil)
        self.bottomView.isHidden = userType != UserType.investor.rawValue
    }
    
    private func setFont(){
        self.liveView.backgroundColor = (productModel?.product_status == 1) ? #colorLiteral(red: 0.1411764706, green: 0.6352941176, blue: 0.6666666667, alpha: 1) : (productModel?.product_status == 2) ? #colorLiteral(red: 0.09019607843, green: 0.6705882353, blue: 0.3568627451, alpha: 1) : #colorLiteral(red: 0.09019607843, green: 0.6705882353, blue: 0.3568627451, alpha: 1)
        self.statusRadioImgView.image = (productModel?.product_status == 1) ? #imageLiteral(resourceName: "icRadioSelected") : (productModel?.product_status == 2) ? #imageLiteral(resourceName: "radioCheckSelected") : #imageLiteral(resourceName: "radioCheckSelected")
        self.statusLbl.text = (productModel?.product_status == 1) ? "Live" : (productModel?.product_status == 2) ? "Closed" : "Matured"
        self.investBtn.borderColor = UIColor.rgb(r: 255, g: 31, b: 45)
        self.investBtn.borderLineWidth = 1.0
        self.buyProductBtn.setTitleColor(.white, for: .normal)
        self.buyProductBtn.backgroundColor = (productModel?.investment_product_total ?? 0.0) != 0.0 ?  UIColor.rgb(r: 235, g: 235, b: 235)
        : UIColor.rgb(r: 255, g: 31, b: 45)
        self.buyProductBtn.isUserInteractionEnabled = (productModel?.investment_product_total ?? 0.0) != 0.0 ?  false
        : true
    }
    
    private func setFooterView(){
        let footerView = UIView()
        footerView.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50.0)
        self.mainTableView.tableFooterView = footerView
    }
    
    private func getProgressPercentage() -> Double{
        let investValue =   (productModel?.investment_product_total ?? 0.0 )
        let totalValue =  (productModel?.total_product_value ?? 0.0)
        return (investValue / totalValue) * 100
    }
}

// MARK: - Extension For TableView
//===========================
extension ProductDetailVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellTypes.endIndex
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch cellTypes[indexPath.row] {
        case ProductDetailCellType.productDescCell:
            let cell = tableView.dequeueCell(with: ProductDetailDescriptionCell.self, indexPath: indexPath)
            cell.productTitleLbl.text = productModel?.product_title ?? ""
            cell.priceLbl.text = "$ " + "\(productModel?.total_product_value ?? 0.0)"
            cell.productDescLbl.text = "\(productModel?.product_description ?? "")"
            return cell
        case ProductDetailCellType.productDateCell:
            let cell = tableView.dequeueCell(with: ProductDetailDateCell.self, indexPath: indexPath)
            cell.configureCell(model: self.productModel!)
            return cell
        default:
            let cell = tableView.dequeueCell(with: ProductDetailInvestmentCell.self, indexPath: indexPath)
            cell.overAllInvestmentLbl.text = "$ " + "\(productModel?.investment_product_total ?? 0.0)"
            cell.progressPercentageValue = self.getProgressPercentage().round(to: 2)
            cell.progressValue.text = "\(self.getProgressPercentage().round(to: 1))" + "%"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
