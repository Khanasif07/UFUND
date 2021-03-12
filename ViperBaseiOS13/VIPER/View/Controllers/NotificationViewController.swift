//
//  NotificationViewController.swift
//  ViperBaseiOS13
//
//  Created by Deepika on 25/11/19.
//  Copyright © 2019 CSS. All rights reserved.
//

import UIKit
import ObjectMapper

class NotificationViewController: UIViewController {

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
        titleLbl.textColor = UIColor(hex: darkTextColor)
        titleLbl.text = Constants.string.Notification.localize().uppercased()
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
extension NotificationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.notificationList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 18.5 * tableView.frame.height / 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: XIB.Names.NotificationCell, for: indexPath) as! NotificationCell
        cell.ttileLbl.text = self.notificationList?[indexPath.row].title
        cell.descripLbl.text = self.notificationList?[indexPath.row].description
        cell.timeLbl.text = self.notificationList?[indexPath.row].created_at
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        return  cell
    }
}



extension NotificationViewController : PresenterOutputProtocol
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
