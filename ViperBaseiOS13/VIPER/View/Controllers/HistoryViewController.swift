//
//  HistoryViewController.swift
//  ViperBaseiOS13
//
//  Created by Deepika on 15/05/20.
//  Copyright © 2020 CSS. All rights reserved.
//

import UIKit
import ObjectMapper

class HistoryViewController: UIViewController {

    @IBOutlet weak var emptyuView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var kycLbl: UILabel!
     @IBOutlet weak var profileLbl: UILabel!
     @IBOutlet weak var outerProfileView: UIView!
     @IBOutlet weak var profileInnerView: UIView!
     @IBOutlet weak var kycInnerView: UIView!
     @IBOutlet weak var kycOutterView: UIView!
     @IBOutlet weak var titleLbl: UILabel!
    private lazy var loader  : UIView = {
                 return createActivityIndicator(self.view)
     }()
    let userType = UserDefaults.standard.value(forKey: UserDefaultsKey.key.isFromInvestor) as? String
    var sellHistoryDict : SellHistoryEntity?
    var buyHistoty = [Buyhistory]()
    var investerHistory = [Invest_history]()
    var historySell = [History]()
    var buyInvertDict : BuyInvestHistory?
    
   var isSelectProfile = true {
           
           didSet {
               
               if isSelectProfile {
                   
                   profileInnerView.isHidden = true
                   
                   profileLbl.textColor = UIColor(hex: appBGColor)
                   kycLbl.textColor = UIColor(hex: darkTextColor)
                   kycInnerView.isHidden = false
                   emptyuView.isHidden = self.buyHistoty.count > 0 ? true : false
                    tableView.isHidden = self.buyHistoty.count > 0 ? false : true
                tableView.reloadData()
                   
               } else
               {
                   
                   profileInnerView.isHidden = false
                   profileLbl.textColor = UIColor(hex: darkTextColor)
                   kycLbl.textColor = UIColor(hex: appBGColor)
                   kycInnerView.isHidden = true
                   emptyuView.isHidden = self.investerHistory.count > 0 ? true : false
                  tableView.isHidden = self.investerHistory.count > 0 ? false : true
                tableView.reloadData()
               }
           }
       }
    
    @IBAction func profileClickEvent(_ sender: UIButton) {
           isSelectProfile = true
       }
       
       @IBAction func kycClickEvent(_ sender: UIButton) {
           isSelectProfile = false
       
       }
       
    
    override func viewDidLoad() {
        super.viewDidLoad()

        overrideUserInterfaceStyle = .light
        isSelectProfile = true
        titleLbl.text = Constants.string.history.localize().uppercased()
        profileLbl.text = Constants.string.buy.localize().uppercased()
        kycLbl.text = Constants.string.invest.localize().uppercased()
        kycOutterView.setGradientBackgroundForView()
        outerProfileView.setGradientBackgroundForView()
        
        profileInnerView.backgroundColor = UIColor(hex: appBGColor)
        kycInnerView.backgroundColor = UIColor(hex: appBGColor)
        
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.register(UINib.init(nibName: XIB.Names.HistoryCell, bundle: nil), forCellReuseIdentifier: XIB.Names.HistoryCell)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
       gethistory()
        
    }
    
    @IBAction func goBack(_ sender: UIButton) {
          self.navigationController?.popViewController(animated: true)
      }
}


//MARK: - PresenterOutputProtocol

extension HistoryViewController: PresenterOutputProtocol {
    
    func getSellhistory() {
        self.loader.isHidden = false
        self.presenter?.HITAPI(api: Base.sellHistory.rawValue, params: nil, methodType: .GET, modelClass: SellHistoryEntity.self, token: true)
    }
    
    func gethistory() {
           self.loader.isHidden = false
           self.presenter?.HITAPI(api: Base.buyandinvesthistory.rawValue, params: nil, methodType: .GET, modelClass: BuyInvestHistory.self, token: true)
       }
    
   
    func showSuccess(api: String, dataArray: [Mappable]?, dataDict: Mappable?, modelClass: Any) {
        
        switch api {
       
        case Base.sellHistory.rawValue:
            self.loader.isHidden = true
            self.sellHistoryDict = dataDict as? SellHistoryEntity
            self.historySell = self.sellHistoryDict?.history ?? []
         
        case Base.buyandinvesthistory.rawValue:
            self.loader.isHidden = true
            self.buyInvertDict = dataDict as? BuyInvestHistory
            self.buyHistoty = self.buyInvertDict?.buyhistory ?? []
            self.investerHistory = self.buyInvertDict?.invest_history ?? []
    
            isSelectProfile = true
            
           
            
        default:
            break
        }
    }
    
    func showError(error: CustomError) {
         self.loader.isHidden = true
         ToastManager.show(title:  nullStringToEmpty(string: error.localizedDescription.trimString()), state: .error)
    }
    
}


//MARK: - UITableViewDelegate & UITableViewDataSource
extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSelectProfile {
            return self.buyHistoty.count > 0 ? buyHistoty.count : 0
        } else {
            return self.investerHistory.count > 0 ? investerHistory.count : 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: XIB.Names.HistoryCell, for: indexPath) as! HistoryCell
    
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.statusLbl.textColor = UIColor(hex: "#7bd235")
        
        if isSelectProfile {
            let entity = buyHistoty[indexPath.row]
            cell.nameLbl.text = nullStringToEmpty(string: entity.type)
            
            if entity.tx_hash != nil {
                     cell.addressLbl.text = nullStringToEmpty(string: entity.tx_hash)
            } else {
                     cell.addressLbl.text = nullStringToEmpty(string: entity.via)
            }
            
       
            cell.statusLbl.text = nullStringToEmpty(string: entity.status)
            var payment : String?
            let btc = entity.btc_amount ?? 0.0
            let eth = entity.eth_amount ?? 0.0
            
            if  btc > 0.0 {
                payment = String(btc.round(to: 6))
            } else if eth > 0.0 {
                payment = String(eth.round(to: 6))
            } else {
                payment = String(entity.amount?.round(to: 6) ?? 0.0)
                
            }
            
            
            if  entity.payment_type != nil {
                 cell.amountLbl.text = nullStringToEmpty(string: payment) + " " + nullStringToEmpty(string: entity.payment_type)
            } else {
                 cell.amountLbl.text = nullStringToEmpty(string: payment) + " " + nullStringToEmpty(string: entity.type)
            }
            
           
            let date = convertDateFormaterPost(nullStringToEmpty(string: entity.created_at))
            cell.dateLbl.text = nullStringToEmpty(string: date)
            

        } else {
            let entity = investerHistory[indexPath.row]
            cell.nameLbl.text = nullStringToEmpty(string: entity.type)
            cell.addressLbl.text = nullStringToEmpty(string: entity.via)
            cell.statusLbl.text = nullStringToEmpty(string: entity.status)
            var payment : String?
            let btc = entity.btc_amount ?? 0.0
            let eth = entity.eth_amount ?? 0.0
            
            if  btc > 0.0 {
                payment = String(btc)
            } else if eth > 0.0 {
                payment = String(eth)
            } else {
                payment = String(entity.amount ?? 0.0)
                
            }
            
            cell.amountLbl.text = nullStringToEmpty(string: payment) + " " + nullStringToEmpty(string: entity.payment_type)
              let date = convertDateFormaterPost(nullStringToEmpty(string: entity.created_at))
                      cell.dateLbl.text = nullStringToEmpty(string: date)
            
        }
        return  cell
    }
}

public func convertDateFormaterPost(_ date: String) -> String {
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let date = dateFormatter.date(from: date)
    dateFormatter.dateFormat = "MMM d,yyyy hh:mm a"
    return  dateFormatter.string(from: date!)

}
