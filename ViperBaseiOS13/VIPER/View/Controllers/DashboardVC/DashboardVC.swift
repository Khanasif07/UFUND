//
//  DashboardVC.swift
//  ViperBaseiOS13
//
//  Created by Admin on 23/03/21.
//  Copyright © 2021 CSS. All rights reserved.
//

import UIKit

class DashboardVC: UIViewController {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var titleLbl: UILabel!
    
    // MARK: - Variables
    //===========================
    let userType = UserDefaults.standard.value(forKey: UserDefaultsKey.key.isFromInvestor) as? String
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.mainTableView.layoutIfNeeded()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.mainTableView.reloadData()
    }
    
    // MARK: - IBActions
    //===========================
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.popOrDismiss(animation: true)
    }
    
    
}

// MARK: - Extension For Functions
//===========================
extension DashboardVC {
    
    private func initialSetup() {
        self.tableViewSetUp()
    }
    
    private func tableViewSetUp(){
        self.mainTableView.delegate = self
        self.mainTableView.dataSource = self
        self.mainTableView.registerCell(with: DashboardTabsTableCell.self)
        self.mainTableView.registerCell(with: DashboardBarChartCell.self)
        self.mainTableView.registerCell(with: DashboardInvestmentCell.self)
    }
}

// MARK: - Extension For TableView
//===========================
extension DashboardVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueCell(with: DashboardTabsTableCell.self, indexPath: indexPath)
            cell.isFromCampainer = userType == UserType.investor.rawValue ? false : true
            cell.tabsCollView.layoutIfNeeded()
            return cell
        case 1:
            let cell = tableView.dequeueCell(with: DashboardBarChartCell.self, indexPath: indexPath)
            return cell
        default:
            let cell = tableView.dequeueCell(with: DashboardInvestmentCell.self, indexPath: indexPath)
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
