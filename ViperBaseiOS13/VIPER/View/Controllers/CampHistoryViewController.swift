//
//  CampHistoryViewController.swift
//  ViperBaseiOS13
//
//  Created by Deepika on 15/05/20.
//  Copyright © 2020 CSS. All rights reserved.
//

import UIKit
import ObjectMapper

class CampHistoryViewController: UIViewController {

    @IBOutlet weak var emptyuView: UIView!
    @IBOutlet weak var tableView: UITableView!
   
     @IBOutlet weak var titleLbl: UILabel!
    private lazy var loader  : UIView = {
                 return createActivityIndicator(self.view)
     }()
    let userType = UserDefaults.standard.value(forKey: UserDefaultsKey.key.isFromInvestor) as? String
    var sellHistoryDict : SellHistoryEntity?
    var historySell = [History]()
    
       
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
       tableView.delegate = self
             tableView.dataSource = self
             self.tableView.register(UINib.init(nibName: XIB.Names.HistoryCell, bundle: nil), forCellReuseIdentifier: XIB.Names.HistoryCell)
        titleLbl.text = Constants.string.history.localize().uppercased()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
       getSellhistory()
        
    }
    
    @IBAction func goBack(_ sender: UIButton) {
          self.navigationController?.popViewController(animated: true)
      }
}

//MARK: - UITableViewDelegate & UITableViewDataSource
extension CampHistoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.historySell.count > 0 ? historySell.count : 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: XIB.Names.HistoryCell, for: indexPath) as! HistoryCell
    
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
       
              cell.statusLbl.textColor = UIColor(hex: "#7bd235")
              
            
                  let entity = historySell[indexPath.row]
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
                
        return  cell
    }
}

//MARK: - PresenterOutputProtocol

extension CampHistoryViewController: PresenterOutputProtocol {
    
    func getSellhistory() {
        self.loader.isHidden = false
        self.presenter?.HITAPI(api: Base.sellHistory.rawValue, params: nil, methodType: .GET, modelClass: SellHistoryEntity.self, token: true)
    }
    
    
    func showSuccess(api: String, dataArray: [Mappable]?, dataDict: Mappable?, modelClass: Any) {
        
        switch api {
       
        case Base.sellHistory.rawValue:
            self.loader.isHidden = true
            self.sellHistoryDict = dataDict as? SellHistoryEntity
            self.historySell = self.sellHistoryDict?.history ?? []
            self.emptyuView.isHidden =  self.historySell.count > 0 ? true : false
            tableView.isHidden = self.historySell.count > 0 ? false : true
            tableView.reloadData()
            
        default:
            break
        }
    }
    
    func showError(error: CustomError) {
         self.loader.isHidden = true
         ToastManager.show(title:  nullStringToEmpty(string: error.localizedDescription.trimString()), state: .error)
    }
    
}
