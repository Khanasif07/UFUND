//
//  InvestmentListViewController.swift
//  ViperBaseiOS13
//
//  Created by Deepika on 06/01/20.
//  Copyright © 2020 CSS. All rights reserved.
//

import UIKit
import ObjectMapper

class InvestmentListCell: UITableViewCell {
    
  
    @IBOutlet weak var imgVieww: UIImageView!
    @IBOutlet weak var decLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imgVieww.setCornerRadius()
    }
}

class InvestmentListViewController: UIViewController {

    private lazy var loader  : UIView = {
           return createActivityIndicator(self.view)
    }()
    @IBOutlet weak var titleLbl: UILabel!
    @IBAction func goBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var tableView: UITableView!
    var investmentList =  [InvestementEntity]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        
        titleLbl.text = Constants.string.investment.localize().uppercased()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        getInvestment()
        
    }
}

extension InvestmentListViewController: UITableViewDataSource, UITableViewDelegate {
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.investmentList.count > 0 ?  self.investmentList.count : 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 20 * tableView.frame.height / 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "InvestmentListCell", for: indexPath) as! InvestmentListCell
    
         cell.backgroundColor = .clear
         cell.selectionStyle = .none
         
        if investmentList.count > 0  && investmentList.count > indexPath.row {
            
            let entity = investmentList[indexPath.row]
            cell.priceLbl.text = "$" + "\(entity.product_value ?? 0.0)"
            cell.titleLbl.text = nullStringToEmpty(string: entity.product_title)
            cell.decLbl.text = nullStringToEmpty(string: entity.product_description)
            let url = URL.init(string: baseUrl + "/" + nullStringToEmpty(string: entity.product_image))
            cell.imgVieww.sd_setImage(with: url, completed: nil)
           
        }
 
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let vc = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.InvestmentViewController) as? InvestmentViewController else { return }
        vc.getProductDetails(id: self.investmentList[indexPath.row].id)
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}

//MARK: - PresenterOutputProtocol
extension InvestmentListViewController: PresenterOutputProtocol {
    
    func showSuccess(api: String, dataArray: [Mappable]?, dataDict: Mappable?, modelClass: Any) {
        
        switch api {
       
        case Base.investmentproducts.rawValue:
            
            self.loader.isHidden = true
            self.investmentList = dataArray as? [InvestementEntity] ?? []
            self.tableView.reloadData()

        default:
            break
        }
        
    }
    
    func showError(error: CustomError) {
        
        self.loader.isHidden = true
        ToastManager.show(title:  nullStringToEmpty(string: error.localizedDescription.trimString()), state: .error)
        
    }
    
    func getInvestment() {
        
        self.loader.isHidden = false
        self.presenter?.HITAPI(api: Base.investmentproducts.rawValue, params: nil, methodType: .GET, modelClass: InvestementEntity.self, token: true)
    }
    
}
