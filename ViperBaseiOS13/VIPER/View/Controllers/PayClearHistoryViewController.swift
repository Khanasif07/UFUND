//
//  PayClearHistoryViewController.swift
//  Project
//
//  Created by Deepika on 25/06/20.
//  Copyright © 2020 css. All rights reserved.
//



import UIKit
import ObjectMapper
import SafariServices

class PayClearHistoryViewController: UIViewController {
    
   
    private var walletTranscationList = [PayHistory]()
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var titleLbl: UILabel!
    private lazy var loader  : UIView = {
        return createActivityIndicator(self.view)
    }()
    var selectedType: String?
    var selectedTitle: String?
    @IBOutlet weak var imgBack: UIImageView!
    @IBOutlet weak var bgView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
         self.tableView.register(UINib.init(nibName: XIB.Names.TranscationHistoryCell, bundle: nil), forCellReuseIdentifier: XIB.Names.TranscationHistoryCell)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
       loadWalletTranscation()
         
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
          localize()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

//MARK: - Font Custom & Localization.
extension PayClearHistoryViewController {
    
    func localize() {
       
        
        titleLbl.textColor = UIColor(hex: darkTextColor)
        titleLbl.text = nullStringToEmpty(string: Constants.string.coinpay.localize())
    }
}

//MARK: - Button Action
extension PayClearHistoryViewController {
    @IBAction func goBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK:- Show Custom Toast
extension PayClearHistoryViewController {
    private func showToast(string : String?) {
        ToastManager.show(title: nullStringToEmpty(string: string), state: .error)
    }
}

//MARK: - PresenterOutputProtocol
extension PayClearHistoryViewController: PresenterOutputProtocol {
    
  
    
    func loadWalletTranscation() {
        self.loader.isHidden = false
        self.presenter?.HITAPI(api: Base.payHistory.rawValue, params: nil, methodType: .GET, modelClass: PayHistory.self, token: true)
    }
    
    func showSuccess(api: String, dataArray: [Mappable]?, dataDict: Mappable?, modelClass: Any) {
        
        switch nullStringToEmpty(string: api) {
            
        case nullStringToEmpty(string: Base.payHistory.rawValue):
            
            self.loader.isHidden = true
            self.walletTranscationList = dataArray as? [PayHistory] ?? []
            self.tableView.reloadData()
            print("******LOCKING")
            
        
        default:
            break
        }
        
    }
    
    func showError(error: CustomError) {
        
        self.loader.isHidden = true
        ToastManager.show(title: nullStringToEmpty(string: error.localizedDescription.trimString()), state: .error)
    }
    
}



//MARK: - UITableViewDelegate & UITableViewDataSource
extension PayClearHistoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
      
        return walletTranscationList.count > 0 ? walletTranscationList.count : 0
      
       
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
       
       
            return 130
        }
        
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
  
            let cell = tableView.dequeueReusableCell(withIdentifier: XIB.Names.TranscationHistoryCell) as! TranscationHistoryCell
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            
            cell.darkTheme()
            let entity = walletTranscationList[indexPath.row]
           
        let token = String(entity.amount?.rounded(toPlaces: 6) ?? 0.0)
   
       
        cell.sendOrReceiverLbl.text = "$ " + nullStringToEmpty(string: token)
        
        cell.inUSDLbl.text = convertDateFormaterPost(nullStringToEmpty(string: entity.created_at))
        cell.statusLbl.textColor = UIColor(hex: darkTextColor)
        cell.dateLbl.text = nullStringToEmpty(string: entity.type).uppercased()
        cell.inHADTLbl.text = nullStringToEmpty(string: entity.status)
        cell.inHADTLbl.textColor = UIColor(hex: greenColur)
        cell.seeMoreButton.isHidden = true
        
        cell.txtId.text = nullStringToEmpty(string: entity.payment_details?.address)

        return  cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let entity = walletTranscationList[indexPath.row]
//        if entity.coinpayment?.status_url != nil {
//            let safariVC = SFSafariViewController(url: NSURL(string:  nullStringToEmpty(string:  entity.coinpayment?.status_url))! as URL)
//            self.present(safariVC, animated: true, completion: nil)
//            safariVC.delegate = self
//        }
        
    }

}

extension PayClearHistoryViewController: SFSafariViewControllerDelegate {
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
