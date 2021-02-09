//
//  UserProfileVC.swift
//  ViperBaseiOS13
//
//  Created by Admin on 08/02/21.
//  Copyright © 2021 CSS. All rights reserved.
//

import UIKit

class UserProfileVC: UIViewController {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var mainTableView: UITableView!
    
    // MARK: - Variables
    //===========================
    var countryCode: String  = "+91"
    var generalInfoArray = [("First Name","Asif Khan"),("Last Name",""),("Phone Number",""),("Email",""),("Address Line1",""),("Address Line 2",""),("ZipCode",""),("City",""),("State",""),("Country","")]
    var bankInfoArray = [("Bank Name","Asif Khan"),("Account Name",""),("Account Number",""),("Routing Number",""),("IBAN Number",""),("Swift Number",""),("Account currency",""),("Bank Address","")]
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    // MARK: - IBActions
    //===========================
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}

// MARK: - Extension For Functions
//===========================
extension UserProfileVC {
    
    private func initialSetup() {
        self.mainTableView.registerCell(with: UserProfilePhoneNoCell.self)
        self.mainTableView.registerCell(with: UserProfileImageCell.self)
        self.mainTableView.registerCell(with: UserProfileTableCell.self)
        self.mainTableView.registerHeaderFooter(with: UserProfileHeaderView.self)
        self.mainTableView.delegate = self
        self.mainTableView.dataSource = self
    }
    
    private func present(to identifier : String) {
        let viewController = self.storyboard!.instantiateViewController(withIdentifier: identifier) as? CountryPickerVC
        viewController?.countryDelegate = self
        self.present(viewController!, animated: true, completion: nil)
    }
}

// MARK: - Extension For TableView
//===========================
extension UserProfileVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
           return 2
       }
       
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return generalInfoArray.endIndex + 1
        default:
            return bankInfoArray.endIndex
        }
       }
       
       func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
           let view = tableView.dequeueHeaderFooter(with: UserProfileHeaderView.self)
           view.titleLbl.text  = section == 0 ? "GENERAL" : "BANK DETAILS"
           return view
       }
       
       func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
       }
       
       func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
       }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueCell(with: UserProfileImageCell.self, indexPath: indexPath)
                return  cell
            default:
                if generalInfoArray[indexPath.row - 1].0 == "Phone Number" {
                    let cell = tableView.dequeueCell(with: UserProfilePhoneNoCell.self, indexPath: indexPath)
                    cell.countryPickerTapped = { [weak self] (sender) in
                        guard let selff = self else { return }
                        selff.present(to: Storyboard.Ids.CountryPickerVC)
                    }
                    cell.countryCodeLbl.text = self.countryCode
                    cell.phoneTextField.delegate = self
                    cell.titleLbl.text = self.generalInfoArray[indexPath.row - 1].0
                    cell.phoneTextField.placeholder = self.generalInfoArray[indexPath.row - 1].0
                    cell.phoneTextField.text = self.generalInfoArray[indexPath.row - 1].1
                    return  cell
                } else {
                    let cell = tableView.dequeueCell(with: UserProfileTableCell.self, indexPath: indexPath)
                    cell.textFIeld.delegate = self
                    cell.titleLbl.text = self.generalInfoArray[indexPath.row - 1].0
                    cell.textFIeld.placeholder = self.generalInfoArray[indexPath.row - 1].0
                    cell.textFIeld.text = self.generalInfoArray[indexPath.row - 1].1
                    return  cell
                }
            }
        default:
            let cell = tableView.dequeueCell(with: UserProfileTableCell.self, indexPath: indexPath)
            cell.titleLbl.text = self.bankInfoArray[indexPath.row ].0
            cell.textFIeld.placeholder = self.bankInfoArray[indexPath.row].0
            if cell.titleLbl.text ?? "" == "Account Currency" {
                cell.textFIeld.setButtonToRightView(btn: UIButton(), selectedImage: #imageLiteral(resourceName: "dropDownButton"), normalImage: #imageLiteral(resourceName: "dropDownButton"), size: CGSize(width: 20, height: 20))
            }
            cell.textFIeld.text = self.bankInfoArray[indexPath.row].1
            return  cell
        }
    }
}
 
// MARK: - Extension For TextField Delegate
//====================================
extension UserProfileVC : UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
          let text = textField.text?.byRemovingLeadingTrailingWhiteSpaces ?? ""
          let cell = mainTableView.cell(forItem: textField) as? UserProfileTableCell
        switch cell?.titleLbl.text ?? "" {
          case "First Name":
            print(text)
          case "Last Name":
              print(text)
          case "City":
              print(text)
          case "State":
              print(text)
          default:
              print(text)
          }
          
      }
      
      func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//          let cell = mainTableView.cell(forItem: textField) as? UserProfileTableCell
//          let currentString: NSString = textField.text! as NSString
//          let newString: NSString =
//              currentString.replacingCharacters(in: range, with: string) as NSString
          return true
//          switch textField {
//          case cell?.nameTxtField:
//              return (string.checkIfValidCharaters(.name) || string.isEmpty) && newString.length <= 50
//          case cell?.mobNoTxtField:
//              return (string.checkIfValidCharaters(.mobileNumber) || string.isEmpty) && newString.length <= 10
//          case cell?.emailIdTxtField:
//              return (string.checkIfValidCharaters(.email) || string.isEmpty) && newString.length <= 50
//          case cell?.passTxtField:
//              return (string.checkIfValidCharaters(.password) || string.isEmpty) && newString.length <= 25
//          case cell?.confirmPassTxtField:
//              return (string.checkIfValidCharaters(.password) || string.isEmpty) && newString.length <= 25
//          default:
//              return false
//          }
      }
}


extension UserProfileVC : CountryDelegate{
    func sendCountryCode(code: String) {
        self.countryCode = code
        self.mainTableView.reloadData()
    }
}
