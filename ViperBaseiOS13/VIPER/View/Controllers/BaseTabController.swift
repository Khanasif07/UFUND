//
//  BaseTabController.swift
//  ViperBaseiOS13
//
//  Created by Deepika on  19/11/19.
//  Copyright © 2019 css. All rights reserved.
//

import Foundation
import UIKit

class BaseTabController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.layer.shadowOffset = CGSize(width: 0, height: 0)
        tabBar.layer.shadowRadius = 5
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOpacity = 0.3
        tabBar.backgroundColor = UIColor.white
        UITabBar.appearance().barTintColor = UIColor(hex: appBGColor)
        UITabBar.appearance().unselectedItemTintColor = UIColor(hex: lightTextColor)
      
         
        
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
                
            case 1136:
                print("iPhone 5 or 5S or 5C")
                
            case 1334:
                
                print("iPhone 6/6S/7/8")
            case 1920, 2208:
                
                print("iPhone 6+/6S+/7+/8+")
            case 2436:
                
                print("iPhone X")
            default:
                
                print("unknown")
            }
            
        }
        
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
    }
    
}


