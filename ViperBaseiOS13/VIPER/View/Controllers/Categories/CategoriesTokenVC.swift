//
//  CategoriesTokenVC.swift
//  ViperBaseiOS13
//
//  Created by Admin on 11/02/21.
//  Copyright © 2021 CSS. All rights reserved.
//

import UIKit

class CategoriesTokenVC: UIViewController {
    
    @IBOutlet weak var mainCollView: UICollectionView!
    var tokenCategories : [CategoryModel]?{
        didSet{
            self.mainCollView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
    }
    
    
    private func initialSetup(){
        self.mainCollView.delegate = self
        self.mainCollView.dataSource = self
        self.mainCollView.registerCell(with: ProductCollectionCell.self)
        let layout1 = UICollectionViewFlowLayout()
        layout1.scrollDirection = .vertical
        mainCollView.collectionViewLayout = layout1
        layout1.minimumInteritemSpacing = 0
        layout1.minimumLineSpacing = 0
    }
    
}

//MARK: - Collection view delegate
extension CategoriesTokenVC: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tokenCategories?.endIndex ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(with: ProductCollectionCell.self, indexPath: indexPath)
        cell.productName.text = self.tokenCategories?[indexPath.row].category_name ?? ""
        let imgEntity =  self.tokenCategories?[indexPath.row].image ?? ""
        let url = URL(string: baseUrl + "/" +  nullStringToEmpty(string: imgEntity))
        cell.productImg.sd_setImage(with: url , placeholderImage: nil)
        cell.backgroundColor = .clear
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 2 , height: 34 * collectionView.frame.height / 100)
    }
}
