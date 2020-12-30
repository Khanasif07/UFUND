//
//  CryptoReceiveViewController.swift
//  ViperBaseiOS13
//
//  Created by Deepika on 13/03/20.
//  Copyright © 2020 CSS. All rights reserved.
//

import UIKit

class CryptoReceiveViewController: UIViewController {

    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var copyButton: UIButton!
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var qrImg: UIImageView!
    @IBOutlet weak var coinNameLbl: UILabel!
    @IBOutlet weak var childView: UIView!
    
    var assets : DataAssets?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addressView.layer.borderWidth = 0.5
        addressView.layer.borderColor = UIColor(hex: primaryColor).cgColor
        
        let image = #imageLiteral(resourceName: "copy")
        copyButton.setImage(image.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
        copyButton.tintColor = UIColor(hex: primaryColor)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        coinNameLbl.text = nullStringToEmpty(string: assets?.symbol)
        addressLbl.text = nullStringToEmpty(string: assets?.address)
        qrImg.image =  Common.CreateQrCodeForyourString (string: nullStringToEmpty(string: assets?.address))
    }

    @IBAction func copyCryptoAddress(_ sender: UIButton) {
        
        UIPasteboard.general.string = nullStringToEmpty(string: assets?.address)
        ToastManager.show(title: nullStringToEmpty(string: Constants.string.copyClipboard.localize()), state: .success)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
         
        let touch = touches.first
        
        if touch?.view != self.childView {
            
            dismiss(animated: true, completion: nil)
            
        }
        
    }
    
}


