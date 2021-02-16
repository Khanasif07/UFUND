//
//  CurrencyVC.swift
//  ViperBaseiOS13
//
//  Created by Admin on 16/02/21.
//  Copyright © 2021 CSS. All rights reserved.
//

import UIKit
class CurrencyVC: UIViewController {
    // MARK: - IB Outlet
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - Variables
    
    let currencyListing: [Currency] = Currency.allCases
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doIntitialSetup()
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
}

// MARK: - UITableViewDataSource and Delegate methods

extension CurrencyVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.currencyListing.endIndex
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueCell(with: CategoryListTableCell.self, indexPath: indexPath)
        cell.currency = currencyListing[indexPath.row]
        cell.statusButton.isSelected = ProductFilterVM.shared.currency.contains(currencyListing[indexPath.row].rawValue)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if ProductFilterVM.shared.currency.contains(currencyListing[indexPath.row].rawValue) {
            ProductFilterVM.shared.currency.remove(at: ProductFilterVM.shared.currency.firstIndex(of: currencyListing[indexPath.row].rawValue)!)
        } else {
            ProductFilterVM.shared.currency.append(currencyListing[indexPath.row].rawValue)
        }
        self.tableView.reloadData()
    }
}
