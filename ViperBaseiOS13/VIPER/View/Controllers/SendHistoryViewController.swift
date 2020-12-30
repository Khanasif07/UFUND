//
//  SendHistoryViewController.swift
//  ViperBaseiOS13
//
//  Created by Deepika on 19/05/20.
//  Copyright © 2020 CSS. All rights reserved.
//

import UIKit
import ObjectMapper

class SendHistoryViewController: UIViewController {

    @IBOutlet weak var emptyuView: UIView!
    @IBOutlet weak var tableView: UITableView!
   
     @IBOutlet weak var titleLbl: UILabel!
    private lazy var loader  : UIView = {
                 return createActivityIndicator(self.view)
     }()
    let userType = UserDefaults.standard.value(forKey: UserDefaultsKey.key.isFromInvestor) as? String
    var sendEntity: SendEntity?
      var tokenList = [Transactions]()
    
       
    
    override func viewDidLoad() {
        super.viewDidLoad()

        overrideUserInterfaceStyle = .light
       tableView.delegate = self
             tableView.dataSource = self
             self.tableView.register(UINib.init(nibName: XIB.Names.HistoryCell, bundle: nil), forCellReuseIdentifier: XIB.Names.HistoryCell)
        titleLbl.text = Constants.string.history.localize().uppercased()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
       getSendhistory()
        
    }
    
    @IBAction func goBack(_ sender: UIButton) {
          self.navigationController?.popViewController(animated: true)
      }
}

//MARK: - UITableViewDelegate & UITableViewDataSource
extension SendHistoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.tokenList.count > 0 ? tokenList.count : 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: XIB.Names.HistoryCell, for: indexPath) as! HistoryCell
    
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
    
        cell.statusLbl.textColor = UIColor(hex: "#7bd235")
              
            
        let entity = tokenList[indexPath.row]
        cell.nameLbl.text = nullStringToEmpty(string: entity.get_token?.tokenname)

        cell.addressLbl.text = nullStringToEmpty(string: entity.txHash )
                 
        if entity.get_token?.status == 1 {
            cell.statusLbl.text = nullStringToEmpty(string: "Success")
        } else if entity.get_token?.status == 2 {
            cell.statusLbl.text = nullStringToEmpty(string: "Pending")
        } else {
            
            cell.statusLbl.text = nullStringToEmpty(string: "Failed")
        }
                  
                 
        let amount = String(entity.amount?.round(to: 6) ?? 0.0)

              
        cell.amountLbl.text = nullStringToEmpty(string: amount) + " " + nullStringToEmpty(string: entity.get_token?.tokensymbol)
         
        
                  let date = convertDateFormaterPost(nullStringToEmpty(string: entity.created_at))
                  cell.dateLbl.text = nullStringToEmpty(string: date)
                
        return  cell
    }
}

//MARK: - PresenterOutputProtocol

extension SendHistoryViewController: PresenterOutputProtocol {
    
    func getSendhistory() {
     self.loader.isHidden = false
        self.presenter?.HITAPI(api: Base.sendAPI.rawValue, params: nil, methodType: .GET, modelClass: SendEntity.self, token: true)
    }
    
    
    func showSuccess(api: String, dataArray: [Mappable]?, dataDict: Mappable?, modelClass: Any) {
        
        switch api {
       
       case Base.sendAPI.rawValue:
                 
                 self.loader.isHidden = true
                 self.sendEntity = dataDict as? SendEntity
                
                 tokenList = self.sendEntity?.transactions ?? []
                 emptyuView.isHidden = tokenList.count > 0 ? true : false
                 self.tableView.reloadData()

            
        default:
            break
        }
    }
    
    func showError(error: CustomError) {
         self.loader.isHidden = true
         ToastManager.show(title:  nullStringToEmpty(string: error.localizedDescription.trimString()), state: .error)
    }
    
}
