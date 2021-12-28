//
//  goodViewController.swift
//  SharePastExam
//
//  Created by 馬場大夢 on 2021/10/13.
//

import Foundation
import UIKit
import Firebase

class goodViewController: UIViewController {
    
    @IBOutlet weak var goodCollectionView: UICollectionView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.barTintColor = UIColor.rgb(red: 166, green: 252, blue: 132)
        guard let tabBarController = tabBarController else { return }
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.backgroundColor = UIColor.rgb(red: 166, green: 252, blue: 132)
        tabBarController.tabBar.standardAppearance = tabBarAppearance

        if #available(iOS 15.0, *) { // 新たに追加
            tabBarController.tabBar.scrollEdgeAppearance = tabBarAppearance
        }
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 123, height: 123)
        goodCollectionView.collectionViewLayout = layout
        goodCollectionView.register(goodCollectionViewCell.nib(), forCellWithReuseIdentifier: goodCollectionViewCell.identifier)
        goodCollectionView.delegate = self
        goodCollectionView.dataSource = self
    }

}

extension goodViewController:UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        print("you tapped me")
        
    }
}
extension goodViewController:UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 22
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:goodCollectionViewCell.identifier, for: indexPath) as! goodCollectionViewCell
        
        cell.configure(with: UIImage(named: "IMG_6906")!)
        
        return cell
    }
}

extension goodViewController:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 123, height: 123)
    }
}
