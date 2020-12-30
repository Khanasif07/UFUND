//
//  DatePickerViewController.swift
//  Project
//
//  Created by Deepika on 11/04/19.
//  Copyright © 2019 css. All rights reserved.
//

import UIKit

class DatePickerViewController: UIViewController {

    var endDate: Date?
    @IBOutlet weak var datePicker: UIDatePicker!
     var delegate: DateDelegate?
     var date = String()
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    var isFrom: String?
    override func viewDidLoad() {
        super.viewDidLoad()

        datePicker.datePickerMode = UIDatePicker.Mode.date
        datePicker.datePickerMode = .date
        //datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: 0, to: Date())
        datePicker.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
       
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setCustomFont()
        localize()
        
    }
    
    @IBAction func doneAction(_ sender: UIButton) {
        
        dismiss(animated:true, completion: { [weak self] in
            
            self?.delegate?.didReceiveDOB(isReceive: true, DOB: nullStringToEmpty(string: self?.date), isFrom: self?.isFrom, endDate: self?.endDate)
        })
        
    }
    @IBAction func cancelAction(_ sender: UIButton) {
        
        dismiss(animated:true, completion: { [weak self] in
            
            self?.delegate?.didReceiveDOB(isReceive: false,DOB: nullStringToEmpty(string: self?.date), isFrom: self?.isFrom,endDate: self?.endDate)
        })
    }
    
    @objc func handleDatePicker(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"//"dd-MM-yyyy"
        date = dateFormatter.string(from: sender.date)
        endDate = sender.date
        print("date",date)
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


//MARK: - Custom Font & String Localization.
extension DatePickerViewController {
    
    func localize() {
        
        cancelButton.setTitle(Constants.string.Cancel.localize(), for: .normal)
        doneButton.setTitle(Constants.string.Done.localize(), for: .normal)
        
    }
    
    func setCustomFont() {
        
        Common.setFont(to: cancelButton, isTitle: true, size: 14, fontType: .bold)
        Common.setFont(to: doneButton, isTitle: false, size: 14, fontType: .bold)
        
    }
}
