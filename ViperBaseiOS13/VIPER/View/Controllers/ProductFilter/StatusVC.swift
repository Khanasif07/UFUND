//
//  StatusVC.swift
//  ViperBaseiOS13
//
//  Created by Admin on 16/02/21.
//  Copyright © 2021 CSS. All rights reserved.
//

import UIKit
class StatusVC: UIViewController {
    // MARK: - IB Outlet
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Variables
    let statusDetails: [Status] = Status.allCases
    
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
        return self.statusDetails.endIndex
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(with: CategoryListTableCell.self, indexPath: indexPath)
        cell.status = statusDetails[indexPath.row]
        cell.statusButton.isSelected = ProductFilterVM.shared.status.contains(statusDetails[indexPath.row].title)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
        self.tableView.reloadData()
    }
}
