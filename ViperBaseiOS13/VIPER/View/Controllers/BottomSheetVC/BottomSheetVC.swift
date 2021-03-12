//
//  BottomSheetVC.swift
//  ViperBaseiOS13
//
//  Created by Admin on 01/03/21.
//  Copyright © 2021 CSS. All rights reserved.
//

//
//  BottomSheetViewController.swift
//  BottomSheet
//
//  Created by Ahmed Elassuty on 7/1/16.
//  Copyright © 2016 Ahmed Elassuty. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class BottomSheetVC: UIViewController {
    // holdView can be UIImageView instead
    //MARK:- OUTLETS
    //==============
    @IBOutlet weak var holdView: UIView!
    @IBOutlet weak var listingCollView: UICollectionView!
    @IBOutlet weak var bottomLayoutConstraint: NSLayoutConstraint!
    
    //MARK:- VARIABLE
    //================
    lazy var swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(closePullUp))
    var fullView: CGFloat {
//        return 70.0 + (textContainerHeight ?? 0.0)
        return 51.0 + UIApplication.shared.statusBarFrame.height
    }
    var textContainerHeight : CGFloat? {
        didSet{
            self.listingCollView.reloadData()
        }
    }
    var partialView: CGFloat {
//        return UIScreen.main.bounds.height - (265.0 + UIApplication.shared.statusBarFrame.height)
        return 163.0 + UIApplication.shared.statusBarFrame.height
    }
    var inversterImage :[UIImage] = [#imageLiteral(resourceName: "icCategoriesBg"),#imageLiteral(resourceName: "icProductWithBg"),#imageLiteral(resourceName: "icProductWithBg"),#imageLiteral(resourceName: "icTokenizedAssetBg"),#imageLiteral(resourceName: "icTokenizedAssetBg"),#imageLiteral(resourceName: "icTokenInvestmentBg"),#imageLiteral(resourceName: "icTokenInvestmentBg"),#imageLiteral(resourceName: "icEarningInCryptoBg"),#imageLiteral(resourceName: "icEarningInCryptoBg"),#imageLiteral(resourceName: "icCryptoCurrencyBg"),#imageLiteral(resourceName: "icCryptoCurrencyBg")]
    var campinerImage: [UIImage] = [#imageLiteral(resourceName: "add"),#imageLiteral(resourceName: "profile"),#imageLiteral(resourceName: "soild"), #imageLiteral(resourceName: "wallets"),#imageLiteral(resourceName: "vynil"),#imageLiteral(resourceName: "wallets")]
    var headerCount : [String]?
    var silderImage = [SilderImage]()
    var isFromCampainer = false {
        didSet {
            if isFromCampainer {
            headerCount = [Constants.string.add.localize(), Constants.string.profile.localize(), Constants.string.MyProducts.localize(),Constants.string.wallet.localize(), Constants.string.requests.localize(), Constants.string.send.localize()]
            }else{
                headerCount = [Constants.string.categories.localize(),Constants.string.allProduct.localize(), Constants.string.newProduct.localize(),Constants.string.newTokenizedAssets.localize(),Constants.string.allTokenizedAssets.localize(),Constants.string.myProductInvestMents.localize(),Constants.string.myTokenInvestMents.localize(),  Constants.string.earningInDollar.localize(),Constants.string.earningInCrypto.localize(),Constants.string.fiatCurrency.localize(),Constants.string.cryptoCurrency.localize()]
                
            }
        }
    }
    //MARK:- VIEW LIFE CYCLE
    //======================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard self.isMovingToParent else { return }
        UIView.animate(withDuration: 0.6, animations: { [weak self] in
            let frame = self?.view.frame
            let yComponent = self?.partialView
            self?.view.frame = CGRect(x: 0, y: yComponent!, width: frame!.width, height: frame!.height)
        })
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func rightButton(_ sender: AnyObject) {
        print("clicked")
    }
    
    @IBAction func close(_ sender: AnyObject) {
        UIView.animate(withDuration: 0.3, animations: {
            let frame = self.view.frame
            self.view.frame = CGRect(x: 0, y: self.partialView, width: frame.width, height: frame.height)
        })
    }
    
    @objc func panGesture(_ recognizer: UIPanGestureRecognizer) {
        
        let translation = recognizer.translation(in: self.view)
        let velocity = recognizer.velocity(in: self.view)
        let y = self.view.frame.minY
        if ( y + translation.y >= fullView) && (y + translation.y <= partialView ) {
            self.view.frame = CGRect(x: 0, y: y + translation.y, width: view.frame.width, height: view.frame.height)
            recognizer.setTranslation(CGPoint.zero, in: self.view)
        }
        
        if recognizer.state == .ended {
            var duration =  velocity.y < 0 ? Double((y - fullView) / -velocity.y) : Double((partialView - y) / velocity.y )
            
            duration = duration > 1.3 ? 1 : duration
            
            UIView.animate(withDuration: duration, delay: 0.0, options: [.allowUserInteraction], animations: {
                if  velocity.y >= 0 {
                    self.view.frame = CGRect(x: 0, y: self.partialView, width: self.view.frame.width, height: self.view.frame.height)
                    self.holdView.alpha = 1.0
                    self.listingCollView.alwaysBounceVertical = false
                } else {
                    self.view.frame = CGRect(x: 0, y: self.fullView, width: self.view.frame.width, height: self.view.frame.height)
                    self.holdView.alpha = 1.0
                    self.listingCollView.alwaysBounceVertical = true
                }
                
            }) { (completion) in
            }
        }
    }
    
    func roundViews() {
        holdView.layer.cornerRadius = 3
    }
}

//MARK:- Private functions
//========================
extension BottomSheetVC {
    
    private func initialSetup() {
        setupTableView()
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(BottomSheetVC.panGesture))
        view.addGestureRecognizer(gesture)
        roundViews()
        setupSwipeGesture()
    }
    
    private func setupTableView() {
        listingCollView.delegate = self
        listingCollView.dataSource = self
        let nibPost = UINib(nibName: XIB.Names.ProductsCollectionCell, bundle: nil)
        listingCollView.register(nibPost, forCellWithReuseIdentifier: XIB.Names.ProductsCollectionCell)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        listingCollView.collectionViewLayout = layout
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        listingCollView.alwaysBounceHorizontal = false
        listingCollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    private func setupSwipeGesture() {
        swipeDown.direction = .down
        swipeDown.delegate = self
        listingCollView.addGestureRecognizer(swipeDown)
    }
    
    @objc func closePullUp() {
        UIView.animate(withDuration: 0.3, animations: {
            let frame = self.view.frame
            self.view.frame = CGRect(x: 0, y: self.partialView, width: frame.width, height: frame.height)
            self.holdView.alpha = 1.0
        })
    }
}


//MARK:- Tableview delegates
//==========================
extension BottomSheetVC: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isFromCampainer ? campinerImage.count : inversterImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: XIB.Names.ProductsCollectionCell, for: indexPath) as! ProductsCollectionCell
        cell.productImg.image = isFromCampainer ?  campinerImage[indexPath.row] : inversterImage[indexPath.row]
        cell.productNameLbl.text = isFromCampainer ? nullStringToEmpty(string: headerCount?[indexPath.row]) : nullStringToEmpty(string: headerCount?[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 3 , height: 125.0)
        
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

//MARK:- Gesture Delegates
//========================
extension BottomSheetVC : UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        //Identify gesture recognizer and return true else false.
        if (!listingCollView.isDragging && !listingCollView.isDecelerating) {
            return gestureRecognizer.isEqual(self.swipeDown) ? true : false
        }
        return false
    }
}
