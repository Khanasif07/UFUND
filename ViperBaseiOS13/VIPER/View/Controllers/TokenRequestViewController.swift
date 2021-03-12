//
//  TokenRequestViewController.swift
//  ViperBaseiOS13
//
//  Created by Deepika on 21/01/20.
//  Copyright © 2020 CSS. All rights reserved.
//

import UIKit
import ObjectMapper

class TokenReqCell: UITableViewCell {

    @IBOutlet weak var shadoeView: UIView!
    @IBOutlet weak var tokenImg: UIImageView!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var statusButton: UIButton!
    @IBOutlet weak var labelTokenNAme: UILabel!
    @IBOutlet weak var labelSubtitle: UILabel!
    
    @IBAction func buttonRequest(_ sender: Any) {
        
    }
    
    @IBAction func buttonToken(_ sender: Any) {
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        shadoeView.applyShadow()
        tokenImg.setCirclerCornerRadius()
        statusView.setGradientBackgroundForCornerRadiusView()
        statusButton.setDisableButton()
        //statusButton.setTitle("Gold", for: .normal)
        
    }
}

class TokenRequestViewController: UIViewController {

    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var buttonToken: UIButton!
    
    @IBOutlet weak var buttonProducts: UIButton!
    
    @IBOutlet weak var productCV: UICollectionView!
    
       var tokensArray :[TokenRequestModel]?
       var productArray : [ProductModel]?
       var responseDic : ProductListModel?
    
      var isTokenAssets = true {
                  
                  didSet {
                      
                      if isTokenAssets
                      {
                        
                        buttonToken.backgroundColor = #colorLiteral(red: 0.9287412763, green: 0, blue: 0, alpha: 1)
                        buttonProducts.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                        productCV.isHidden = true
                        tableView.isHidden = false
                        buttonToken.setTitleColor(UIColor.white, for: .normal)
                        buttonProducts.setTitleColor(UIColor.black, for: .normal)
                        //  getProducts()
                        
                      } else {
                        
                        buttonProducts.backgroundColor = #colorLiteral(red: 0.9287412763, green: 0, blue: 0, alpha: 1)
                        buttonToken.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                        productCV.isHidden = false
                        tableView.isHidden = true
                        buttonToken.setTitleColor(UIColor.black, for: .normal)
                        buttonProducts.setTitleColor(UIColor.white, for: .normal)
                        getProducts()
                        
                    }
                  }
              }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        
        titleLbl.text = Constants.string.requests.localize().uppercased()
        tableView.delegate = self
        tableView.dataSource = self
        initialLoads()
    }

    
    private func initialLoads() {
        
        isTokenAssets = true
        buttonToken.tag = 1
        buttonProducts.tag = 2
        Common.setFont(to: buttonToken!, isTitle: true, size: 17, fontType: .semiBold)
        Common.setFont(to: buttonProducts!, isTitle: true, size: 17, fontType: .semiBold)
        buttonProducts.addTarget(self, action: #selector(buttonActions(sender:)), for: .touchUpInside)
        buttonToken.addTarget(self, action: #selector(buttonActions(sender:)), for: .touchUpInside)
        buttonToken.setTitle(Constants.string.TokenizedAssets.localize().uppercased(), for: .normal)
        
        buttonProducts.setTitle(Constants.string.Products.localize().uppercased(), for: .normal)
        
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        productCV.collectionViewLayout = layout
        
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        productCV.alwaysBounceHorizontal = false
        productCV.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        productCV.delegate = self
        productCV.dataSource = self
        getProducts()
       
        let nibPost = UINib(nibName: XIB.Names.ProductListCell, bundle: nil)
        productCV.register(nibPost, forCellWithReuseIdentifier: XIB.Names.ProductListCell)
        
        
    }
   
      private func getProducts(){
 
        
        if isTokenAssets {
            self.presenter?.HITAPI(api: Base.tokenRequests.rawValue, params: nil, methodType: .GET, modelClass:TokenRequestModel.self, token: true)
        }else{
            self.presenter?.HITAPI(api: Base.productRequests.rawValue, params: nil, methodType: .GET, modelClass:ProductModel.self, token: true)

        }
   
      }
      
      @IBAction func buttonActions(sender:UIButton)
      {
         
          isTokenAssets = sender.tag == 1 ? true : false
          
      }
    
    
}

extension TokenRequestViewController {
   
    @IBAction func goBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension TokenRequestViewController: UITableViewDataSource, UITableViewDelegate {
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tokensArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TokenReqCell", for: indexPath) as! TokenReqCell
        cell.labelTokenNAme.text = self.tokensArray?[indexPath.row].tokenname
        cell.labelSubtitle.text = self.tokensArray?[indexPath.row].tokensymbol
        let url = "\(baseUrl)/\(self.tokensArray?[indexPath.row].token_image ?? "")"
        cell.statusButton.setTitle(nullStringToEmpty(string: self.tokensArray?[indexPath.row].asset?.category?.category_name), for: .normal)
        print(">>url",self.tokensArray?[indexPath.row].asset?.category?.category_name)
        Cache.image(forUrl: url) { image in
            
            DispatchQueue.main.async
                {
                cell.tokenImg.image = image != nil ? image : #imageLiteral(resourceName: "gold")

                }
        }
        
 
   
         cell.backgroundColor = .clear
         cell.selectionStyle = .none

        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//         guard let vc = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.ProductViewController) as? ProductViewController else { return }
//        vc.getProductDetails(id: self.tokensArray?[indexPath.row].id)
//        print(">>tokensArray",tokensArray)
//        vc.id = 1
//        vc.isFromTokenRequest =  true
//        self.navigationController?.pushViewController(vc, animated: true)
        
        
        guard let vc = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.ProductViewController) as? ProductViewController else { return }
        vc.productID = self.tokensArray?[indexPath.row].id ?? 0
             vc.getProductDetails(id:self.tokensArray?[indexPath.row].id)
                 vc.isFromTokenRequest = true
        vc.getProductDetails(id: self.tokensArray?[indexPath.row].id ?? 0 )
             vc.tokenId = self.tokensArray?[indexPath.row].id ?? 0
            
             self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
}

extension TokenRequestViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.productArray?.count ?? 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: XIB.Names.ProductListCell, for: indexPath) as! ProductListCell
        
        cell.backgroundColor = .clear
        cell.statusView.isHidden = true
        cell.labelTitle.text = nullStringToEmpty(string: self.productArray?[indexPath.row].product_title)
        cell.labelProductAmount.text = " \(deafaultCurrency) \(self.productArray?[indexPath.row].product_amount ?? 0) "
        cell.labelValue.text = " \(deafaultCurrency) \(self.productArray?[indexPath.row].product_amount ?? 0) "
        let url = "\(baseUrl)/\(self.productArray?[indexPath.row].product_image ?? "")"
        print(">>url",url)
       
        Cache.image(forUrl: url) { image in
            
            DispatchQueue.main.async {
                cell.productImage.image = image != nil ? image : #imageLiteral(resourceName: "gold")

            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        //return CGSize(width: self.productCV.frame.width / 2 , height: 30 * productCV.frame.height / 100)
        
        return CGSize(width : self.productCV.frame.width / 2 , height : 32 * productCV.frame.height / 100)
        
        
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//
//        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
//
//    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       guard let vc = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.ProdDetailViewController) as? ProdDetailViewController else { return }
        
             vc.getProductDetails(id:self.productArray?[indexPath.row].id)

             self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension TokenRequestViewController : PresenterOutputProtocol {
    
    
    func showSuccess(api: String, dataArray: [Mappable]?, dataDict: Mappable?, modelClass: Any) {
        
           switch api {
               
           case Base.tokenRequests.rawValue:
               
               self.tokensArray = dataArray as? [TokenRequestModel]
               self.tableView.reloadData()
               
           case Base.productRequests.rawValue:
               
               self.productArray = dataArray as? [ProductModel]
               self.productCV.reloadData()
               
           default:
              break
           }
       }
       
       func showError(error: CustomError) {
          
            ToastManager.show(title:  nullStringToEmpty(string: error.localizedDescription.trimString()), state: .error)

       }
}
