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

class goodCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var goodCollectionViewCell: UIImageView!
    
    
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
        ref.getDocument(){ (snapshot,err) in
            if let err = err{
                print("エラーです")
            }
            else{
                if snapshot?.data() != nil{
                    print("非同期処理は起きています")
                    let gooddata = snapshot?.data() as? [String:Any] ?? [:]
                    let Goodurl = gooddata["imageurl"] as? String ?? " "
                    print(Goodurl)
                    if Goodurl == " "{
                        self.goodCollectionViewCell.backgroundColor = .red
                    }
                    else{
                        print("urlの表示")
                        let url = URL(string: Goodurl)
                        print(url)
                        if url != nil{
                            print("こっちなのかい？")
                            do{
                                let data = try Data(contentsOf: url!)
                                self.goodCollectionViewCell.image = UIImage(data: data)!
                            }catch{
                                self.goodCollectionViewCell.image = UIImage()
                                self.goodCollectionViewCell.backgroundColor = .red
                            }
                        }
                        else{
                            self.goodCollectionViewCell.image = UIImage(named: "IMG_6906")!
                        }
                    }
                 }
                else{
                    print("noimage側に来ています。")
                    self.goodCollectionViewCell.image = UIImage(named: "noimage.jpeg")!
                    self.updateGoodDoc()
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
