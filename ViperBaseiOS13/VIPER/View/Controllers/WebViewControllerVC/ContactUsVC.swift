//
//  ContactUsVC.swift
//  ViperBaseiOS13
//
//  Created by Admin on 05/05/21.
//  Copyright © 2021 CSS. All rights reserved.
//


import UIKit

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
    var descText : String = ""
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        containerView.addShadowRounded(cornerRadius: 5, color: UIColor.black16, offset: CGSize(width: 0.5, height: 0.5), opacity: 1, shadowRadius: 5)
        self.submitBtn.layer.cornerRadius = 5.0
    }
    
    // MARK: - IBActions
    //===========================
    @IBAction func submitBtnAction(_ sender: UIButton) {
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
    
    private func setupTextAndFont(){
        self.emailTxtFld.delegate = self
        self.skypTxtFld.delegate = self
        self.phoneTxtField.delegate = self
        self.msgTxtView.delegate = self
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
    
    func textViewDidEndEditing(_ textView: UITextView) {
        let text = textView.text?.byRemovingLeadingTrailingWhiteSpaces ?? ""
        print(text)
    }
}
