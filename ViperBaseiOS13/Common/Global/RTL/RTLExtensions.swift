//
//  RTLExtensions.swift
//  Blablacar
//


import Foundation
import UIKit


//MARK:- RTL Global Methods
class RTL: NSObject {
    class func ChangeLocalization() {
        
        MethodSwizzleGivenClassName(cls: UIApplication.self, originalSelector: #selector(getter: UIApplication.userInterfaceLayoutDirection), overrideSelector: #selector(getter: UIApplication.cstm_userInterfaceLayoutDirection))
        MethodSwizzleGivenClassName(cls: UITextField.self, originalSelector: #selector(UITextField.layoutSubviews), overrideSelector: #selector(UITextField.cstmlayoutSubviews))
        MethodSwizzleGivenClassName(cls: UILabel.self, originalSelector: #selector(UILabel.layoutSubviews), overrideSelector: #selector(UILabel.cstmlayoutSubviews))
        MethodSwizzleGivenClassName(cls: UIView.self, originalSelector: #selector(UIView.layoutSubviews), overrideSelector: #selector(UIView.customlayoutSubviews))


    }
}

/// Exchange the implementation of two methods of the same Class
func MethodSwizzleGivenClassName(cls: AnyClass, originalSelector: Selector, overrideSelector: Selector) {
    let origMethod: Method = class_getInstanceMethod(cls, originalSelector)!;
    let overrideMethod: Method = class_getInstanceMethod(cls, overrideSelector)!;
    if (class_addMethod(cls, originalSelector, method_getImplementation(overrideMethod), method_getTypeEncoding(overrideMethod))) {
        class_replaceMethod(cls, overrideSelector, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    } else {
        method_exchangeImplementations(origMethod, overrideMethod);
    }
}


extension UILabel {
    
    //MARK: - RTL For Label
    @objc public func cstmlayoutSubviews() {
        self.cstmlayoutSubviews()
        if self.isKind(of: NSClassFromString("UITextFieldLabel")!) {
            return // handle special case with uitextfields
        }
        if self.tag < 0  {
            self.textAlignment = (selectedLanguage == .arabic ? .right : .left)
        }
        /*if self.tag == 0 {
         self.textAlignment = (selectedLanguage == .arabic ? .right : .left)
         }*/
    }
}


extension UITextField {
    
    //MARK: - RTL For Textfield
    @objc public func cstmlayoutSubviews() {
        self.cstmlayoutSubviews()
        if self.tag <= 0 {
            self.textAlignment = (selectedLanguage == .arabic ? .right : .left)
            
        }
    }
}


extension UIApplication {
    
    //MARK: - RTL For User Interface
    @objc var cstm_userInterfaceLayoutDirection : UIUserInterfaceLayoutDirection {
        get {
            var direction = UIUserInterfaceLayoutDirection.leftToRight
            if selectedLanguage == .arabic {
                direction = .rightToLeft
            }
            return direction
        }
    }
    
    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
           
           if let nav = base as? UINavigationController {
               return topViewController(base: nav.visibleViewController)
           }
           
           if let tab = base as? UITabBarController {
               
               let moreNavigationController = tab.moreNavigationController
               
               if let top = moreNavigationController.topViewController, top.view.window != nil {
                   return topViewController(base: top)
               } else if let selected = tab.selectedViewController {
                   return topViewController(base: selected)
               }
           }
           
           if let presented = base?.presentedViewController {
               return topViewController(base: presented)
           }
           
           return base
       }
}

//extension UIImageView {
//
//    //MARK: - RTL For Textfield
//    @objc public func cstmflip() {
//        self.cstmflip()
//        if self.tag <= 0 {
//            //self.textAlignment = (selectedLanguage == .arabic ? .right : .left)
//
//           // self.image?.imageFlippedForRightToLeftLayoutDirection()
//
//            self.semanticContentAttribute = (selectedLanguage == .arabic ? .forceRightToLeft : .forceLeftToRight)
//        }
//    }
//
//}

extension UIView {
    
    //MARK: - RTL For Textfield
    @objc public func customlayoutSubviews() {
        self.customlayoutSubviews()
        if selectedLanguage == .arabic {
            loopThroughSubViewAndFlipTheImageIfItsAUIImageView(subviews: self.subviews)
        }
    }
    
    func loopThroughSubViewAndFlipTheImageIfItsAUIImageView(subviews: [UIView]) {
        if subviews.count > 0 {
            for subView in subviews {
                if (subView is UIImageView) && subView.tag < 0 {
                    let toRightArrow = subView as! UIImageView
                    if let _img = toRightArrow.image {
                        toRightArrow.image = UIImage(cgImage: _img.cgImage!, scale:_img.scale , orientation: UIImage.Orientation.upMirrored)
                    }
                }
                loopThroughSubViewAndFlipTheImageIfItsAUIImageView(subviews: subView.subviews)
            }
        }
    }
}

extension UIImage {
    
    func flip() -> UIImage {
        
        let img = self.imageFlippedForRightToLeftLayoutDirection()
        return img
        
    }
    
}




