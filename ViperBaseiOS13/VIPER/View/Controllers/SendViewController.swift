//
//  SendViewController.swift
//  ViperBaseiOS13
//
//  Created by Deepika on 15/05/20.
//  Copyright © 2020 CSS. All rights reserved.
//

import UIKit
import ObjectMapper

class SendCell: UITableViewCell {
    
    
    @IBOutlet weak var balLbl: UILabel!
    @IBOutlet weak var nameLbbl: UILabel!
    
    
    override func awakeFromNib() {
           super.awakeFromNib()
           
          
       }
}

class SendViewController: UIViewController {

    @IBOutlet weak var titleLl: UILabel!
    @IBOutlet weak var walletHistoryutton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var qrImg: UIImageView!
    @IBOutlet weak var ethBalLbl: UILabel!
   private lazy var loader  : UIView = {
                   return createActivityIndicator(self.view)
       }()
    var sendEntity: SendEntity?
    var tokenList = [Tokens]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
            tableView.delegate = self
                  tableView.dataSource = self
                  self.tableView.register(UINib.init(nibName: XIB.Names.HistoryCell, bundle: nil), forCellReuseIdentifier: XIB.Names.HistoryCell)
        
        
        
            let button = UIButton(type: .custom)
            let image = UIImage(named: "historyIcon")?.withRenderingMode(.alwaysTemplate)
            walletHistoryutton.setImage(image, for: .normal)
            walletHistoryutton.tintColor = UIColor.black
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(true)
        qrImg.backgroundColor = .white
           getSend()
           
       }
       
    
    @IBAction func walletHistoryClickEvent(_ sender: UIButton) {
        
        guard let vc = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.SendHistoryViewController) as? SendHistoryViewController else { return }
            self.navigationController?.pushViewController(vc, animated: true)
        
    }
    

    @IBAction func copyClickEvent(_ sender: UIButton) {
        UIPasteboard.general.string = nullStringToEmpty(string: addressLbl.text)
        ToastManager.show(title: nullStringToEmpty(string: Constants.string.copyClipboard.localize()), state: .success)
    }
    @IBAction func goBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    

}
extension SendViewController: UITableViewDataSource, UITableViewDelegate {
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  tokenList.count > 0 ? tokenList.count : 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 53
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SendCell", for: indexPath) as! SendCell
    
         cell.backgroundColor = .clear
         cell.selectionStyle = .none
        let entity = tokenList[indexPath.row]
        cell.nameLbbl.text = nullStringToEmpty(string: entity.token_details?.tokensymbol)
        let tokenvalue = String( entity.token_acquire ?? 0.0)
        cell.balLbl.text = nullStringToEmpty(string: tokenvalue)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
      let entity = tokenList[indexPath.row]
        let customAlertViewController = SendTokenViewController(nibName: "SendTokenViewController", bundle: nil)
        customAlertViewController.token = entity
       
                          customAlertViewController.delegate = self
                          customAlertViewController.providesPresentationContextTransitionStyle = true;
                          customAlertViewController.definesPresentationContext = true;
                          customAlertViewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                          customAlertViewController.view.backgroundColor = UIColor(white: 0, alpha: 0.25)
                          self.present(customAlertViewController, animated: false, completion: nil)
    }
    
}

//MARK: - PresenterOutputProtocol
extension SendViewController: PresenterOutputProtocol {
    
    func showSuccess(api: String, dataArray: [Mappable]?, dataDict: Mappable?, modelClass: Any) {
        
        switch api {
       
        case Base.sendAPI.rawValue:
            
            self.loader.isHidden = true
            self.sendEntity = dataDict as? SendEntity
            addressLbl.text = nullStringToEmpty(string: self.sendEntity?.user?.wallet_eth_address)
            let ethBalance = String(self.sendEntity?.eth_balance ?? 0.0)
            self.ethBalLbl.text = nullStringToEmpty(string: ethBalance)
            qrImg.image = Common.CreateQrCodeForyourString(string: nullStringToEmpty(string: self.sendEntity?.user?.wallet_eth_address))
            tokenList = self.sendEntity?.tokens ?? []
            self.tableView.reloadData()

        default:
            break
        }
        
    }
    
    func showError(error: CustomError) {
        
        self.loader.isHidden = true
        ToastManager.show(title:  nullStringToEmpty(string: error.localizedDescription.trimString()), state: .error)
        
    }
    
    func getSend() {
        
        self.loader.isHidden = false
        self.presenter?.HITAPI(api: Base.sendAPI.rawValue, params: nil, methodType: .GET, modelClass: SendEntity.self, token: true)
    }
    
}


extension SendViewController : RefreshDelegate {
    func didReceiveRefresh(isRefresh: Bool, successDict: SuccessDict) {
        if isRefresh {
            
           getSend()
        }
    }
    
    
    
}
