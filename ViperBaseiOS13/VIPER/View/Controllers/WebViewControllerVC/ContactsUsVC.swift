//
//  ContactsUsVC.swift
//  ViperBaseiOS13
//
//  Created by Admin on 12/08/21.
//  Copyright © 2021 CSS. All rights reserved.
//

import UIKit
import Foundation
import ObjectMapper

class ContactsUsVC: UIViewController {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var submitBtn: UIButton!
    // MARK: - Variable
    //==========================
    private lazy var loader  : UIView = {
             return createActivityIndicator(self.view)
         }()
    var descText : String?
    var sections : [String] = ["Name","Email will be send on this email","Description"]
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.submitBtn.layer.cornerRadius = 4.0
    }
    
    // MARK: - IBActions
    //===========================
    @IBAction func submitBtnAction(_ sender: Any) {
        if let name = User.main.name {
            if name.isEmpty {
                ToastManager.show(title: "Please enter name", state: .success)
                return
            }
        }
        if let email = User.main.email {
            if email.isEmpty {
                ToastManager.show(title: "Please enter email", state: .success)
                return
            }
        }
        if let message = descText {
            if message.isEmpty {
                ToastManager.show(title: "Please enter message here", state: .success)
                return
            }
        }
        self.postContactUs()
    }
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.popOrDismiss(animation: true)
    }
}

// MARK: - Extension For Functions
//===========================
extension ContactsUsVC {
    
    private func initialSetup() {
        self.setupTextAndFont()
        self.mainTableView.registerCell(with: UserProfileTableCell.self)
        self.mainTableView.registerCell(with: AddDescTableCell.self)
        self.mainTableView.delegate = self
        self.mainTableView.dataSource = self
    }
    
    func postContactUs() {
        self.loader.isHidden = false
        let params:[String:Any] = ["description": descText ?? "","userId": User.main.id]
        self.presenter?.HITAPI(api: Base.contact_Us.rawValue, params: params, methodType: .POST, modelClass: SuccessDict.self, token: true)
    }
    
    private func setupTextAndFont(){
    }
}


//MARK: - PresenterOutputProtocol

extension ContactsUsVC: PresenterOutputProtocol {
    
    func showSuccess(api: String, dataArray: [Mappable]?, dataDict: Mappable?, modelClass: Any){
        switch api {
        case Base.contact_Us.rawValue:
            self.loader.isHidden = true
            ToastManager.show(title: "You query has been sent to admin successfully.", state: .success)
        default:
            break
        }
    }
    
    func showError(error: CustomError) {
        self.loader.isHidden = true
        ToastManager.show(title:  nullStringToEmpty(string: error.localizedDescription.trimString()), state: .error)
    }
}


extension ContactsUsVC: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
}

extension ContactsUsVC: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        let text = textView.text?.byRemovingLeadingTrailingWhiteSpaces ?? ""
        self.descText = text
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return true
    }
}

// MARK: - Extension For TableView
//===========================
extension ContactsUsVC : UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sections.endIndex
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  UITableView.automaticDimension
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueCell(with: UserProfileTableCell.self, indexPath: indexPath)
            cell.textFIeld.delegate = self
            cell.titleLbl.text = self.sections[indexPath.row]
            cell.textFIeld.placeholder = self.sections[indexPath.row]
            cell.textFIeld.keyboardType = .default
            cell.textFIeld.isUserInteractionEnabled = false
            cell.textFIeld.text = User.main.name
            return cell
        case 1:
            let cell = tableView.dequeueCell(with: UserProfileTableCell.self, indexPath: indexPath)
            cell.textFIeld.delegate = self
            cell.titleLbl.text = self.sections[indexPath.row]
            cell.textFIeld.placeholder = self.sections[indexPath.row]
            cell.textFIeld.keyboardType = .default
            cell.textFIeld.isUserInteractionEnabled = false
            cell.textFIeld.text = User.main.email
            return cell
        case 2:
            let cell = tableView.dequeueCell(with: AddDescTableCell.self, indexPath: indexPath)
            cell.textView.delegate = self
            cell.textView.isUserInteractionEnabled = true
            cell.titleLbl.text = self.sections[indexPath.row]
            return cell
        default:
            return UITableViewCell()
        }
    }
}
    
    
