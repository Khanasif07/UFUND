//
//  CategoryListingVC.swift
//  ViperBaseiOS13
//
//  Created by Admin on 16/02/21.
//  Copyright © 2021 CSS. All rights reserved.
//

import UIKit

class CategoryListingVC: UIViewController {
    // MARK: - IB Outlet
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Variables
    
    let amentiesDetails: [ATAmenity] = ATAmenity.allCases
    
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
        customView.backgroundColor = .white
        tableView.tableFooterView = customView
    }
}

// MARK: - UITableViewDataSource and Delegate methods

extension CategoryListingVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return amentiesDetails.endIndex
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(with: CategoryListTableCell.self, indexPath: indexPath)
        cell.amenitie = amentiesDetails[indexPath.row]
        cell.statusButton.isSelected = ProductFilterVM.shared.amenitites.contains(amentiesDetails[indexPath.row].rawValue)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if ProductFilterVM.shared.amenitites.contains(amentiesDetails[indexPath.row].rawValue) {
            ProductFilterVM.shared.amenitites.remove(at: ProductFilterVM.shared.amenitites.firstIndex(of: amentiesDetails[indexPath.row].rawValue)!)
        } else {
            ProductFilterVM.shared.amenitites.append(amentiesDetails[indexPath.row].rawValue)
        }
        self.tableView.reloadData()
    }
}
