//
//  Image.swift
//  User
//
//  Created by CSS on 09/01/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit

extension UIImage {
    
    func resizeImage(newWidth: CGFloat) -> UIImage?{
        
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        self.draw(in: CGRect(origin: .zero, size: CGSize(width: newWidth, height: newHeight)))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    //MARK:- Image Comparision 
    
    func isEqual(to image : UIImage?) -> Bool {
        
        guard  image != nil, let imageData1 = image!.pngData()  else {
            return false
        }
        
        guard let imageData2 = self.pngData() else {
            return false
        }
        
        return imageData1 == imageData2
        
    }
    

    
}
