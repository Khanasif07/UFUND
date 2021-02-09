//
//  CountryPickerVC.swift
//  ViperBaseiOS13
//
//  Created by Admin on 09/02/21.
//  Copyright © 2021 CSS. All rights reserved.
//
import UIKit

class CountryPickerVC: UIViewController {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var searchTxtField: ATCTextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dropDownbutton: UIButton!
    
    // MARK: - Variables
    //===========================
    var viewModel = CountryVM()
    var countryDelegate: CountryDelegate?
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        viewModel.getCountyData()
    }
    
    // MARK: - IBActions
    //===========================
    @IBAction func cancelBtnAction(_ sender: UIButton) {
         self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func textFieldChanged(_ sender: UITextField) {
        viewModel.searchCountry = sender.text?.byRemovingLeadingTrailingWhiteSpaces ?? ""
        tableView.reloadData()
    }
}

// MARK: - Extension for functions
//====================================
extension CountryPickerVC {
    
    private func initialSetup() {
        self.textFieldSetUp()
        tableView.registerCell(with: CountryCodeTableCell.self)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func textFieldSetUp(){
//        self.dropDownbutton.tintColor = AppColors.fontPrimaryColor
//        let show1 = UIButton()
//        show1.isSelected = false
//        self.searchTxtField.setButtonToRightView(btn: show1, selectedImage: #imageLiteral(resourceName: "icon"), normalImage: #imageLiteral(resourceName: "icon"), size: CGSize(width: 30, height: 30))
    }
}


//MARK:-  UITableViewDelegate
//===========================
extension CountryPickerVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 51
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let cell =  tableView.cellForRow(at: indexPath) as? CountryCodeTableCell else{ return }
//        cell.countryCodeLabel.textColor = AppColors.fontPrimaryColor
//        cell.countryNameLabel.textColor = AppColors.fontPrimaryColor
        //
        countryDelegate?.sendCountryCode(code: "+" + "\(cell.countryCodeLabel.text ?? "+1")")
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK:-  UITableViewDataSource
//==========================
extension CountryPickerVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.searchedCountry.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(with: CountryCodeTableCell.self, indexPath: indexPath)
        if let name = viewModel.searchedCountry[indexPath.row][CountryVM.CountryKeys.name.rawValue], let code =   viewModel.searchedCountry[indexPath.row][CountryVM.CountryKeys.code.rawValue]{
            cell.countryNameLabel.text = name
            cell.countryCodeLabel.text = code
        }
        return cell
    }
}



//MARK:- ATCTextField
//==========================
class ATCTextField: UITextField {
    let padding = UIEdgeInsets(top: 0, left: 16.0, bottom: 0, right: 8)
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
