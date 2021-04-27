//
//  SettingVC.swift
//  ViperBaseiOS13
//
//  Created by Admin on 27/04/21.
//  Copyright © 2021 CSS. All rights reserved.
//

import UIKit

class SettingVC: UIViewController {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var mainTableView: UITableView!
    
    // MARK: - Variables
    //===========================
    var dataArray = [(Constants.string.changePassword.localize(),#imageLiteral(resourceName: "icChnagePassword")),(Constants.string.terms_conditions.localize(),#imageLiteral(resourceName: "icTermCondition")),(Constants.string.privacy_policy.localize(),#imageLiteral(resourceName: "icPrivacyPolicy"))]
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    // MARK: - IBActions
    //===========================
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.popOrDismiss(animation: true)
    }
    
    
}

// MARK: - Extension For Functions
//===========================
extension SettingVC {
    
    private func initialSetup() {
        self.mainTableView.delegate = self
        self.mainTableView.dataSource = self
        self.mainTableView.registerCell(with: SettingTableCell.self)
    }
}

// MARK: - Extension For TableView
//===========================
extension SettingVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.endIndex
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = mainTableView.dequeueCell(with: SettingTableCell.self, indexPath: indexPath)
        cell.titleLbl.text = dataArray[indexPath.row].0
        cell.titleImgView.image = dataArray[indexPath.row].1
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch dataArray[indexPath.row].0 {
        case Constants.string.changePassword.localize():
            let vc = ChangePasswordVC.instantiate(fromAppStoryboard: .Products)
            self.navigationController?.pushViewController(vc, animated: true)
        case Constants.string.terms_conditions.localize():
            let vc = WebViewControllerVC.instantiate(fromAppStoryboard: .Products)
            vc.webViewType = .termsCondition
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            let vc = WebViewControllerVC.instantiate(fromAppStoryboard: .Products)
            vc.webViewType = .privacyPolicy
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
