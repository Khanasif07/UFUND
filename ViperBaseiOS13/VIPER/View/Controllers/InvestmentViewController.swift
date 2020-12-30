//
//  InvestmentViewController.swift
//  ViperBaseiOS13
//
//  Created by Deepika on 10/12/19.
//  Copyright © 2019 CSS. All rights reserved.
//

import UIKit
import SDWebImage
import ObjectMapper

class InvestmentCell: UITableViewCell {
    
   
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var decriptionLbl: UILabel!
    @IBOutlet weak var shadowView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        decriptionLbl.textColor = UIColor.white
        priceLbl.textColor = UIColor.white
        applyShadowView(view: shadowView)
        shadowView.setGradientBackgroundForCornerRadiusView()
        
    }
}


class InvestmentViewController: UIViewController {

    @IBOutlet weak var investDescLbl: UILabel!
   
    @IBOutlet weak var investPriceLbl: UILabel!
    @IBOutlet weak var investmentNameLbl: UILabel!
    private lazy var loader  : UIView = {
              return createActivityIndicator(self.view)
    }()
    var productID = Int()
    var productDetails : ProductModel?
    @IBOutlet weak var inversterPrice: UILabel!
    @IBOutlet weak var vynilPrice: UILabel!
    @IBOutlet weak var priceStack: UIStackView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLbl: UILabel!
    var testArr = ["1"]
    var webUrlImages :[UIImage] = [#imageLiteral(resourceName: "smallDiamond")]
    var webUrlImages1 = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        tableView.delegate = self
        tableView.dataSource = self
        
        priceStack.addBackground(color: UIColor(hex: primaryColor))
        
        titleLbl.text = Constants.string.investment.uppercased().localize()
        
        overrideUserInterfaceStyle = .light 
        
        inversterPrice.textColor = UIColor(hex: primaryColor)
        vynilPrice.textColor = UIColor(hex: primaryColor)
    
    }
    
    @IBAction func goBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func getProductDetails(id:Int?) {
        
        let url = "\(Base.productDetails.rawValue)/\(id ?? 0)"
        self.presenter?.HITAPI(api: url, params: nil, methodType:.GET, modelClass: ProductModel.self, token: true)
        self.loader.isHidden = false
    }

}

extension InvestmentViewController: UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return webUrlImages.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "InvestmentCell", for: indexPath) as! InvestmentCell
        
         cell.imgView.image = webUrlImages[indexPath.row]
         cell.backgroundColor = .clear
         cell.selectionStyle = .none
         
        if self.productDetails != nil {
            
            if indexPath.row == 0 {
                
                cell.decriptionLbl.text = Constants.string.totalSpent
                cell.priceLbl.text = " $\(self.productDetails?.investment_product_total ?? 0.0)"
                
            } else {
                
                cell.decriptionLbl.text = Constants.string.totalEarn
                cell.priceLbl.text = "\(20.0)"
            }
            
        }
      
        return cell
        
    }
  
}


//MARK: - Collection view delegate
extension InvestmentViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return webUrlImages1.count > 0 ? webUrlImages1.count : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: XIB.Names.GridCell, for: indexPath) as! GridCell
        cell.backgroundColor = .clear
        
        
        let imgEntity =  webUrlImages1[indexPath.row]
        let url = URL.init(string: baseUrl + "/" +  nullStringToEmpty(string: imgEntity))
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

extension InvestmentViewController : PresenterOutputProtocol {
    
    func showSuccess(api: String, dataArray: [Mappable]?, dataDict: Mappable?, modelClass: Any) {
        
        self.loader.isHidden = true
        self.productDetails = dataDict as? ProductModel
        self.tableView.reloadData()
        
       
        investDescLbl.text = nullStringToEmpty(string: self.productDetails?.product_description)
        investmentNameLbl.text = nullStringToEmpty(string: self.productDetails?.product_title)
        investPriceLbl.text = " $\(self.productDetails?.product_amount?.round(to: 2) ?? 0.0) "
        inversterPrice.text =  "$\(self.productDetails?.invested_amount?.round(to: 2) ?? 0.0)\nYour Investment"
        vynilPrice.text = "$\(self.productDetails?.earnings?.round(to: 2) ?? 0.0)\n Your Earn" //"19.0\nYou Earn"
        
        if self.productDetails != nil {
            
            webUrlImages1.append(nullStringToEmpty(string: self.productDetails?.product_image))
            
            if self.productDetails?.product_child_image?.count  ?? 0 > 0 {
                
                for img in self.productDetails?.product_child_image ?? [] {
                    self.webUrlImages1.append(nullStringToEmpty(string: img.image))
                }
                
            }
        }
    
        self.collectionView.reloadData()
    }
    
    func showError(error: CustomError) {
        
        self.loader.isHidden = true
        ToastManager.show(title:  nullStringToEmpty(string: error.localizedDescription.trimString()), state: .error)
    }
    
}



