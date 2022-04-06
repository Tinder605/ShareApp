//
//  goodCollectionViewCell.swift
//  SharePastExam
//
//  Created by 馬場大夢 on 2021/10/13.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore
import Firebase
import Kingfisher

class goodCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var goodCollectionViewCell: UIImageView!
    @IBOutlet weak var subName: UILabel!
    @IBOutlet weak var posterName: UILabel!
    @IBOutlet weak var goodCount: UILabel!
    @IBAction func ActionGoodButton(_ sender: Any) {
        
    }
    
    var subjection:String = ""
    var times:String = ""
    var count:String = ""
    static let identifier = "goodCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if self.subjection != "" && self.times != "" && self.count != ""{
            
            print(self.subjection)
            self.getGoodDocuments()
        }
        else{
            goodCollectionViewCell.image = UIImage()
        }
    }
    private func getGoodDocuments(){
        print("正しく作用はしています")
        let ref = Firestore.firestore().collection("images").document(self.subjection).collection("times").document(self.times).collection("count").document(self.count)
        ref.getDocument(){ (snapshot, err) in
            if err != nil{
                print("err")
                self.updateGoodDoc()
            }
            else{
                let cache = ImageCache.default
                let path = self.subjection + "/" + self.times + "/" + self.count
                if cache.isCached(forKey: path){
                    cache.retrieveImage(forKey: path){ result in
                        switch result{
                        case .success(let value):
                            self.goodCollectionViewCell.image = value.image
                        case .failure(let err):
                            print(err)
                            self.goodCollectionViewCell.image = UIImage(named: "noimage.jpeg")
                        }
                        
                    }
                }
                else{
                    let imgref = Storage.storage().reference(forURL: "gs://sharepastexamapp.appspot.com").child(self.subjection).child(self.times).child("\(self.count).jpeg")
                    imgref.getData(maxSize: 1024*1024*100){ (imgdata,err) in
                        if imgdata != nil{
                            self.goodCollectionViewCell.image = UIImage(data: imgdata!)!
                            cache.store(UIImage(data: imgdata!)!, forKey: path)
                        }
                        else{
                            self.goodCollectionViewCell.image = UIImage(named: "noimage.jpeg")
                        }
                    }
                }
            }
        }
    }
   //エラーならそのリストについては削除する
    private func updateGoodDoc(){
        let docpath = "\(self.subjection)" + "/" + "\(self.times)" + "/" + "\(self.count)"
        print(docpath)
        let uid = Auth.auth().currentUser?.uid
        let userref = Firestore.firestore().collection("users").document(uid!)
        
        userref.getDocument(){ (snapshot,err) in
            if snapshot != nil{
                let data = snapshot?.data() as? [String:Any] ?? [:]
                var goodList = data["GoodList"] as? [String] ?? [""]
                
                if goodList.contains(docpath){
                    print("該当あり")
                    goodList.removeAll(where: {$0 == docpath})
                    userref.updateData(["GoodList":goodList]){ (err) in
                        if err != nil{
                            print("更新に失敗しています。")
                            print(err.debugDescription)
                        }
                        else{
                            print("更新完了")
                        }
                    }
                }
            }
            if err != nil{
                print("予期せぬエラーが生じました。")
            }
        }
    }

    public func configure(with image: UIImage) {
        goodCollectionViewCell.image = image
    }
    static func nib() -> UINib {
        return UINib(nibName: "goodCollectionViewCell", bundle: nil)
    }

}
