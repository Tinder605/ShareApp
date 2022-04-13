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
    
    var GoodDocumentsList:[String] = []
    
    
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
        
        //self.GetGoodDocuments()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.GetGoodDocuments()
    }
    private func GetGoodDocuments(){
        
        let uid = Auth.auth().currentUser?.uid
        let ref = Firestore.firestore().collection("users").document(uid!)
        
        ref.getDocument(){ (snapshot,err) in
            if let err = err{
                
            }
            let data = snapshot?.data() as? [String:Any] ?? [:]
            self.GoodDocumentsList = data["GoodList"] as? [String] ?? []
            if self.GoodDocumentsList.count == 0{
                let view = UIView()
                
                
            }
            self.goodCollectionView.reloadData()
        }
        
    }
}

extension goodViewController:UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? goodCollectionViewCell
        print("you tapped me")
        let storyboard = UIStoryboard(name: "SelectDocExtesion", bundle: nil)
        let nextscrenn = storyboard.instantiateViewController(withIdentifier: "SelectDocExtesion") as! SelectDocExtesionViewController
        nextscrenn.mainImage = cell?.goodCollectionViewCell.image as? UIImage ?? UIImage()
        nextscrenn.doctitle = cell?.posterTitle.text ?? "NoTitle"
        nextscrenn.PosrUserId = cell?.postuserid ?? ""
        nextscrenn.Goodvalue = 1
        self.present(nextscrenn, animated: true)
    
    }
}
extension goodViewController:UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.GoodDocumentsList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:goodCollectionViewCell.identifier, for: indexPath) as! goodCollectionViewCell
        
        let goodpath = self.GoodDocumentsList[indexPath.row]
        let goosep = goodpath.components(separatedBy: "/")
        cell.subjection = goosep[0]
        cell.times = goosep[1]
        cell.count = goosep[2]
        
        cell.configure(with: UIImage(named: "noimage.jpeg")!)
        cell.awakeFromNib()
        return cell
    }
}

extension goodViewController:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.view.frame.width
        let wid = (width-10)/2
        return CGSize(width: wid, height: 7*wid/5)
        
    }
    
}
