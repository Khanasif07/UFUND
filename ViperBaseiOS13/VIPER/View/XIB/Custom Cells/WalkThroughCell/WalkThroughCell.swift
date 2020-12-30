//
//  WalkThroughCell.swift
//
//

import UIKit

class WalkThroughCell: UICollectionViewCell {
    
    @IBOutlet weak var walkThroughImage:UIImageView!
    @IBOutlet weak var headingLabel:UILabel!
    @IBOutlet weak var contentLabel:UILabel!
    @IBOutlet weak var stackView: UIStackView!
  
    //Get current page index
    var currentPage = 0 {
        didSet {
            
            UIView.animate(withDuration: 0.1) {
                for view in self.stackView.subviews {
                    
                    for subView in view.subviews {
                        subView.setCornerRadius()
                        
                        if subView.tag == self.currentPage {
                            subView.backgroundColor = UIColor(hex: placeHolderColor)
                        }else{
                            subView.backgroundColor = UIColor(hex: lightTextColor)
                            
                        }
                        
                    }
                    
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        headingLabel.textColor = UIColor(hex: placeHolderColor)
        contentLabel.textColor = UIColor(hex: lightTextColor)
        
    }

    func setValues(image: UIImage,heading:String,content:String) {
        headingLabel.text = heading
        contentLabel.text = content
        walkThroughImage.image = image
    }

}
