//
//  ProductListViewController.swift
//  ViperBaseiOS13
//
//  Created by Deepika on 26/12/19.
//  Copyright © 2019 CSS. All rights reserved.
//

import UIKit
import ObjectMapper

class TokenAssetsCell: UITableViewCell {
    
    @IBOutlet weak var backAssets: UILabel!
    @IBOutlet weak var assetsImg: UIImageView!
    @IBOutlet weak var investButton: UIButton!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelCoinName: UILabel!
    
  
    override func awakeFromNib() {
        super.awakeFromNib()
        
        buyButton.setTitle(Constants.string.buy.localize().uppercased(), for: .normal)
        investButton.setTitle(Constants.string.invest.localize().uppercased(), for: .normal)
        investButton.setGradientBackground()
        buyButton.backgroundColor = UIColor.black
        assetsImg.layer.cornerRadius = assetsImg.frame.height / 2
        assetsImg.clipsToBounds = true
       
    }
}


class ProductListViewController: UIViewController {
    
    var typedText =  ""
    var selctedId = Int()
    var productURL :String?
    var TokenURL: String?
    var selectedCatogries = "All"
    var catogriesEntity = [Categories]()
    var catogries = [String]()
    @IBOutlet weak var catogriesCollectionView: UICollectionView!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    var queryUrlProduct = ""
    var queryUrl = ""
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var productLbl: UILabel!
    @IBOutlet weak var tokenAssetsLable: UILabel!
    @IBOutlet weak var tokenAssetsGradButton: UIButton!
    @IBOutlet weak var productGradinateButton: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    var productsList : ProductListModel?
    var assetList : ProductListModel?
    var toInvestesrAllProducts = false
    var investerProductList : [ProductModel]?
    var investerTokenList : [TokenRequestModel]?
    
    var filterProduct : [ProductModel]?
    var filterInvest : [TokenRequestModel]?
    
    
    var tileStr: String?
    private lazy var loader  : UIView = {
        return createActivityIndicator(self.view)
    }()
    var productList = [1,2,3,4,5,6,7,8]
    var tokenOrProduct: String?
    var isTokenAssets = true {
        
        didSet {
            
            if isTokenAssets {
                tokenAssetsLable.textColor = UIColor.white
                productLbl.textColor = UIColor(hex: darkTextColor)
                productGradinateButton.isHidden = true
                tokenAssetsGradButton.isHidden = false
                collectionView.isHidden = true
                tableView.isHidden = false
                tokenOrProduct = "token"
                getTokenizedAssets()
                
            } else {
                productLbl.textColor = UIColor.white
                tokenAssetsLable.textColor = UIColor(hex: darkTextColor)
                productGradinateButton.isHidden = false
                tokenAssetsGradButton.isHidden = true
                collectionView.isHidden = false
                tableView.isHidden = true
                tokenOrProduct = "product"
                self.getProductList()
                
                
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
        
        isTokenAssets = true
        
        titleLbl.text = tileStr?.uppercased()
        let nibPost = UINib(nibName: XIB.Names.ProductListCell, bundle: nil)
        collectionView.register(nibPost, forCellWithReuseIdentifier: XIB.Names.ProductListCell)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView.collectionViewLayout = layout
        
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView.alwaysBounceHorizontal = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        searchBar.isHidden = true
        tokenAssetsLable.text = Constants.string.TokenizedAssets.uppercased().localize()
        productLbl.text = Constants.string.Products.uppercased().localize()
        tokenAssetsGradButton.setGradientBackgroundWithoutRadius()
        productGradinateButton.setGradientBackgroundWithoutRadius()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        let nibPost1 = UINib(nibName: XIB.Names.CatogriesCell, bundle: nil)
        catogriesCollectionView.register(nibPost1, forCellWithReuseIdentifier: XIB.Names.CatogriesCell)
        let layout1 = UICollectionViewFlowLayout()
        layout1.scrollDirection = .horizontal
        catogriesCollectionView.collectionViewLayout = layout1
        
        layout1.minimumInteritemSpacing = 10
        layout1.minimumLineSpacing = 10
        catogriesCollectionView.alwaysBounceHorizontal = false
        catogriesCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        catogriesCollectionView.delegate = self
        catogriesCollectionView.dataSource = self
        
        if userType == UserType.campaigner.rawValue {
            
            filterButton.isHidden = true
            searchButton.isHidden = true
            
        } else {
           
            filterButton.isHidden = false
            searchButton.isHidden = false
        }
       
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
         self.getTokenizedAssets()
    }
    
    @IBAction func filterClickEvent(_ sender: UIButton) {
        
        guard let vc = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.FilterSetViewController) as? FilterSetViewController else { return }
        vc.tokenOrProduct = nullStringToEmpty(string: self.tokenOrProduct)
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func searchClickEvent(_ sender: UIButton) {
        searchBar.isHidden = false
        self.searchBar.delegate = self
        self.searchBar.becomeFirstResponder()
        self.searchBar.showsCancelButton = true
    }
    
    @IBAction func goBack(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //MARK:- PRDUCTS LIST API CALL
    
    
    private func getProductList() {
        
        switch (userType,toInvestesrAllProducts) {
            
        case (UserType.campaigner.rawValue,false):
            
            self.presenter?.HITAPI(api: Base.myProductList.rawValue, params: nil, methodType: .GET, modelClass: ProductModel.self, token: true)
            
        case (UserType.investor.rawValue,false):
            
            self.presenter?.HITAPI(api: Base.investorAllProducts.rawValue, params: nil, methodType: .GET, modelClass: ProductModelEntity.self, token: true)
            
        case (UserType.investor.rawValue,true):
            
            self.presenter?.HITAPI(api: Base.investerProducts.rawValue, params: nil, methodType: .GET, modelClass: ProductModel.self, token: true)
            
        default:
            break
        }
        self.loader.isHidden = false
    }
    
    
    
    //MARK:- TOKEN LIST API CALL
    
    
    private func getTokenizedAssets() {
        
        switch (userType,toInvestesrAllProducts) {
            
        case (UserType.campaigner.rawValue,false):
            
            self.presenter?.HITAPI(api: Base.tokenizedAssestList.rawValue, params: nil, methodType: .GET, modelClass: TokenRequestModel.self, token: true)
            
        case (UserType.investor.rawValue,false):
            
            self.presenter?.HITAPI(api: Base.investorAllTokens.rawValue, params: nil, methodType: .GET, modelClass: TokenAssetsNewEntity.self, token: true)
            
        case (UserType.investor.rawValue,true):
            
            self.presenter?.HITAPI(api: Base.investorAssets.rawValue, params: nil, methodType: .GET, modelClass: TokenRequestModel.self, token: true)
            
        default:
            break
        }
        
        self.loader.isHidden = false
        
    }
    
}

//MARK: Button Action
extension ProductListViewController {
    @IBAction func productClikcEvent(_ sender: UIButton) {
        isTokenAssets = false
    }
    @IBAction func tokenAssetsClickEvent(_ sender: UIButton) {
        isTokenAssets = true
    }
}

//MARK: - Collection view delegate
extension ProductListViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
   
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == catogriesCollectionView {
            return catogries.count > 0 ? catogries.count : 0
        } else {
             return self.investerProductList?.count ?? 0
        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView ==  catogriesCollectionView {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: XIB.Names.CatogriesCell, for: indexPath) as! CatogriesCell
                cell.backgroundColor = .clear
            print(">>>>>>",catogries[indexPath.row])
            cell.catogriesLbl.text = nullStringToEmpty(string: catogries[indexPath.row])
           
            
            if nullStringToEmpty(string: catogries[indexPath.row]) == self.selectedCatogries {
                
                 cell.childBGView.backgroundColor = UIColor(hex: primaryColor)
            } else {
                 cell.childBGView.backgroundColor = UIColor.lightGray
            }
            
            return cell
            
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: XIB.Names.ProductListCell, for: indexPath) as! ProductListCell
                cell.backgroundColor = .clear
                
                cell.labelTitle.text = self.investerProductList?[indexPath.row].product_title?.uppercased()
                cell.labelValue.text = "\(deafaultCurrency) \(self.investerProductList?[indexPath.row].total_product_value ?? 0)"
            
            if self.investerProductList?[indexPath.row].request_deploy == 0 {
                 cell.labelProductAmount.text = " Admin Live "
            } else if self.investerProductList?[indexPath.row].request_deploy == 1 {
                 cell.labelProductAmount.text = " User Live "
            }
               
           
            let count = (self.investerProductList?[indexPath.row].investment_product_total ?? 0.0 ) / (self.investerProductList?[indexPath.row].total_product_value ?? 0)
            cell.progressBar.progress = Float(count)
            
            cell.enValueLbl.text = " $\(self.investerProductList?[indexPath.row].total_product_value ?? 0)"
                  let middle = (self.investerProductList?[indexPath.row].total_product_value ?? 0) / 2
            cell.middleValLbl.text = "$\(middle)"
            cell.startValueLbl.text = "$0"
             
                let url = "\(baseUrl)/\(self.investerProductList?[indexPath.row].product_image ?? "")"
               
                Cache.image(forUrl: url) { image in
                     
                     DispatchQueue.main.async {
                         cell.productImage.image = image != nil ? image : #imageLiteral(resourceName: "gold")
                     }
                }
                
                return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
   
        if collectionView ==  catogriesCollectionView {
           return CGSize(width: collectionView.frame.width / 4 , height: collectionView.frame.height)
        } else {
            return CGSize(width: collectionView.frame.width / 2 , height: 34 * collectionView.frame.height / 100)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView ==  catogriesCollectionView {
                return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
               } else {
                    return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            }
       
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == catogriesCollectionView {
            
            self.selectedCatogries = catogries[indexPath.row]
         
            
               print(">>>>catogriesEntity",catogriesEntity)
                      print(">>>>catogries",catogries)
            print(">>>>>self.selectedCatogries",self.selectedCatogries)
            for item in catogriesEntity {
                
                print(nullStringToEmpty(string: item.category_name))
                print(nullStringToEmpty(string: self.selectedCatogries))
                if nullStringToEmpty(string: item.category_name) == nullStringToEmpty(string: self.selectedCatogries) {
                    
                    print(">>>item.id",item.id)
                    selctedId = item.id ?? 0
                    break
                } else {
                    selctedId = 0
                }
            }

            
            if isTokenAssets == true {
                
                TokenURL = Base.investorAllTokens.rawValue + AppendUrlQuery.category.rawValue + "\(selctedId)" + AppendUrlQuery.min.rawValue + AppendUrlQuery.max.rawValue
                
                self.presenter?.HITAPI(api: nullStringToEmpty(string: TokenURL), params: nil, methodType: .GET, modelClass: TokenAssetsNewEntity.self, token: true)
            } else {
                
                 productURL  = Base.investorAllProducts.rawValue + AppendUrlQuery.category.rawValue + "\(selctedId)" + AppendUrlQuery.min.rawValue + AppendUrlQuery.max.rawValue
                  self.presenter?.HITAPI(api: nullStringToEmpty(string: productURL), params: nil, methodType: .GET, modelClass: ProductModelEntity.self, token: true)
            }
            
        } else {
            guard let vc = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.ProdDetailViewController) as? ProdDetailViewController else { return }
            vc.productID = (self.investerProductList?[indexPath.row].id)!
            vc.getProductDetails(id:self.investerProductList?[indexPath.row].id)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
}


//MARK:- UISearchBarDelegate

extension ProductListViewController : UISearchBarDelegate {
    
     func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        typedText = nullStringToEmpty(string: searchText)

       
        if isTokenAssets {
           
            self.investerTokenList?.filter({ nullStringToEmpty(string: $0.tokenname?.lowercased()).contains(searchText.lowercased())})
            self.tableView.reloadData()
        } else {
            self.investerProductList =   self.investerProductList?.filter({ nullStringToEmpty(string: $0.product_title?.lowercased()).contains(searchText.lowercased())})
            self.collectionView.reloadData()
        }
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.showsCancelButton = false
        searchBar.isHidden = true
        if isTokenAssets {
        self.investerTokenList = filterInvest
              } else {
        self.investerProductList =   filterProduct
                  self.collectionView.reloadData()
              }
        view.endEditingForce()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
           print("SEARCH GO>>>>>")
           if isTokenAssets {
            
            if typedText == "" {
                  self.investerTokenList = filterInvest
                  self.tableView.reloadData()
            } else {
                self.investerTokenList =   self.investerTokenList?.filter({ nullStringToEmpty(string: $0.tokenname).contains(typedText)})
                self.tableView.reloadData()
            }
            
            } else {
            
            
            if typedText == "" {
                             self.investerProductList = filterProduct
                             self.collectionView.reloadData()
                       } else {
                        self.investerProductList =   self.investerProductList?.filter({ nullStringToEmpty(string: $0.product_title?.lowercased()).contains(typedText)})
                      self.collectionView.reloadData()
                  }
       }
    }
}


//MARK: - UITableViewDelegate & UITableViewDataSource
extension ProductListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.investerTokenList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 18 * tableView.frame.height / 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: XIB.Names.TokenAssetsCell, for: indexPath) as! TokenAssetsCell
    
        cell.labelName.text = nullStringToEmpty(string: self.investerTokenList?[indexPath.row].tokenname)
        cell.labelCoinName.text = nullStringToEmpty(string: self.investerTokenList?[indexPath.row].tokensymbol)
    
        cell.backAssets.text = "Backed assets: " + "\(self.investerTokenList?[indexPath.row].tokenvalue ?? 0.0)"
        let url = URL.init(string: "\(baseUrl)/\(self.investerTokenList?[indexPath.row].token_image ?? "")")
        cell.assetsImg.sd_setImage(with: url , placeholderImage: nil)
        cell.buyButton.isHidden =  true //userType == UserType.campaigner.rawValue
        cell.investButton.isHidden = true//userType == UserType.campaigner.rawValue
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        
        return  cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
   
        guard let vc = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.ProductViewController) as? ProductViewController else { return }
        vc.productID = self.investerTokenList?[indexPath.row].tokenrequest?.id ?? 0
        vc.getProductDetails(id:self.investerTokenList?[indexPath.row].tokenrequest?.id)
            vc.isFromTokenRequest = false
        vc.tokenId = self.investerTokenList?[indexPath.row].id ?? 0
       
            self.navigationController?.pushViewController(vc, animated: true)
    }
}
  
extension ProductListViewController : PresenterOutputProtocol {
    
    func showSuccess(api: String, dataArray: [Mappable]?, dataDict: Mappable?, modelClass: Any) {
        self.loader.isHidden = true
        switch api {
            
        case Base.myProductList.rawValue,Base.investorAllProducts.rawValue,Base.investerProducts.rawValue, nullStringToEmpty(string: productURL):
            self.investerProductList?.removeAll()
            self.catogries.removeAll()
            self.catogriesEntity.removeAll()
            self.catogries.append("All")
            var productModelEntity = dataDict as? ProductModelEntity
            self.investerProductList = productModelEntity?.data ?? []
            self.catogriesEntity  = productModelEntity?.categories ?? []
            
            
            if productModelEntity?.categories?.count ?? 0 > 0 {
                
                for item in productModelEntity?.categories ?? [] {
                    
                    self.catogries.append(nullStringToEmpty(string: item.category_name))
                    
                }
            }
            
            
            print(">>>>catogriesEntity",catogriesEntity)
             print(">>>>catogries",catogries)
            
             filterProduct = self.investerProductList
           
            self.collectionView.reloadData()
            self.catogriesCollectionView.reloadData()
            
        case Base.tokenizedAssestList.rawValue,Base.investorAllTokens.rawValue,Base.investorAssets.rawValue, nullStringToEmpty(string: TokenURL) :
           
            self.investerTokenList?.removeAll()
            self.catogries.removeAll()
            self.catogriesEntity.removeAll()
            self.catogries.append("All")
            
            var TokenAssetsNewEntity = dataDict as? TokenAssetsNewEntity
            self.investerTokenList = TokenAssetsNewEntity?.data ?? []
            self.catogriesEntity   = TokenAssetsNewEntity?.categories ?? []
              
                       if TokenAssetsNewEntity?.categories?.count ?? 0 > 0 {
                                      for item in TokenAssetsNewEntity?.categories ?? [] {
                                          
                                          self.catogries.append(nullStringToEmpty(string: item.category_name))
                        }
                }
             filterInvest =  self.investerTokenList
            
            print(">>>>self.catogries",self.catogries)
            self.tableView.reloadData()
            self.catogriesCollectionView.reloadData()
            
        case nullStringToEmpty(string: queryUrl):
            
            self.investerTokenList?.removeAll()
                      self.catogries.removeAll()
                      self.catogriesEntity.removeAll()
             self.catogries.append("All")
            
            var TokenAssetsNewEntity = dataDict as? TokenAssetsNewEntity
            self.investerTokenList = TokenAssetsNewEntity?.data ?? []
            self.catogriesEntity   = TokenAssetsNewEntity?.categories ?? []
             
    
             if TokenAssetsNewEntity?.categories?.count ?? 0 > 0 {
                            for item in TokenAssetsNewEntity?.categories ?? [] {
                                
                                self.catogries.append(nullStringToEmpty(string: item.category_name))
                            }
                }
            
             filterInvest =  self.investerTokenList
                        
                         self.tableView.reloadData()
                           self.catogriesCollectionView.reloadData()
            
        case  nullStringToEmpty(string: queryUrlProduct):
            self.investerProductList?.removeAll()
                      self.catogries.removeAll()
                      self.catogriesEntity.removeAll()
             self.catogries.append("All")
          
                        print(">>>>catogries",catogries)
            
            
              var productModelEntity = dataDict as? ProductModelEntity
            
            print("....productModelEntity",productModelEntity)
                         self.investerProductList = productModelEntity?.data ?? []
            
               self.catogriesEntity   = productModelEntity?.categories ?? []
            print(">>>>productModelEntity?.categories",productModelEntity?.categories?.count)
                         if productModelEntity?.categories?.count ?? 0 > 0 {
                                        for item in productModelEntity?.categories ?? [] {
                                            
                                            self.catogries.append(nullStringToEmpty(string: item.category_name))
                                        }
                                    }
                                    
            
              filterProduct = self.investerProductList
            
           
            print(">>>>catogriesEntity",catogriesEntity)
            print(">>>>catogries",catogries)
                self.collectionView.reloadData()
               self.catogriesCollectionView.reloadData()
                         
            
        default:
           break
        }
        
    }
    
    func showError(error: CustomError) {
        
        self.loader.isHidden = true
              ToastManager.show(title:  nullStringToEmpty(string: error.localizedDescription.trimString()), state: .success)
        
    }
 
}

extension ProductListViewController: FilterDelegate {
    
    func didReceiveFilterData(tokenOrProduct: String,catogories: String, ids: Int, minValue: Double, maxValue: Double) {
        
        print(">>>",maxValue)
        print(">>>",minValue)
        print(">>>",catogories)
        print(">>>",ids)
        
        switch  nullStringToEmpty(string: tokenOrProduct) {
            
        case "token":
            
            self.loader.isHidden = false
            queryUrl = Base.investorAllTokens.rawValue
            queryUrl += ids == 0 ? AppendUrlQuery.category.rawValue + ""  : AppendUrlQuery.category.rawValue + "\(ids)"
            queryUrl += minValue == 0.0 ? AppendUrlQuery.min.rawValue + "" : AppendUrlQuery.min.rawValue + "\(minValue)"
            queryUrl += maxValue == 0.0 ? AppendUrlQuery.max.rawValue + "" : AppendUrlQuery.max.rawValue + "\(maxValue)"
            self.loader.isHidden = false
            self.presenter?.HITAPI(api: queryUrl , params: nil, methodType: .GET, modelClass: TokenAssetsNewEntity.self, token: true)
            
        case "product":
            
            queryUrlProduct = Base.investorAllProducts.rawValue
            queryUrlProduct += ids == 0 ? AppendUrlQuery.category.rawValue + ""  : AppendUrlQuery.category.rawValue + "\(ids)"
            queryUrlProduct += minValue == 0.0 ? AppendUrlQuery.min.rawValue + "" : AppendUrlQuery.min.rawValue + "\(minValue)"
            queryUrlProduct += maxValue == 0.0 ? AppendUrlQuery.max.rawValue + "" : AppendUrlQuery.max.rawValue + "\(maxValue)"
            self.loader.isHidden = false
            self.presenter?.HITAPI(api: queryUrlProduct, params: nil, methodType: .GET, modelClass: ProductModelEntity.self, token: true)
            
         default:
         break
     }
        
  }

}


