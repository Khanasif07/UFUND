//
//  NotificationVC.swift
//  ViperBaseiOS13
//
//  Created by Admin on 27/08/21.
//  Copyright © 2021 CSS. All rights reserved.
//

import UIKit
import ObjectMapper

class NotificationVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLbl: UILabel!
    
    private lazy var loader  : UIView =
    {
                   return createActivityIndicator(self.view)
       }()
    
    var notificationList : [NotificationList]?
    
    let userType = UserDefaults.standard.value(forKey: UserDefaultsKey.key.isFromInvestor) as? String
    var url = String()

    override func viewDidLoad()
    {
        
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.register(UINib.init(nibName: XIB.Names.NotificationCell, bundle: nil), forCellReuseIdentifier: XIB.Names.NotificationCell)
//        titleLbl.textColor = UIColor(hex: darkTextColor)
        titleLbl.text = Constants.string.Notification.localize()
        getNotificationList()
    }

    
    @IBAction func goBack(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    private func getNotificationList()
    {
        
       let user = userType == UserType.campaigner.rawValue ? "campaigner" : "investor"
        url = "\(Base.notificationList.rawValue)?user_type=\(user)"
        self.presenter?.HITAPI(api: url, params: nil, methodType: .GET, modelClass: NotificationList.self, token: true)
        self.loader.isHidden = false
        
    }

}

//MARK: - UITableViewDelegate & UITableViewDataSource
extension NotificationVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.notificationList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: XIB.Names.NotificationCell, for: indexPath) as! NotificationCell
        cell.ttileLbl.text = self.notificationList?[indexPath.row].title
        cell.timeLbl.text = self.notificationList?[indexPath.row].description
//        cell.timeLbl.text = self.notificationList?[indexPath.row].created_at
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        return  cell
    }
}



extension NotificationVC : PresenterOutputProtocol
{
    func showSuccess(api: String, dataArray: [Mappable]?, dataDict: Mappable?, modelClass: Any)
    {
        self.loader.isHidden = true
     
        switch api {
        case "\(url)":
           
            self.notificationList = dataArray as? [NotificationList]
      
            self.tableView.reloadData()
            
        default:
            print("")
        }
  
    }
    
    func showError(error: CustomError)
        
    {
        self.loader.isHidden = true
        ToastManager.show(title:  nullStringToEmpty(string: error.localizedDescription.trimString()), state: .success)
    }
 
}

