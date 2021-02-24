//
//  AssetsFilterDateVC.swift
//  ViperBaseiOS13
//
//  Created by Admin on 24/02/21.
//  Copyright © 2021 CSS. All rights reserved.
//


import UIKit

class AssetsFilterDateVC: UIViewController {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var fromTextField: UITextField!
    @IBOutlet weak var toTextField: UITextField!
    
    // MARK: - Variables
    //===========================
    var  buttonView = UIButton()
    var  buttonView1 = UIButton()
    var tempTextField: UITextField?
    var txtFieldData : ((Date?, Date?)->())?
    var fromDate : Date? = nil {
        didSet {
            if let fDate = fromDate {
                fromTextField.text = getDateString(selectDate: fDate)
            }else {
                fromTextField.text = ""
            }
        }
    }
    var toDate : Date? = nil {
        didSet {
            if let tDate = toDate {
                toTextField.text = getDateString(selectDate: tDate)
            }else {
                toTextField.text = ""
            }
        }
    }
    private let datePicker : UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.maximumDate = Date().adjustedDate(.year, offset: 0)
        return picker
    }()
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        [fromTextField,toTextField].forEach({$0?.layer.cornerRadius = 8.0})
    }
    
    // MARK: - IBActions
    //===========================
    
    
}

// MARK: - Extension For Functions
//===========================
extension AssetsFilterDateVC {
    
    private func initialSetup() {
        buttonView1.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 5)
        buttonView.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 5)
        self.datePicker.addTarget(self, action: #selector(handleDatePicker(_:)), for: .valueChanged)
        fromTextField.setButtonToRightView(btn: buttonView, selectedImage: #imageLiteral(resourceName: "dropDownButton"), normalImage: #imageLiteral(resourceName: "dropDownButton"), size: CGSize(width: 20, height: 20))
        toTextField.setButtonToRightView(btn:   buttonView1, selectedImage: #imageLiteral(resourceName: "dropDownButton"), normalImage: #imageLiteral(resourceName: "dropDownButton"), size: CGSize(width: 20, height: 20))
        [fromTextField,toTextField].forEach({$0?.delegate = self})
        [fromTextField,toTextField].forEach({$0?.inputView = datePicker})
        [fromTextField,toTextField].forEach({$0?.borderColor = #colorLiteral(red: 0.8823529412, green: 0.8823529412, blue: 0.8823529412, alpha: 1)})
        [fromTextField,toTextField].forEach({$0?.placeholder = "Select date"})
        [fromTextField,toTextField].forEach({$0?.applyEffectToView(borderColor: #colorLiteral(red: 0.8823529412, green: 0.8823529412, blue: 0.8823529412, alpha: 1))})
    }
    
    private func getDateString(selectDate : Date)-> String {
        Date.dateFormatter.dateFormat = Date.DateFormat.dMMMyyyy.rawValue
        let date = Date.dateFormatter.string(from: selectDate)
        return date
    }
    
    @objc func handleDatePicker(_ sender: UIDatePicker) {
        tempTextField?.text = getDateString(selectDate: datePicker.date)
        if tempTextField == fromTextField {
            fromDate = datePicker.date
        }else {
            toDate = datePicker.date
        }
        
    }
}


extension AssetsFilterDateVC :UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField {
        case fromTextField:
            datePicker.date = fromDate ?? Date()
            fromDate = datePicker.date
            tempTextField = fromTextField
        case toTextField:
            if let _ = fromDate {
                datePicker.date = toDate ?? Date()
                datePicker.minimumDate = fromDate?.plus(days: 1)
                toDate = datePicker.date
                tempTextField = toTextField
            }else {
                toTextField.resignFirstResponder()
                ToastManager.show(title:  nullStringToEmpty(string: "Please Select From Date"), state: .success)
                return false
            }
            
        default:
            break
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        txtFieldData?(fromDate,toDate)
    }
}

