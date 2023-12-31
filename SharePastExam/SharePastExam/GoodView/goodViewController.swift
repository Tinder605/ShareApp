//
//  goodViewController.swift
//  SharePastExam
//
//  Created by 馬場大夢 on 2021/10/13.
//

import Foundation
import UIKit
import Firebase

class goodViewController: UIViewController,UIAdaptivePresentationControllerDelegate {
    
    @IBOutlet weak var goodCollectionView: UICollectionView!
    
    var GoodDocumentsList:[String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.barTintColor = UIColor.rgb(red: 166, green: 252, blue: 132)
        guard let tabBarController = tabBarController else { return }
        let tabBarAppearance = UITabBarAppearance()
        let navigationBarAppearance = UINavigationBarAppearance()
        
        //タブバーのカラー
        tabBarAppearance.backgroundColor = UIColor.rgb(red: 166, green: 252, blue: 132)
        tabBarController.tabBar.standardAppearance = tabBarAppearance
        
        navigationBarAppearance.backgroundColor = UIColor.rgb(red: 166, green: 252, blue: 132)
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        
        if #available(iOS 15.0, *) { // 新たに追加
            tabBarController.tabBar.scrollEdgeAppearance = tabBarAppearance
            navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
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
            if err != nil{
                print(err.debugDescription)
                self.GoodDocumentsList = []
            }
            let data = snapshot?.data() as? [String:Any] ?? [:]
            self.GoodDocumentsList = data["GoodList"] as? [String] ?? []
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
        nextscrenn.doctitle = cell?.titleLabel.text ?? "NoTitle"
        //nextscrenn.doctitle = cell?.posterTitle.text ?? "NoTitle"
        nextscrenn.PosrUserId = cell?.postuserid ?? ""
        nextscrenn.Goodvalue = 1
        nextscrenn.presentationController?.delegate = self
        let path = self.GoodDocumentsList[indexPath.row]
        var getPath = UserDefaults.standard.array(forKey: "RecentlyPath") ?? []
        if getPath.count != 0{
            getPath.insert(path, at: 0)
            let orderset = NSOrderedSet(array: getPath)
            getPath = orderset.array as! [String]
            if getPath.count>3{
                while getPath.count>3{
                    getPath.removeLast()
                }
                
            }
            print("getPath:" + "\(getPath)")
        }
        else{
            getPath = [path]
        }
        UserDefaults.standard.set(getPath, forKey: "RecentlyPath")
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

extension goodViewController{
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        print("dismissしました")
        self.GetGoodDocuments()
    }
}

