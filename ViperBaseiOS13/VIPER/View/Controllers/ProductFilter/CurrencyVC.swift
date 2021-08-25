////
////  CurrencyVC.swift
////  ViperBaseiOS13
////
////  Created by Admin on 16/02/21.
////  Copyright © 2021 CSS. All rights reserved.
////
//
import UIKit
import ObjectMapper

class CurrencyVC: UIViewController {
    
    enum TokenType{
        case Asset
        case Token
        case transactionType
    }
    
    // MARK: - IB Outlet

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    // MARK: - Variables
    // MARK: - Variables
    var tokenType: TokenType = .Asset
    var isSearchOn: Bool  =  false
    var searchedAssetsListing = [AssetTokenTypeModel]()
    var selectedAssetsListing : [AssetTokenTypeModel] = ProductFilterVM.shared.selectedAssetsListing
    var assetsListing: [AssetTokenTypeModel] = ProductFilterVM.shared.assetsListing
    var searchedTokenListing = [AssetTokenTypeModel]()
    var selectedTokenListing : [AssetTokenTypeModel] = ProductFilterVM.shared.selectedTokenListing
    var tokenListing: [AssetTokenTypeModel] = ProductFilterVM.shared.tokenListing
    var searchText: String? {
        didSet{
            if tokenType == .Asset {
                if let searchedText = searchText{
                    if searchedText.isEmpty{
                        self.tableView.reloadData()
                    } else {
                        self.searchedAssetsListing = assetsListing.filter({(($0.name?.lowercased().contains(s: searchedText.lowercased()))!)})
                        self.tableView.reloadData()
                    }
                }
            } else {
                if let searchedText = searchText{
                    if searchedText.isEmpty{
                        self.tableView.reloadData()
                    } else {
                        self.searchedTokenListing = tokenListing.filter({(($0.name?.lowercased().contains(s: searchedText.lowercased()))!)})
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        doIntitialSetup()
        addFooterView()
        registerXib()
    }

    // MARK: - Helper methods

    private func doIntitialSetup() {
        searchBar.delegate = self
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        getProductsCurrenciesList()
    }

    private func registerXib() {
        tableView.registerCell(with: CategoryListTableCell.self)
    }

    private func addFooterView() {
             let customView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 120))
             customView.backgroundColor = #colorLiteral(red: 0.9568627451, green: 0.9411764706, blue: 0.9411764706, alpha: 1)
             tableView.tableFooterView = customView
         }

    func removeSelectedPower(model : AssetTokenTypeModel) {
        if tokenType == .Asset {
            if self.selectedAssetsListing.count != 0 {
                for power in self.selectedAssetsListing.enumerated() {
                    if power.element.id == model.id {
                        self.selectedAssetsListing.remove(at: power.offset)
                        ProductFilterVM.shared.selectedAssetsListing.remove(at: power.offset)
                        break
                    }
                }
            }
        } else {
            if self.selectedTokenListing.count != 0 {
                for power in self.selectedTokenListing.enumerated() {
                    if power.element.id == model.id {
                        self.selectedTokenListing.remove(at: power.offset)
                        ProductFilterVM.shared.selectedTokenListing.remove(at: power.offset)
                        break
                    }
                }
            }
        }
    }

    //MARK:- PRDUCTS LIST API CALL
    private func getProductsCurrenciesList() {
        if tokenType == .transactionType {
        self.presenter?.HITAPI(api: Base.transaction_types.rawValue, params: nil, methodType: .GET, modelClass: AssetTokenTypeEntity.self, token: true)
        } else {
        self.presenter?.HITAPI(api: Base.asset_token_types.rawValue, params: [ProductCreate.keys.type: tokenType == .Asset ? 1 : 2], methodType: .GET, modelClass: AssetTokenTypeEntity.self, token: true)
        }
    }
}

// MARK: - UITableViewDataSource and Delegate methods

extension CurrencyVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tokenType == .Asset {
            if isSearchOn { return self.searchedAssetsListing.count }
            else { return assetsListing.count }
        } else {
            if isSearchOn { return self.searchedTokenListing.count }
            else { return tokenListing.count }
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(with: CategoryListTableCell.self, indexPath: indexPath)
        if tokenType == .Asset {
            cell.currency = isSearchOn ? self.searchedAssetsListing[indexPath.row] : assetsListing[indexPath.row]
            let isPowerSelected = self.selectedAssetsListing.contains(where: {$0.id == (isSearchOn ? self.searchedAssetsListing[indexPath.row].id : assetsListing[indexPath.row].id)})
              cell.statusButton.isSelected = isPowerSelected
        } else {
            cell.currency = isSearchOn ? self.searchedTokenListing[indexPath.row] : tokenListing[indexPath.row]
            let isPowerSelected = self.selectedTokenListing.contains(where: {$0.id == (isSearchOn ? self.searchedTokenListing[indexPath.row].id : tokenListing[indexPath.row].id)})
              cell.statusButton.isSelected = isPowerSelected
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tokenType == .Asset {
        if self.selectedAssetsListing.contains(where: {$0.id == (isSearchOn ? self.searchedAssetsListing[indexPath.row].id : assetsListing[indexPath.row].id)}){
            if isSearchOn ? self.searchedAssetsListing[indexPath.row].id == 0 : assetsListing[indexPath.row].id == 0  {
                self.selectedAssetsListing = []
                ProductFilterVM.shared.selectedCategoryListing = []
                self.selectedAssetsListing = []
            } else {
                self.removeSelectedPower(model: isSearchOn ? self.searchedAssetsListing[indexPath.row] : assetsListing[indexPath.row] )
                if ProductFilterVM.shared.selectedAssetsListing.endIndex == (assetsListing.endIndex ) - 1 && ProductFilterVM.shared.selectedAssetsListing.contains(where: {$0.id == 0}){
                    ProductFilterVM.shared.selectedAssetsListing.remove(at: ProductFilterVM.shared.selectedAssetsListing.firstIndex(where: {$0.id == 0}) ?? 0)
                    self.selectedAssetsListing.remove(at: ProductFilterVM.shared.selectedCategoryListing.firstIndex(where: {$0.id == 0}) ?? 0)
                } else{}
            }
        } else {
            if isSearchOn ? self.searchedAssetsListing[indexPath.row].id == 0 : assetsListing[indexPath.row].id == 0   {
                ProductFilterVM.shared.selectedAssetsListing = assetsListing
                self.selectedAssetsListing = assetsListing
            } else {
                if ProductFilterVM.shared.selectedAssetsListing.endIndex == (assetsListing.endIndex ) - 2{
                    ProductFilterVM.shared.selectedAssetsListing = assetsListing
                    self.selectedAssetsListing = assetsListing
                } else{
                    ProductFilterVM.shared.selectedAssetsListing.append(isSearchOn ? self.searchedAssetsListing[indexPath.row] : assetsListing[indexPath.row] )
                    self.selectedAssetsListing.append(isSearchOn ? self.searchedAssetsListing[indexPath.row] : assetsListing[indexPath.row] )
                }
            }
        }
        } else {
            if self.selectedTokenListing.contains(where: {$0.id == (isSearchOn ? self.searchedTokenListing[indexPath.row].id : tokenListing[indexPath.row].id)}){
                if isSearchOn ? self.searchedTokenListing[indexPath.row].id == 0 : tokenListing[indexPath.row].id == 0  {
                    self.selectedTokenListing = []
                    ProductFilterVM.shared.selectedTokenListing = []
                    self.selectedTokenListing = []
                } else {
                    self.removeSelectedPower(model: isSearchOn ? self.searchedTokenListing[indexPath.row] : tokenListing[indexPath.row] )
                    if ProductFilterVM.shared.selectedTokenListing.endIndex == (tokenListing.endIndex ) - 1 && ProductFilterVM.shared.selectedTokenListing.contains(where: {$0.id == 0}){
                        ProductFilterVM.shared.selectedTokenListing.remove(at: ProductFilterVM.shared.selectedTokenListing.firstIndex(where: {$0.id == 0}) ?? 0)
                        self.selectedTokenListing.remove(at: ProductFilterVM.shared.selectedTokenListing.firstIndex(where: {$0.id == 0}) ?? 0)
                    } else{}
                }
            } else {
                if isSearchOn ? self.searchedTokenListing[indexPath.row].id == 0 : tokenListing[indexPath.row].id == 0   {
                    ProductFilterVM.shared.selectedTokenListing = tokenListing
                    self.selectedTokenListing = tokenListing
                } else {
                    if ProductFilterVM.shared.selectedTokenListing.endIndex == (tokenListing.endIndex ) - 2{
                        ProductFilterVM.shared.selectedTokenListing = tokenListing
                        self.selectedTokenListing = tokenListing
                    } else{
                        ProductFilterVM.shared.selectedTokenListing.append(isSearchOn ? self.searchedTokenListing[indexPath.row] : tokenListing[indexPath.row] )
                        self.selectedTokenListing.append(isSearchOn ? self.searchedTokenListing[indexPath.row] : tokenListing[indexPath.row] )
                    }
                }
            }
        }
        self.tableView.reloadData()
    }
}

//MARK:- UISearchBarDelegate
//========================================
extension CurrencyVC: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if tokenType == .Asset {
            self.isSearchOn = !searchText.isEmpty
            self.searchText = searchText
        } else {
            self.isSearchOn = !searchText.isEmpty
            self.searchText = searchText
        }
    }

    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }

    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        if let text = searchBar.text,!text.byRemovingLeadingTrailingWhiteSpaces.isEmpty{
            self.isSearchOn = true
        }else{
            self.isSearchOn = false
        }
        searchBar.resignFirstResponder()
        return true
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar){
        searchBar.resignFirstResponder()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        if let text = searchBar.text,!text.byRemovingLeadingTrailingWhiteSpaces.isEmpty{
            self.isSearchOn = true
        }else{
            self.isSearchOn = false
        }
        searchBar.resignFirstResponder()
    }
}


extension CurrencyVC : PresenterOutputProtocol {

    func showSuccess(api: String, dataArray: [Mappable]?, dataDict: Mappable?, modelClass: Any) {
        if let addionalModel = dataDict as? AssetTokenTypeEntity{
            var category = AssetTokenTypeModel()
            category.id = 0
            category.name = "All"
            if tokenType == .Asset {
                assetsListing = addionalModel.data ?? []
                assetsListing.insert(category, at: 0)
                ProductFilterVM.shared.assetsListing = assetsListing
            } else {
                tokenListing = addionalModel.data ?? []
                tokenListing.insert(category, at: 0)
                ProductFilterVM.shared.tokenListing = tokenListing
            }
        }
        self.tableView.reloadData()
    }

    func showError(error: CustomError) {
        ToastManager.show(title:  nullStringToEmpty(string: error.localizedDescription.trimString()), state: .success)

    }

}
