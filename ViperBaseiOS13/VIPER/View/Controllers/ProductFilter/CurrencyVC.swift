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
    
    let cellIdentifier = "AmenitiesTableViewCell"
//    let amentiesDetails: [ATAmenity] = ATAmenity.allCases
    
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
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueCell(with: CategoryListTableCell.self, indexPath: indexPath)
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? AmenitiesTableViewCell else {
//            printDebug("AmenitiesTableViewCell not found")
//            return UITableViewCell()
//        }
//        cell.amenitie = amentiesDetails[indexPath.row]
//        cell.statusButton.isSelected = HotelFilterVM.shared.amenitites.contains(amentiesDetails[indexPath.row].rawValue)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if HotelFilterVM.shared.amenitites.contains(amentiesDetails[indexPath.row].rawValue) {
//            HotelFilterVM.shared.amenitites.remove(at: HotelFilterVM.shared.amenitites.firstIndex(of: amentiesDetails[indexPath.row].rawValue)!)
//        } else {
//            HotelFilterVM.shared.amenitites.append(amentiesDetails[indexPath.row].rawValue)
//        }
        self.tableView.reloadData()
    }
}
