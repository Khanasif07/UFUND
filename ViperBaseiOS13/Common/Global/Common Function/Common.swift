//
//  Common.swift
//  User
//
//  Created by imac on 1/1/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit
import MessageUI


class Common {
    
    class func isValid(email : String)->Bool{
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@","[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}")
        return emailTest.evaluate(with: email)
        
    }
    
    class func getBackButton()->UIBarButtonItem{
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        return backItem// This will show in the next view controller being pushed
    }
    
    
    class func getCurrentCode()->String?{
        
       return (Locale.current as NSLocale).object(forKey:  NSLocale.Key.countryCode) as? String
  
    }
    
    
    
    //MARK:- Get Countries from JSON
    
    class func getCountries()->[Country]{
        
        var source = [Country]()
        
        if let data = NSData(contentsOfFile: Bundle.main.path(forResource: "countryCodes", ofType: "json") ?? "") as Data? {
            do{
                source = try JSONDecoder().decode([Country].self, from: data)
                
            } catch let err {
                print(err.localizedDescription)
            }
        }
        return source
    }
    
    
    
    class func getRefreshControl(intableView tableView : UITableView, tintcolorId  : Int = Color.primary.rawValue, attributedText text : NSAttributedString? = nil)->UIRefreshControl{
       
        let rc = UIRefreshControl()
        rc.tintColorId = tintcolorId
        rc.attributedTitle = text
        tableView.addSubview(rc)
        return rc
        
    }
    
    // MARK:- Set Font
    

   // MARK:- Set Font
   
   class func setFont(to field :Any,isTitle : Bool = false, size : CGFloat = 0, fontType : FontCustom = .bold) {
       
       let customSize = size > 0 ? size : (isTitle ? size : size)
       let font = UIFont(name: fontType.rawValue, size: customSize)
       
       switch (field.self) {
       case is UITextField:
           (field as? UITextField)?.font = font
       case is UILabel:
           (field as? UILabel)?.font = font
       case is UIButton:
           (field as? UIButton)?.titleLabel?.font = font
       case is UITextView:
           (field as? UITextView)?.font = font
       default:
           break
       }
       
   }
    
    
    // MARK:- Make Call
    class func call(to number : String?) {
        
        if let providerNumber = number, let url = URL(string: "tel://\(providerNumber)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            
             ToastManager.show(title: nullStringToEmpty(string: Constants.string.cannotMakeCallAtThisMoment.localize()) , state: .error)
        }
        
    }
    
    // MARK:- Send Email
    class func sendEmail(to mailId : [String], from view : UIViewController & MFMailComposeViewControllerDelegate) {
        
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = view
            mail.setToRecipients(mailId)
            view.present(mail, animated: true)
        } else {
             ToastManager.show(title: nullStringToEmpty(string: Constants.string.couldnotOpenEmailAttheMoment.localize()) , state: .error)
        }
        
    }
    
    // MARK:- Send Message
    
    class func sendMessage(to numbers : [String], text : String, from view : UIViewController & MFMessageComposeViewControllerDelegate) {
        
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.body = text
            controller.recipients = numbers
            controller.messageComposeDelegate = view
            view.present(controller, animated: true, completion: nil)
        }
    }
    
    // MARK:- Bussiness Image Url
    class func getImageUrl (for urlString : String?)->String {
        
        return baseUrl+"/storage/"+String.removeNil(urlString)
    }
    
    
    //MARK: Timestamp fomater
    class func formateDate(date: String?) -> String? {
        
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale // save locale temporarily
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from: nullStringToEmpty(string: date))!
        dateFormatter.dateFormat = "dd-MM-yyyy" //hh:mm:ss"
        dateFormatter.locale = tempLocale // reset the locale
        let dateString = dateFormatter.string(from: date)
        print("EXACT_DATE : \(dateString)")
        
        return nullStringToEmpty(string: dateString)
    }
    
    
    //Create QRCode Image
    class func CreateQrCodeForyourString (string:String)-> UIImage{
        let stringData = string.data(using: .utf8, allowLossyConversion: false)
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setValue(stringData, forKey: "inputMessage")
        filter?.setValue("H", forKey: "inputCorrectionLevel")
        let qrCIImage = filter?.outputImage
        let colorFilter = CIFilter(name: "CIFalseColor")!
        colorFilter.setDefaults()
        colorFilter.setValue(qrCIImage, forKey: "inputImage")
        colorFilter.setValue(CIColor(red: 0, green: 0, blue: 0), forKey: "inputColor0")
        colorFilter.setValue(CIColor(red: 1, green: 1, blue: 1), forKey: "inputColor1")
        
        let codeImage = UIImage(ciImage: (colorFilter.outputImage!.transformed(by: CGAffineTransform(scaleX: 5, y: 5))))
        return codeImage
    }
    
}


public func nullStringToEmpty(string: String?) -> String {
    
    if string == nil {
        return ""
    }
    else {
        return string!
    }
}


//MARK: Timestamp fomater
extension Date {
    func toMillis() -> Int64! {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}


//Image tint colour change
public func withRenderingMode(originalImage: UIImage, imgView: UIImageView, imgTintColur: UIColor) {
    
    let tintedImage = originalImage.withRenderingMode(.alwaysTemplate)
    imgView.tintColor = imgTintColur
    imgView.image = tintedImage
    
}


extension UIView{
    ///Rounds corners based on the layer
    func roundCorners(_ corner: CACornerMask, radius: CGFloat) {
        layer.cornerRadius = radius
        layer.maskedCorners = corner
        layer.masksToBounds = true
    }
}

enum VerticalLocation: String {
    case bottom
    case top
}

extension UIView {
    func addShadowToTopOrBottom(location: VerticalLocation, color: UIColor, opacity: Float = 0.5, radius: CGFloat = 5.0) {
        switch location {
        case .bottom:
             addShadow(offset: CGSize(width: 0, height: 5), color: color, opacity: opacity, radius: radius)
        case .top:
            addShadow(offset: CGSize(width: 0, height: -5), color: color, opacity: opacity, radius: radius)
        }
    }

    func addShadow(offset: CGSize, color: UIColor = .black, opacity: Float = 0.5, radius: CGFloat = 5.0) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
    }
    
    func addShadowRounded(cornerRadius: CGFloat, maskedCorners: CACornerMask = [.layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner], color: UIColor, offset: CGSize, opacity: Float, shadowRadius: CGFloat) {
           self.layer.cornerRadius = cornerRadius
           self.layer.maskedCorners = maskedCorners
           self.layer.shadowColor = color.cgColor
           self.layer.shadowOffset = offset
           self.layer.shadowOpacity = opacity
           self.layer.shadowRadius = shadowRadius
       }
    
    //Drop Shadow
    func drawDropShadow(color : UIColor, is3DView: Bool = false) {
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 5
        self.layer.masksToBounds = false
        if is3DView {
            self.layer.shadowOpacity = 0.35
            self.layer.shadowPath = UIBezierPath(rect: CGRect(x: 10,
                                                              y: (bounds.maxY - layer.shadowRadius) + 5,
                                                              width: bounds.width - 20,
                                                              height: layer.shadowRadius + 10)).cgPath
        }
    }
    
    func dropShadow(cornerRadius: CGFloat, maskedCorners: CACornerMask = [.layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner], color: UIColor, offset: CGSize, opacity: Float, shadowRadius: CGFloat) {
//         self.layer.masksToBounds = true
         self.layer.cornerRadius = cornerRadius
         self.layer.maskedCorners = maskedCorners
         self.layer.shadowColor = color.cgColor
         self.layer.shadowOffset = offset
         self.layer.shadowOpacity = opacity
         self.layer.shadowRadius = shadowRadius
     }
    
    func addShadowUsingBiezerPath(shadowColor: UIColor, offSet: CGSize, opacity: Float, shadowRadius: CGFloat, cornerRadius: CGFloat, corners: UIRectCorner, fillColor: UIColor = .white) {
            
            let shadowLayer = CAShapeLayer()
            let size = CGSize(width: cornerRadius, height: cornerRadius)
            let cgPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: size).cgPath //1
            shadowLayer.path = cgPath //2
            shadowLayer.fillColor = fillColor.cgColor //3
            shadowLayer.shadowColor = shadowColor.cgColor //4
            shadowLayer.shadowPath = cgPath
            shadowLayer.shadowOffset = offSet //5
            shadowLayer.shadowOpacity = opacity
            shadowLayer.shadowRadius = shadowRadius
            self.layer.addSublayer(shadowLayer)
        }
    
    
}
