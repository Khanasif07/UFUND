//
//  HomeViewController.swift
//  ViperBaseiOS13
//
//  Created by Deepika on 22/11/19.
//  Copyright © 2019 CSS. All rights reserved.
//

import UIKit
import SDWebImage
import KWDrawerController
import ObjectMapper

class HomeAssetsCell: UITableViewCell {
    
    @IBOutlet weak var labelCount: UILabel!
    
    @IBOutlet weak var labelTitle: UILabel!
    
    @IBOutlet weak var labelStatus: UILabel!
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }
}

class HomeViewController: UIViewController
{
    
    @IBOutlet weak var rightSilderButton: UIButton!
    @IBOutlet weak var leftSilderButton: UIButton!
    private lazy var loader  : UIView =
    {
        return createActivityIndicator(self.view)
    }()
    @IBOutlet weak var campImgBG: UIImageView!
    @IBOutlet weak var collectionScrollView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var campainerView: UIView!
    @IBOutlet weak var viewSideMenu: UIView!
 
    @IBOutlet weak var collectionGridView: UICollectionView!
    var headerCount : [String]?
    var silderImage = [SilderImage]()
    var isFromCampainer = false
    {
        didSet
        {
            if isFromCampainer
            {
                
                campainerView.isHidden = false
                headerCount = [Constants.string.add.localize(), Constants.string.profile.localize(), Constants.string.MyProducts.localize(),Constants.string.wallet.localize(), Constants.string.requests.localize(), Constants.string.send.localize()]
                
            }else
            {
                
                campainerView.isHidden = true
                headerCount = [Constants.string.allProduct.localize(), Constants.string.newProduct.localize(), Constants.string.categories.localize(),Constants.string.productInvestMent.localize(),Constants.string.tokenInvestMent.localize(),  Constants.string.newTokenizedAssets.localize(),Constants.string.allTokenizedAssets.localize(),Constants.string.earningInDollar.localize(),Constants.string.earningInCrypto.localize(),Constants.string.fiatCurrency.localize(),Constants.string.cryptoCurrency.localize()]
                
            }
            
        }
    }
    
    var listCollectionHeight : CGFloat = 130
    var inversterImage :[UIImage] = [#imageLiteral(resourceName: "icProductWithBg"),#imageLiteral(resourceName: "icProductWithBg"),#imageLiteral(resourceName: "icCategoriesBg"),#imageLiteral(resourceName: "icTokenInvestmentBg"),#imageLiteral(resourceName: "icTokenInvestmentBg"),#imageLiteral(resourceName: "icTokenizedAssetBg"),#imageLiteral(resourceName: "icTokenizedAssetBg"),#imageLiteral(resourceName: "icEarningInCryptoBg"),#imageLiteral(resourceName: "icEarningInCryptoBg"),#imageLiteral(resourceName: "icCryptoCurrencyBg"),#imageLiteral(resourceName: "icCryptoCurrencyBg")]
//    var inversterImage :[UIImage] = [#imageLiteral(resourceName: "soild"),#imageLiteral(resourceName: "profile"),#imageLiteral(resourceName: "inverstors"),#imageLiteral(resourceName: "wallets"),#imageLiteral(resourceName: "coins"), #imageLiteral(resourceName: "wallets")]
    var campinerImage: [UIImage] = [#imageLiteral(resourceName: "add"),#imageLiteral(resourceName: "profile"),#imageLiteral(resourceName: "soild"), #imageLiteral(resourceName: "wallets"),#imageLiteral(resourceName: "vynil"),#imageLiteral(resourceName: "wallets")]
    var timer: Timer?
    var approvalObject : ApprovalModel?
    let dispatchGroup = DispatchGroup()
    
    @IBOutlet weak var bgViewScroll: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad() 
        
        overrideUserInterfaceStyle = .light
        
        self.viewSideMenu.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.sideMenuAction)))
        self.viewSideMenu.makeRoundedCorner()
       
        bgViewScroll.backgroundColor = UIColor(hex: primaryColor)
        
        let nibPost = UINib(nibName: XIB.Names.GridCell, bundle: nil)
        
        collectionGridView.register(nibPost, forCellWithReuseIdentifier: XIB.Names.GridCell)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionGridView.collectionViewLayout = layout
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionGridView.alwaysBounceHorizontal = false
        collectionGridView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionGridView.delegate = self
        collectionGridView.dataSource = self
        
        let nibPost1 = UINib(nibName: XIB.Names.ProductsCollectionCell, bundle: nil)
        collectionScrollView.register(nibPost1, forCellWithReuseIdentifier: XIB.Names.ProductsCollectionCell)
        let layout1 = UICollectionViewFlowLayout()
        layout1.scrollDirection = .vertical
        collectionScrollView.collectionViewLayout = layout1
        
        layout1.minimumInteritemSpacing = 0
        layout1.minimumLineSpacing = 0
        collectionScrollView.alwaysBounceHorizontal = false
   
        collectionScrollView.delegate = self
        collectionScrollView.dataSource = self
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.bgViewScroll.roundCorners([.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: 15)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if let isFromCamp = UserDefaults.standard.value(forKey: UserDefaultsKey.key.isFromInvestor) as? String {
            switch  isFromCamp
            {
            case UserType.investor.rawValue:
                isFromCampainer = false
                getInvesterSilderImage(isLoaderHidden: true)
            default:
                isFromCampainer = true
                getApprovals()
                getInvesterSilderImageCamp(isLoaderHidden: true)
                dispatchGroup.notify(queue: .main) {
                    
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        if timer?.isValid ?? true {
             timer?.invalidate()
        }
    }
    
    func startTimer(){
        
        timer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(self.scrollAutomatically), userInfo: nil, repeats: true)
        
    }
    
    @IBAction private func sideMenuAction()
    {
        
        self.drawerController?.openSide(.left)
        self.viewSideMenu.addPressAnimation()
        
    }
    
    
    @objc func scrollAutomatically(_ timer1: Timer)
    {
        
        print(">>>>>>.callingggggg")
        scrollToNextCell()
        
    }
    
    @IBAction func moveAfterClickEvent(_ sender: UIButton) {
        
        let indexpath = IndexPath(item: silderImage.count - 1, section: 0)
        collectionGridView.scrollToItem(at: indexpath, at: .centeredHorizontally, animated: true)
        
    }
    
    @IBAction func moveBeforeClickEvent(_ sender: UIButton)
    {
        
        let indexpath = IndexPath(item: 0, section: 0)
        collectionGridView.scrollToItem(at: indexpath, at: .centeredHorizontally, animated: true)
        
        
    }
    
    func scrollToNextCell(){
        //get cell size
        
        let cellSize = view.frame.size
        let contentOffset = collectionGridView.contentOffset
        if collectionGridView.contentSize.width <= collectionGridView.contentOffset.x + cellSize.width
        {
            let r = CGRect(x: 0, y: contentOffset.y, width: cellSize.width, height: cellSize.height)
            collectionGridView.scrollRectToVisible(r, animated: true)
            
        }else
        {
            let r = CGRect(x: contentOffset.x + cellSize.width, y: contentOffset.y, width: cellSize.width, height: cellSize.height)
            collectionGridView.scrollRectToVisible(r, animated: true);
            
        }
        
    }
}

extension HomeViewController {
  
    @IBAction func menuOpener(_ sender: UIButton)
    {
        guard let vc = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.SideMenuController) as? SideMenuController else { return }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - Collection view delegate
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
       
        return 1
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        if collectionView == collectionGridView {
           
            return silderImage.count > 0 ? silderImage.count : 0
            
        } else
        {
            
//            if isFromCampainer {
//                return campinerImage.count
//            } else {
//                return inversterImage.count
//            }
            
     
            return isFromCampainer ? campinerImage.count : inversterImage.count
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        if collectionView == collectionGridView
        {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: XIB.Names.GridCell, for: indexPath) as! GridCell
            cell.backgroundColor = .clear
            let entity = silderImage[indexPath.row]
//            let url = URL.init(string: storageUrl + nullStringToEmpty(string: entity.image))
            cell.webImgView.sd_setImage(with: nil , placeholderImage: #imageLiteral(resourceName: "imgBg"))
            cell.decriptionLbl.text = nullStringToEmpty(string: entity.description)
            cell.readyLbl.text = nullStringToEmpty(string: entity.title)
            return cell
            
        } else
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: XIB.Names.ProductsCollectionCell, for: indexPath) as! ProductsCollectionCell
                cell.backgroundColor = .clear
                cell.productImg.image = isFromCampainer ?  campinerImage[indexPath.row] : inversterImage[indexPath.row]
                cell.productNameLbl.text = isFromCampainer ? nullStringToEmpty(string: headerCount?[indexPath.row]) : nullStringToEmpty(string: headerCount?[indexPath.row])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == collectionGridView
        {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
            
        } else
        {
            return CGSize(width: collectionView.frame.width / 3 , height: collectionView.frame.height / 2)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
    {
        
        
        
        
        
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == collectionGridView {
            //let cell = collectionView.cellForItem(at: IndexPath(row: indexPath.row, section: 0)) as? GridCell
            
        } else {
            let cell = collectionView.cellForItem(at: IndexPath(row: indexPath.row, section: 0)) as? ProductsCollectionCell
            
            
            if isFromCampainer {
                
                switch nullStringToEmpty(string: cell?.productNameLbl.text) {
                case Constants.string.add.localize():
                    guard let vc = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.AddAssetsViewController) as? AddAssetsViewController else { return }
                    self.navigationController?.pushViewController(vc, animated: true)
                case Constants.string.MyProducts.localize():
                    guard let vc = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.TokenProductViewController) as? TokenProductViewController else { return }
                      vc.tileStr = Constants.string.my.localize()
                
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                case Constants.string.profile.localize():
                    guard let vc = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.EditProfileViewController) as? EditProfileViewController else { return }
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                case Constants.string.wallet.localize():
                    guard let vc = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.WalletViewController) as? WalletViewController else { return }
                    self.navigationController?.pushViewController(vc, animated: true)
                case Constants.string.send.localize():
                    guard let vc = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.SendViewController) as? SendViewController else { return }
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                    
                case Constants.string.requests.localize():
                    
                    guard let vc = Router.main.instantiateViewController(identifier: Storyboard.Ids.TokenRequestViewController) as? TokenRequestViewController else { return }
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                default:
                    break
                }
                
            } else {
                
                switch nullStringToEmpty(string: cell?.productNameLbl.text) {
                case Constants.string.allProduct.localize():
                    let vc = AllProductsVC.instantiate(fromAppStoryboard: .Products)
                    vc.productTitle = Constants.string.allProducts.localize()
                    vc.productType = .AllProducts
                    self.navigationController?.pushViewController(vc, animated: true)
                case Constants.string.newProduct.localize():
                    let vc = AllProductsVC.instantiate(fromAppStoryboard: .Products)
                    vc.productTitle = Constants.string.newProducts.localize()
                    vc.productType = .NewProducts
                    self.navigationController?.pushViewController(vc, animated: true)
                case Constants.string.newTokenizedAssets.localize():
                    let vc = TokenizedAssetsVC.instantiate(fromAppStoryboard: .Products)
                    vc.productTitle = Constants.string.newTokenizedAssets.localize()
                    vc.productType = .NewAssets
                    self.navigationController?.pushViewController(vc, animated: true)
                case Constants.string.allTokenizedAssets.localize():
                    let vc = TokenizedAssetsVC.instantiate(fromAppStoryboard: .Products)
                    vc.productTitle = Constants.string.allTokenizedAssets.localize()
                    vc.productType = .AllAssets
                    self.navigationController?.pushViewController(vc, animated: true)
                case Constants.string.investment.localize():
                    guard let vc = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.InvestmentListViewController) as? InvestmentListViewController else { return }
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                case Constants.string.MyProducts.localize():
                    guard let vc = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.TokenProductViewController) as? TokenProductViewController else { return }
                    vc.tileStr = Constants.string.my.localize()
                    vc.toInvestesrAllProducts = true

                    self.navigationController?.pushViewController(vc, animated: true)
                    
                case Constants.string.profile.localize():
                    guard let vc = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.UserProfileVC) as? UserProfileVC else { return }
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                case  Constants.string.categories.localize():
                     guard let vc = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.CategoriesVC) as? CategoriesVC else { return }
                   self.navigationController?.pushViewController(vc, animated: true)
                    
                case Constants.string.wallet.localize():
                    guard let vc = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.WalletViewController) as? WalletViewController else { return }
                    self.navigationController?.pushViewController(vc, animated: true)
                 case Constants.string.send.localize():
                                  guard let vc = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.SendViewController) as? SendViewController else { return }
                                  self.navigationController?.pushViewController(vc, animated: true)
                    
                case Constants.string.tokenRequests.localize():
                    
                    guard let vc = Router.main.instantiateViewController(identifier: Storyboard.Ids.TokenRequestViewController) as? TokenRequestViewController else { return }
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                default:
                    break
                }
                
            }
        }
        
    }
}


extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 17 * tableView.frame.height / 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: XIB.Names.HomeAssetsCell, for: indexPath) as! HomeAssetsCell
        
        switch indexPath.row {
        case 0:
            cell.labelTitle.text = "No of products listed"
            cell.labelStatus.text = "Already approved"
            cell.labelCount.text = "\(self.approvalObject?.total_approve_product ?? 0)"
            
        case 1:
            
            cell.labelTitle.text = "No of products Request"
            cell.labelStatus.text = "Yet to be approved"
            cell.labelCount.text = "\(self.approvalObject?.total_product_request ?? 0)"
            
        case 2:
            
            cell.labelTitle.text = "No of assets listed"
            cell.labelStatus.text = "Already approved"
            cell.labelCount.text = "\(self.approvalObject?.total_approve_token ?? 0)"
                
        case 3:
            
            cell.labelTitle.text = "No of assets Request"
            cell.labelStatus.text = "Yet to be approved"
            cell.labelCount.text = "\(self.approvalObject?.total_request_token ?? 0)"
            
        
        default:
            cell.labelTitle.text = "--"
            cell.labelStatus.text = "--"
            cell.labelCount.text = "--"
        }

        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        return cell
        
    }
    
}


//MARK: - PresenterOutputProtocol

extension HomeViewController: PresenterOutputProtocol {
    
    func getInvesterSilderImage(isLoaderHidden: Bool = false) {
        self.loader.isHidden = isLoaderHidden
        self.presenter?.HITAPI(api: Base.sliderimages.rawValue, params: nil, methodType: .GET, modelClass: SilderImage.self, token: true)
    }
    
    func getInvesterSilderImageCamp(isLoaderHidden: Bool = false) {
        self.loader.isHidden = isLoaderHidden
        self.presenter?.HITAPI(api: Base.sliderimagesCamp.rawValue, params: nil, methodType: .GET, modelClass: SilderImage.self, token: true)
    }
    
    
    func getApprovals()
    {
         //self.loader.isHidden = false
       
         self.presenter?.HITAPI(api: Base.approvals.rawValue, params: nil, methodType: .GET, modelClass: ApprovalModel.self, token: true)
        
    }
    
    func showSuccess(api: String, dataArray: [Mappable]?, dataDict: Mappable?, modelClass: Any) {
        
        switch api
        {
           
        case Base.sliderimages.rawValue:
        self.loader.isHidden = true
        self.silderImage = dataArray as? [SilderImage] ?? []
        self.collectionGridView.reloadData()
        if self.silderImage.count == 1 || self.silderImage.count == 0 {
            rightSilderButton.isHidden = true
            leftSilderButton.isHidden = true
            
        }
        else
        {
            rightSilderButton.isHidden = false
            leftSilderButton.isHidden = false
            startTimer()
        }
            
        case Base.approvals.rawValue:
            self.loader.isHidden = true
            self.approvalObject = dataDict as? ApprovalModel 
            self.tableView.reloadData()
          case Base.sliderimagesCamp.rawValue:
            self.loader.isHidden = true
            self.silderImage = dataArray as? [SilderImage] ?? []
            
            let url = URL.init(string: storageUrl + nullStringToEmpty(string: silderImage.first?.image))
            self.campImgBG.sd_setImage(with: url , placeholderImage: nil)
            
        default:
            break
        }
    }
    
    func showError(error: CustomError) {
         self.loader.isHidden = true
         ToastManager.show(title:  nullStringToEmpty(string: error.localizedDescription.trimString()), state: .error)
    }
}
