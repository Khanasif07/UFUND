//
//  StatusVC.swift
//  ViperBaseiOS13
//
//  Created by Admin on 16/02/21.
//  Copyright © 2021 CSS. All rights reserved.
//

import UIKit
class StatusVC: UIViewController {
    
    enum StatusType {
        case status
        case type
        case byRewards
    }
    // MARK: - IB Outlet
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Variables
    var statusType: StatusType = .status
    let statusDetails: [Status] = Status.allCases
    let typeDetails  : [AssetsType] = AssetsType.allCases
    let assetsByRewardsDetails : [AssetsByReward] =  AssetsByReward.allCases
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doIntitialSetup()
        self.addFooterView()
        registerXib()
    }
    
    // MARK: - Helper methods
    
    private func doIntitialSetup() {
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func registerXib() {
         tableView.registerCell(with: CategoryListTableCell.self)
    }
    
    private func addFooterView() {
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 120))
        customView.backgroundColor = #colorLiteral(red: 0.9568627451, green: 0.9411764706, blue: 0.9411764706, alpha: 1)
        tableView.tableFooterView = customView
    }
}

// MARK: - UITableViewDataSource and Delegate methods

extension StatusVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch statusType {
        case .status:
            return self.statusDetails.endIndex
        case .type:
            return self.typeDetails.endIndex
        case .byRewards:
            return self.assetsByRewardsDetails.endIndex
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(with: CategoryListTableCell.self, indexPath: indexPath)
        switch statusType {
        case .status:
            cell.status = statusDetails[indexPath.row]
            cell.statusButton.isSelected = ProductFilterVM.shared.status.contains(statusDetails[indexPath.row].title)
        case .type:
            cell.type = typeDetails[indexPath.row]
            cell.statusButton.isSelected = ProductFilterVM.shared.types.contains(typeDetails[indexPath.row].title)
        case .byRewards:
            cell.byRewards = assetsByRewardsDetails[indexPath.row]
            cell.statusButton.isSelected = ProductFilterVM.shared.byRewards.contains(assetsByRewardsDetails[indexPath.row].title)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch statusType {
        case .status:
            if ProductFilterVM.shared.status.contains(statusDetails[indexPath.row].title) {
                if statusDetails[indexPath.row].title == "All" {
                    ProductFilterVM.shared.status = []
                } else {
                    ProductFilterVM.shared.status.remove(at: ProductFilterVM.shared.status.firstIndex(of: statusDetails[indexPath.row].title)!)
                    if ProductFilterVM.shared.status.endIndex == statusDetails.endIndex - 1 && ProductFilterVM.shared.status.contains("All"){
                        ProductFilterVM.shared.status.remove(at: ProductFilterVM.shared.status.firstIndex(of: "All")!)
                    } else{}
                }
            } else {
                if statusDetails[indexPath.row].title == "All" {
                    ProductFilterVM.shared.status = statusDetails.map({$0.title})
                } else {
                    if ProductFilterVM.shared.status.endIndex == statusDetails.endIndex - 2{
                        ProductFilterVM.shared.status = statusDetails.map({$0.title})
                    } else{
                        ProductFilterVM.shared.status.append(statusDetails[indexPath.row].title)
                    }
                }
            }
            
        case  .type :
            if ProductFilterVM.shared.types.contains(typeDetails[indexPath.row].title) {
                if typeDetails[indexPath.row].title == "All" {
                    ProductFilterVM.shared.types = []
                } else {
                    ProductFilterVM.shared.types.remove(at: ProductFilterVM.shared.types.firstIndex(of: typeDetails[indexPath.row].title)!)
                    if ProductFilterVM.shared.types.endIndex == typeDetails.endIndex - 1 && ProductFilterVM.shared.types.contains("All"){
                        ProductFilterVM.shared.types.remove(at: ProductFilterVM.shared.types.firstIndex(of: "All")!)
                    } else{}
                }
            } else {
                if typeDetails[indexPath.row].title == "All" {
                    ProductFilterVM.shared.types = typeDetails.map({$0.title})
                } else {
                    if ProductFilterVM.shared.types.endIndex == typeDetails.endIndex - 2{
                        ProductFilterVM.shared.types = typeDetails.map({$0.title})
                    } else{
                        ProductFilterVM.shared.types.append(typeDetails[indexPath.row].title)
                    }
                }
            }
            
        default:
            if ProductFilterVM.shared.byRewards.contains(assetsByRewardsDetails[indexPath.row].title) {
                if assetsByRewardsDetails[indexPath.row].title == "All" {
                    ProductFilterVM.shared.byRewards = []
                } else {
                    ProductFilterVM.shared.byRewards.remove(at: ProductFilterVM.shared.byRewards.firstIndex(of: assetsByRewardsDetails[indexPath.row].title)!)
                    if ProductFilterVM.shared.byRewards.endIndex == assetsByRewardsDetails.endIndex - 1 && ProductFilterVM.shared.byRewards.contains("All"){
                        ProductFilterVM.shared.byRewards.remove(at: ProductFilterVM.shared.byRewards.firstIndex(of: "All")!)
                    } else{}
                }
            } else {
                if assetsByRewardsDetails[indexPath.row].title == "All" {
                    ProductFilterVM.shared.byRewards = assetsByRewardsDetails.map({$0.title})
                } else {
                    if ProductFilterVM.shared.byRewards.endIndex == assetsByRewardsDetails.endIndex - 2{
                        ProductFilterVM.shared.byRewards = assetsByRewardsDetails.map({$0.title})
                    } else{
                        ProductFilterVM.shared.byRewards.append(assetsByRewardsDetails[indexPath.row].title)
                    }
                }
            }
        }
        self.tableView.reloadData()
    }
}
