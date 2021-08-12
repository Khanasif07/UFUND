//
//  ContactsUsVC.swift
//  ViperBaseiOS13
//
//  Created by Admin on 12/08/21.
//  Copyright © 2021 CSS. All rights reserved.
//

import UIKit
import ObjectMapper

class ContactsUsVC: UIViewController {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var messageLbl: UILabel!
    @IBOutlet weak var emaillbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var emailTxtFieldView: UIView!
    @IBOutlet weak var nameTxtFieldView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var nameTxtFld: UITextField!
    @IBOutlet weak var emailTxtFld: UITextField!
    @IBOutlet weak var messgaeTextView: PlaceholderTextView!
    // MARK: - Variable
    //==========================
    private lazy var loader  : UIView = {
             return createActivityIndicator(self.view)
         }()
    var descText : String = ""
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.emailTxtFieldView.applyShadow(radius: 0)
        self.nameTxtFieldView.applyShadow(radius: 0)
        self.messgaeTextView.applyShadow(radius: 0)
        self.submitBtn.layer.cornerRadius = 4.0
    }
    
    // MARK: - IBActions
    //===========================
    @IBAction func submitBtnAction(_ sender: Any) {
        if let name = nameTxtFld.text {
            if name.isEmpty {
                ToastManager.show(title: "Please enter name", state: .success)
                return
            }
        }
        if let email = emailTxtFld.text {
            if email.isEmpty {
                ToastManager.show(title: "Please enter email", state: .success)
                return
            }
        }
        if let message = messgaeTextView.text {
            if message.isEmpty {
                ToastManager.show(title: "Please enter message here", state: .success)
                return
            }
        }
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
        [emailTxtFieldView,nameTxtFieldView,messgaeTextView].forEach { (view) in
            view.applyEffectToView()
        }
        nameTxtFld.delegate = self
        emailTxtFld.delegate = self
        messgaeTextView.delegate = self
    }
    
    func getContactUs() {
        self.loader.isHidden = false
        self.presenter?.HITAPI(api: Base.contact_Us.rawValue, params: nil, methodType: .GET, modelClass: ContactUsModelEntity.self, token: false)
    }
    
    private func setupTextAndFont(){
        [nameLbl,emaillbl,messageLbl].forEach { (lbl) in
            lbl.font =  isDeviceIPad ? .setCustomFont(name: .regular, size: .x18) : .setCustomFont(name: .regular, size: .x14)
        }
        self.titleLbl.font =  isDeviceIPad ? .setCustomFont(name: .bold, size: .x20) : .setCustomFont(name: .semiBold, size: .x16)
    }
}


//MARK: - PresenterOutputProtocol

extension ContactsUsVC: PresenterOutputProtocol {
    
    func showSuccess(api: String, dataArray: [Mappable]?, dataDict: Mappable?, modelClass: Any){
        switch api {
        case Base.contact_Us.rawValue:
            self.loader.isHidden = true
            let productModelEntity = dataDict as? ContactUsModelEntity
            if let productDict = productModelEntity?.data {
//                self.emailLbl.text = productDict.first?.details ?? ""
//                self.phoneLbl.text = productDict[1].details ?? ""
//                self.skypeLbl.text = productDict.last?.details ?? ""
//                self.contactUsLbl.text = productDict[2].details ?? ""
            }
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
        
    }
}
