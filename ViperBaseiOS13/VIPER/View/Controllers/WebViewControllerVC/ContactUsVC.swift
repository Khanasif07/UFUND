//
//  ContactUsVC.swift
//  ViperBaseiOS13
//
//  Created by Admin on 05/05/21.
//  Copyright © 2021 CSS. All rights reserved.
//


import UIKit
import ObjectMapper

class ContactUsVC: UIViewController {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var phoneTxtField: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var emailTxtFld: UITextField!
    @IBOutlet weak var skypTxtFld: UITextField!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var msgTxtView: PlaceholderTextView!
    
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
//        containerView.addShadowRounded(cornerRadius: 5, color: UIColor.black16, offset: CGSize(width: 0.5, height: 0.5), opacity: 1, shadowRadius: 5)
        self.submitBtn.layer.cornerRadius = 5.0
    }
    
    // MARK: - IBActions
    //===========================
    @IBAction func submitBtnAction(_ sender: UIButton) {
        self.getLogout()
    }
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.popOrDismiss(animation: true)
    }

}

// MARK: - Extension For Functions
//===========================
extension ContactUsVC {
    
    private func initialSetup() {
        self.setupTextAndFont()
    }
    
    func getLogout() {
        self.loader.isHidden = false
        var param = [String: AnyObject]()
        param[RegisterParam.keys.id] = User.main.id as AnyObject
        self.presenter?.HITAPI(api: Base.contact_Us.rawValue, params: param, methodType: .POST, modelClass: SuccessDict.self, token: true)
    }
    
    private func setupTextAndFont(){
        msgTxtView.isScrollEnabled = true
        self.emailTxtFld.delegate = self
        self.skypTxtFld.delegate = self
        self.phoneTxtField.delegate = self
        self.msgTxtView.delegate = self
        self.msgTxtView.isUserInteractionEnabled = true
        self.msgTxtView.isEditable = true
        self.phoneTxtField.keyboardType = .numberPad
        emailTxtFld.applyEffectToView()
        skypTxtFld.applyEffectToView()
        phoneTxtField.applyEffectToView()
        msgTxtView.applyEffectToView()
    }
}

// MARK: - Extension For CustomTextViewDelegate
//===========================
extension ContactUsVC : UITextViewDelegate , UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        return updatedText.count <= 25
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        return updatedText.count <= 250
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        let text = textView.text?.byRemovingLeadingTrailingWhiteSpaces ?? ""
        print(text)
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        let text = textView.text?.byRemovingLeadingTrailingWhiteSpaces ?? ""
        print(text)
    }
}

//MARK: - PresenterOutputProtocol

extension ContactUsVC: PresenterOutputProtocol {
    
    func showSuccess(api: String, dataArray: [Mappable]?, dataDict: Mappable?, modelClass: Any){
        
        switch api {
        case Base.contact_Us.rawValue:
            self.loader.isHidden = true
            self.popOrDismiss(animation: true)
        default:
            break
        }
    }
    
    func showError(error: CustomError) {
        self.loader.isHidden = true
        ToastManager.show(title:  nullStringToEmpty(string: error.localizedDescription.trimString()), state: .error)
    }
}
