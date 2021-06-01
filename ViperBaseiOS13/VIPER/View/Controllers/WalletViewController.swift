//
//  WalletViewController.swift
//  ViperBaseiOS13
//
//  Created by Deepika on 26/11/19.
//  Copyright © 2019 CSS. All rights reserved.
//

import UIKit
import ObjectMapper
import SDWebImage

enum AssetsColor: String {
    
    case BLINKSTOCK
    case bitcoinColor
    case EthColor
    case euroColor
    case litecoinColor
    case rippleColor
    case fiatColor
    case wireColor
    case bitcoinCash
}

struct AssetsColorHex {

    static let BLINKSTOCK = "FCFCFC"
    static let bitcoinCash = "8dc351"
    static let fiat = "FFA900"
    static let wire = "7A86CB"
    static let bitcoin = "F69619"
    static let ethereum = "8C8C8C"
    static let ripple = "0A85E9"
    static let litecoin = "BEBEBE"
    static let  euro = "FFB400"
}

struct CoinSymbol {
   
    static let BLINKSTOCK = "BSTK"
    static let bitcoinCash = "BCH"
    static let fiat = "FIAT"
    static let wire = "WIRE"
    static let bitcoin = "BTC"
    static let ethereum = "ETH"
    static let ripple = "XRP"
    static let litecoin = "LTC"
    static let euro = "€"
    static let bankTransfer = "Bank Transfer"
    static let USD = "USD"
    
}

struct AssetsName {
    
    static let BLINKSTOCK = "Blink Stock"
    static let bitcoinCash = "Bitcoin cash"
    static let fiat = "Fiat"
    static let wire = "Wire"
    static let bitcoin = "Bitcoin"
    static let ethereum = "Ethereum"
    static let ripple = "Ripple"
    static let litecoin = "Litecoin"
    static let euro = "Euro"
    static let bankTransfer = "Bank Transfer"
    static let USD = "USD Wallet"
    
}

class WalletViewController: UIViewController {
    
   
    @IBOutlet weak var walletHistoryButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var walletAmountLbl: UILabel!
    @IBOutlet weak var yourWalletLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    private lazy var loader  : UIView = {
            return createActivityIndicator(self.view)
    }()
    var walletBalance: WalletBalance?
    var assets = [DataAssets]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getWalletDeatils()
        collectionView.delegate = self
        collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: XIB.Names.FundCell, bundle: nil), forCellWithReuseIdentifier: XIB.Names.FundCell)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical //.horizontal
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 15
        collectionView.setCollectionViewLayout(layout, animated: true)
        
        
      
        
        let button = UIButton(type: .custom)
        let image = UIImage(named: "historyIcon")?.withRenderingMode(.alwaysTemplate)
        walletHistoryButton.setImage(image, for: .normal)
        walletHistoryButton.tintColor = UIColor.black
    }
    
    
    
    @IBAction func walletHistoryClickEvent(_ sender: UIButton) {
        
        guard let vc = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.WalletHistoryViewController) as? WalletHistoryViewController else { return }
                              self.navigationController?.pushViewController(vc, animated: true)
        
    }
    @IBAction func refreshClickEvent(_ sender: UIButton) {
        getWalletDeatils()
      
    }
    
    @IBAction func goBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        localize()
        
    }
}

//MARK: - Localization
extension WalletViewController {
    
    func localize() {
        
        yourWalletLbl.text = Constants.string.yourWalletAmount.localize()
        yourWalletLbl.textColor = UIColor(hex: lightTextColor)
        walletAmountLbl.textColor = UIColor(hex: darkTextColor)
       
        titleLbl.text = Constants.string.wallet.localize().uppercased()
        titleLbl.textColor = UIColor(hex: darkTextColor)
    }
}




extension WalletViewController : PresenterOutputProtocol {
    
    func getWalletDeatils() {
        
       
        self.loader.isHidden = false
        self.presenter?.HITAPI(api: Base.wallet.rawValue, params: nil , methodType: .GET, modelClass: WalletBalance.self, token: true)
        
    }
    
    func showSuccess(api: String, dataArray: [Mappable]?, dataDict: Mappable?, modelClass: Any) {
        
        self.loader.isHidden = true
        self.walletBalance = dataDict as? WalletBalance
//        self.assets = self.walletBalance?.data ?? []
//        walletAmountLbl.text = "$" + String(self.walletBalance?.total_amount ?? 0.0)
       
        self.collectionView.reloadData()
    }
    
    func showError(error: CustomError) {
        
        self.loader.isHidden = true
        ToastManager.show(title:  nullStringToEmpty(string: error.localizedDescription.trimString()), state: .error)
    }
    
}

 
 
//MARK: UICollectionViewDelegate & UICollectionViewDataSource.
extension WalletViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        return assets.count > 0 ? assets.count : 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: XIB.Names.FundCell, for: indexPath) as! FundCell
       
        let entity = assets[indexPath.row]
        cell.coinName.text = nullStringToEmpty(string: entity.coin_name)
        let url = URL.init(string: baseUrl + "/" + nullStringToEmpty(string: entity.image))
        cell.img.sd_setImage(with: url , placeholderImage: nil)
        
//        if nullStringToEmpty(string: entity.coin_name) == "Ethereum" {
//            let ethBalance = String(self.walletBalance?.eth?.round(to: 6) ?? 0.0)
//                cell.balanceLbl.text = nullStringToEmpty(string: ethBalance)
//        } else if nullStringToEmpty(string: entity.coin_name) == "Bitcoin" {
//            let btcBalance = String(self.walletBalance?.btc?.round(to: 6) ?? 0.0)
//            cell.balanceLbl.text = nullStringToEmpty(string: btcBalance)
//        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
               let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
               let size:CGFloat = (collectionView.frame.size.width - space) / 2.0
               return CGSize(width: collectionView.frame.size.width, height: 60)
        
      
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
         let entity = assets[indexPath.row]
        let customAlertViewController = CryptoReceiveViewController(nibName: "CryptoReceiveViewController", bundle: nil)
        customAlertViewController.assets = entity
        customAlertViewController.providesPresentationContextTransitionStyle = true;
        customAlertViewController.definesPresentationContext = true;
        customAlertViewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        customAlertViewController.view.backgroundColor = UIColor(white: 0, alpha: 0.25)
        self.present(customAlertViewController, animated: false, completion: nil)
        
    }
}
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 

