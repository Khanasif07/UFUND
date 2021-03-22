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


class HomeViewController: UIViewController{
    
    @IBOutlet weak var investorTitleLbl: UILabel!
    @IBOutlet weak var investorDesclbl: UILabel!
    @IBOutlet weak var investorHeaderView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var viewSideMenu: UIView!
    @IBOutlet weak var collectionGridView: UICollectionView!
    
    
    
    var headerCount : [(String,UIColor)]?
    var silderImage = [SilderImage]()
    private lazy var loader  : UIView =
        {
            return createActivityIndicator(self.view)
        }()
    var inversterImage :[UIImage] = [#imageLiteral(resourceName: "icCategoriesBg"),#imageLiteral(resourceName: "icProductWithBg"),#imageLiteral(resourceName: "icProductWithBg"),#imageLiteral(resourceName: "icTokenizedAssetBg"),#imageLiteral(resourceName: "icTokenizedAssetBg"),#imageLiteral(resourceName: "icTokenInvestmentBg"),#imageLiteral(resourceName: "icTokenInvestmentBg"),#imageLiteral(resourceName: "icEarningInCryptoBg"),#imageLiteral(resourceName: "icEarningInCryptoBg"),#imageLiteral(resourceName: "icCryptoCurrencyBg"),#imageLiteral(resourceName: "icCryptoCurrencyBg")]
    var campinerImage: [UIImage] = [#imageLiteral(resourceName: "add"),#imageLiteral(resourceName: "profile"),#imageLiteral(resourceName: "soild"), #imageLiteral(resourceName: "wallets"),#imageLiteral(resourceName: "vynil"),#imageLiteral(resourceName: "wallets")]
    var isFromCampainer = false {
        didSet {
            if isFromCampainer {
                self.headerCount = [(Constants.string.send.localize(),#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)),(Constants.string.add.localize(),#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)),(Constants.string.profile.localize(),#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)),(Constants.string.MyProducts.localize(),#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)),(Constants.string.wallet.localize(),#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)),(Constants.string.requests.localize(),#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))]
            }else{
                self.headerCount = [(Constants.string.categories.localize(),#colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)),(Constants.string.allProduct.localize(),#colorLiteral(red: 0.4140953777, green: 0.6343216272, blue: 1, alpha: 1)), (Constants.string.newProduct.localize(),#colorLiteral(red: 0.4140953777, green: 0.6343216272, blue: 1, alpha: 1)),(Constants.string.newTokenizedAssets.localize(),#colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)),(Constants.string.allTokenizedAssets.localize(),#colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)),(Constants.string.myProductInvestMents.localize(),#colorLiteral(red: 0.753563848, green: 1, blue: 0.9789182867, alpha: 1)),(Constants.string.myTokenInvestMents.localize(),#colorLiteral(red: 0.753563848, green: 1, blue: 0.9789182867, alpha: 1)),  (Constants.string.earningInDollar.localize(),#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)),(Constants.string.earningInCrypto.localize(),#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)),(Constants.string.fiatCurrency.localize(),#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)),(Constants.string.cryptoCurrency.localize(),#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))]
            }
        }
    }
    
    var listCollectionHeight : CGFloat = 130
    var timer: Timer?
    var approvalObject : ApprovalModel?
    let dispatchGroup = DispatchGroup()
//    let bottomSheetVC = BottomSheetVC()
    
    override func viewDidLoad() {
        super.viewDidLoad() 
        self.initialSetup()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.layoutIfNeeded()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //        self.addBottomSheetView()
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
    
    @IBAction func menuOpener(_ sender: UIButton){
        self.drawerController?.openSide(.left)
        self.viewSideMenu.addPressAnimation()
    }
    
    private func setupTableView() {
        collectionGridView.delegate = self
        collectionGridView.dataSource = self
        let nibPost = UINib(nibName: XIB.Names.ProductsCollectionCell, bundle: nil)
        collectionGridView.register(nibPost, forCellWithReuseIdentifier: XIB.Names.ProductsCollectionCell)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionGridView.collectionViewLayout = layout
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionGridView.alwaysBounceHorizontal = false
        collectionGridView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

extension HomeViewController {
    private func initialSetup(){
        self.setupTableView()
    }
}

//MARK: - Collection view delegate
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isFromCampainer ? campinerImage.count : inversterImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: XIB.Names.ProductsCollectionCell, for: indexPath) as! ProductsCollectionCell
        cell.productImg.image = isFromCampainer ?  campinerImage[indexPath.row] : inversterImage[indexPath.row]
        cell.productNameLbl.text = isFromCampainer ? nullStringToEmpty(string: headerCount?[indexPath.row].0) : nullStringToEmpty(string: headerCount?[indexPath.row].0)
        cell.dataContainerView.backgroundColor = isFromCampainer ?  headerCount?[indexPath.row].1 : headerCount?[indexPath.row].1
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 2 , height: 200.0)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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
                
                if #available(iOS 13.0, *) {
                    guard let vc = Router.main.instantiateViewController(identifier: Storyboard.Ids.TokenRequestViewController) as? TokenRequestViewController else { return }
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    let vc = TokenRequestViewController.instantiate(fromAppStoryboard: .Main)
                    self.navigationController?.pushViewController(vc, animated: true)
                    // Fallback on earlier versions
                }
                
                
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
            case Constants.string.myProductInvestMents.localize():
                let vc = MyInvestmentVC.instantiate(fromAppStoryboard: .Products)
                vc.investmentType = .MyProductInvestment
                vc.productTitle = Constants.string.myProductInvestMents.localize()
                self.navigationController?.pushViewController(vc, animated: true)
            case Constants.string.myTokenInvestMents.localize():
                let vc = MyInvestmentVC.instantiate(fromAppStoryboard: .Products)
                vc.investmentType = .MyTokenInvestment
                vc.productTitle = Constants.string.myTokenInvestMents.localize()
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
                
                if #available(iOS 13.0, *) {
                    guard let vc = Router.main.instantiateViewController(identifier: Storyboard.Ids.TokenRequestViewController) as? TokenRequestViewController else { return }
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    // Fallback on earlier versions
                    let vc = TokenRequestViewController.instantiate(fromAppStoryboard: .Main)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
                
            default:
                break
            }
            
        }
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
            self.investorDesclbl.text = nullStringToEmpty(string: silderImage.first?.description)
            self.investorTitleLbl.text = nullStringToEmpty(string: silderImage.first?.title)
//            self.bottomSheetVC.textContainerHeight = investorHeaderView.frame.height
            //        self.collectionGridView.reloadData()
            if self.silderImage.count == 1 || self.silderImage.count == 0 {
                //            rightSilderButton.isHidden = true
                //            leftSilderButton.isHidden = true
                
            }
            else
            {
                //            rightSilderButton.isHidden = false
                //            leftSilderButton.isHidden = false
//                startTimer()
            }
            
        case Base.approvals.rawValue:
            self.loader.isHidden = true
            self.approvalObject = dataDict as? ApprovalModel 
        //            self.tableView.reloadData()
        case Base.sliderimagesCamp.rawValue:
            self.loader.isHidden = true
            self.silderImage = dataArray as? [SilderImage] ?? []
            
            let url = URL.init(string: storageUrl + nullStringToEmpty(string: silderImage.first?.image))
        //            self.campImgBG.sd_setImage(with: url , placeholderImage: nil)
        
        default:
            break
        }
    }
    
    func showError(error: CustomError) {
        self.loader.isHidden = true
        ToastManager.show(title:  nullStringToEmpty(string: error.localizedDescription.trimString()), state: .error)
    }
}
