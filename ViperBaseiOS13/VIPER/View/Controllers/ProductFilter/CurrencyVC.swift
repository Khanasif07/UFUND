////
////  CurrencyVC.swift
////  ViperBaseiOS13
////
////  Created by Admin on 16/02/21.
////  Copyright © 2021 CSS. All rights reserved.
////
//
//import UIKit
//import ObjectMapper
//
//class CurrencyVC: UIViewController {
//    // MARK: - IB Outlet
//
//    @IBOutlet weak var tableView: UITableView!
//    @IBOutlet weak var searchBar: UISearchBar!
//
//    // MARK: - Variables
//    // MARK: - Variables
//    var isSearchOn: Bool  =  false
//    var searchedCurrencyListing = [CurrencyModel]()
//    var selectedCurrencyListing : [CurrencyModel]
//    var currencyListing: [CurrencyModel]
//    var searchText: String? {
//           didSet{
//               if let searchedText = searchText{
//                   if searchedText.isEmpty{
//                       self.tableView.reloadData()
//                   } else {
//                    self.searchedCurrencyListing = currencyListing?.filter({(($0.currency?.lowercased().contains(s: searchedText.lowercased()))!)}) ?? []
//                       self.tableView.reloadData()
//                   }
//               }
//           }
//       }
////    let currencyListing: [Currency] = Currency.allCases
//
//    // MARK: - View Lifecycle
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        doIntitialSetup()
//        addFooterView()
//        registerXib()
//    }
//
//    // MARK: - Helper methods
//
//    private func doIntitialSetup() {
//        searchBar.delegate = self
//        tableView.separatorStyle = .none
//        tableView.dataSource = self
//        tableView.delegate = self
//        getProductsCurrenciesList()
//    }
//
//    private func registerXib() {
//        tableView.registerCell(with: CategoryListTableCell.self)
//    }
//
//    private func addFooterView() {
//             let customView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 120))
//             customView.backgroundColor = #colorLiteral(red: 0.9568627451, green: 0.9411764706, blue: 0.9411764706, alpha: 1)
//             tableView.tableFooterView = customView
//         }
//
//    func removeSelectedPower(model : CurrencyModel) {
//        if self.selectedCurrencyListing.count != 0 {
//            for power in self.selectedCurrencyListing.enumerated() {
//                if power.element.id == model.id {
//                    self.selectedCurrencyListing.remove(at: power.offset)
////                    ProductFilterVM.shared.selectedCurrencyListing.remove(at: power.offset)
//                    break
//                }
//            }
//        }
//    }
//
//    func setSelectedPowers(model : CurrencyModel) {
//        if self.currencyListing.count != 0 {
//            self.selectedCurrencyListing.append(model)
////            ProductFilterVM.shared.selectedCurrencyListing.append(model)
//        } else {
//            self.selectedCurrencyListing = [model]
////            ProductFilterVM.shared.selectedCurrencyListing =  [model]
//        }
//    }
//
//    //MARK:- PRDUCTS LIST API CALL
//    private func getProductsCurrenciesList() {
//        self.presenter?.HITAPI(api: Base.productsCurrencies.rawValue, params: nil, methodType: .GET, modelClass: CurrencyModelEntity.self, token: true)
//    }
//}
//
//// MARK: - UITableViewDataSource and Delegate methods
//
//extension CurrencyVC: UITableViewDataSource, UITableViewDelegate {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//         if isSearchOn { return self.searchedCurrencyListing.count }
//                else { return currencyListing?.count ?? 0 }
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueCell(with: CategoryListTableCell.self, indexPath: indexPath)
//        //        cell.currency = currencyListing[indexPath.row]
//        //        cell.statusButton.isSelected = ProductFilterVM.shared.currency.contains(currencyListing[indexPath.row].rawValue)
//        cell.currency = isSearchOn ? self.searchedCurrencyListing[indexPath.row] : currencyListing?[indexPath.row] ?? CurrencyModel()
//        let isPowerSelected = self.selectedCurrencyListing.contains(where: {$0.id == (isSearchOn ? self.searchedCurrencyListing[indexPath.row].id : currencyListing?[indexPath.row].id)})
//        cell.statusButton.isSelected = isPowerSelected
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 44.0
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        //        if ProductFilterVM.shared.currency.contains(currencyListing[indexPath.row].rawValue) {
//        //            ProductFilterVM.shared.currency.remove(at: ProductFilterVM.shared.currency.firstIndex(of: currencyListing[indexPath.row].rawValue)!)
//        //        } else {
//        //            ProductFilterVM.shared.currency.append(currencyListing[indexPath.row].rawValue)
//        //        }
//        if self.selectedCurrencyListing.contains(where: {$0.id == (isSearchOn ? self.searchedCurrencyListing[indexPath.row].id : currencyListing?[indexPath.row].id)}){
//            self.removeSelectedPower(model: isSearchOn ? self.searchedCurrencyListing[indexPath.row] : currencyListing?[indexPath.row] ?? CurrencyModel())
//        } else {
//            self.setSelectedPowers(model: isSearchOn ? self.searchedCurrencyListing[indexPath.row] : currencyListing?[indexPath.row] ?? CurrencyModel())
//        }
//        self.tableView.reloadData()
//    }
//}
//
////MARK:- UISearchBarDelegate
////========================================
//extension CurrencyVC: UISearchBarDelegate{
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        self.isSearchOn = !searchText.isEmpty
//        self.searchText = searchText
//    }
//
//    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
//        return true
//    }
//
//    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
//        if let text = searchBar.text,!text.byRemovingLeadingTrailingWhiteSpaces.isEmpty{
//            self.isSearchOn = true
//        }else{
//            self.isSearchOn = false
//        }
//        searchBar.resignFirstResponder()
//        return true
//    }
//
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar){
//        searchBar.resignFirstResponder()
//    }
//
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
//        if let text = searchBar.text,!text.byRemovingLeadingTrailingWhiteSpaces.isEmpty{
//            self.isSearchOn = true
//        }else{
//            self.isSearchOn = false
//        }
//        searchBar.resignFirstResponder()
//    }
//}
//
//
//extension CurrencyVC : PresenterOutputProtocol {
//
//    func showSuccess(api: String, dataArray: [Mappable]?, dataDict: Mappable?, modelClass: Any) {
//        let currencyModelEntity = dataDict as? CurrencyModelEntity
//        ProductFilterVM.shared.currencyListing = currencyModelEntity?.data ?? []
//        currencyListing = currencyModelEntity?.data ?? []
//        self.tableView.reloadData()
//    }
//
//    func showError(error: CustomError) {
//        ToastManager.show(title:  nullStringToEmpty(string: error.localizedDescription.trimString()), state: .success)
//
//    }
//
//}
