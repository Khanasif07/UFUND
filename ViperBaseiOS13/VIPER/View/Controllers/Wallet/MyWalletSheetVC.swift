//
//  MyWalletSheetVC.swift
//  ViperBaseiOS13
//
//  Created by Admin on 15/03/21.
//  Copyright © 2021 CSS. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class MyWalletSheetVC: UIViewController {
    // holdView can be UIImageView instead
    //MARK:- OUTLETS
    //==============
    @IBOutlet weak var bottomLayoutConstraint : NSLayoutConstraint!
    @IBOutlet weak var mainTableView: UITableView!
    
    //MARK:- VARIABLE
    //================
    lazy var swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(closePullUp))
    var fullView: CGFloat {
        return 70.0
    }
    var textContainerHeight : CGFloat? {
        didSet{
            self.mainTableView.reloadData()
        }
    }
    var partialView: CGFloat {
        return UIScreen.main.bounds.height - (2 * UIApplication.shared.statusBarFrame.height)
//        return 163.0 + UIApplication.shared.statusBarFrame.height
    }
    //MARK:- VIEW LIFE CYCLE
    //======================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard self.isMovingToParent else { return }
        UIView.animate(withDuration: 0.6, animations: { [weak self] in
            let frame = self?.view.frame
            let yComponent = self?.partialView
            self?.view.frame = CGRect(x: 0, y: yComponent!, width: frame!.width, height: frame!.height)
        })
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func rightButton(_ sender: AnyObject) {
        print("clicked")
    }
    
    @IBAction func close(_ sender: AnyObject) {
        UIView.animate(withDuration: 0.3, animations: {
            let frame = self.view.frame
            self.view.frame = CGRect(x: 0, y: self.partialView, width: frame.width, height: frame.height)
        })
    }
    
    @objc func panGesture(_ recognizer: UIPanGestureRecognizer) {
        
        let translation = recognizer.translation(in: self.view)
        let velocity = recognizer.velocity(in: self.view)
        let y = self.view.frame.minY
        if ( y + translation.y >= fullView) && (y + translation.y <= partialView ) {
            self.view.frame = CGRect(x: 0, y: y + translation.y, width: view.frame.width, height: view.frame.height)
            recognizer.setTranslation(CGPoint.zero, in: self.view)
        }
        
        if recognizer.state == .ended {
            var duration =  velocity.y < 0 ? Double((y - fullView) / -velocity.y) : Double((partialView - y) / velocity.y )
            
            duration = duration > 1.3 ? 1 : duration
            
            UIView.animate(withDuration: duration, delay: 0.0, options: [.allowUserInteraction], animations: {
                if  velocity.y >= 0 {
                    self.view.frame = CGRect(x: 0, y: self.partialView, width: self.view.frame.width, height: self.view.frame.height)
//                    self.holdView.alpha = 1.0
//                    self.listingCollView.alwaysBounceVertical = false
                } else {
                    self.view.frame = CGRect(x: 0, y: self.fullView, width: self.view.frame.width, height: self.view.frame.height)
//                    self.holdView.alpha = 1.0
//                    self.listingCollView.alwaysBounceVertical = true
                }
                
            }) { (completion) in
            }
        }
    }
    
    func roundViews() {
//        holdView.layer.cornerRadius = 3
    }
}

//MARK:- Private functions
//========================
extension MyWalletSheetVC {
    
    private func initialSetup() {
        setupTableView()
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(BottomSheetVC.panGesture))
        view.addGestureRecognizer(gesture)
        roundViews()
        setupSwipeGesture()
    }
    
    private func setupTableView() {
        self.mainTableView.isUserInteractionEnabled = false
//        let nibPost = UINib(nibName: XIB.Names.ProductsCollectionCell, bundle: nil)
//        listingCollView.register(nibPost, forCellWithReuseIdentifier: XIB.Names.ProductsCollectionCell)
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .vertical
//        listingCollView.collectionViewLayout = layout
//        layout.minimumInteritemSpacing = 0
//        layout.minimumLineSpacing = 0
//        listingCollView.alwaysBounceHorizontal = false
//        listingCollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    private func setupSwipeGesture() {
        swipeDown.direction = .down
        swipeDown.delegate = self
        mainTableView.addGestureRecognizer(swipeDown)
    }
    
    @objc func closePullUp() {
        UIView.animate(withDuration: 0.3, animations: {
            let frame = self.view.frame
            self.view.frame = CGRect(x: 0, y: self.partialView, width: frame.width, height: frame.height)
//            self.holdView.alpha = 1.0
        })
    }
}



//MARK:- Gesture Delegates
//========================
extension MyWalletSheetVC : UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        //Identify gesture recognizer and return true else false.
        if (!mainTableView.isDragging && !mainTableView.isDecelerating) {
            return gestureRecognizer.isEqual(self.swipeDown) ? true : false
        }
        return false
    }
}
