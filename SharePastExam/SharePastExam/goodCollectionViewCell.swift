//
//  goodCollectionViewCell.swift
//  SharePastExam
//
//  Created by 馬場大夢 on 2021/10/13.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore

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
    }

    public func configure(with image: UIImage) {
        goodCollectionViewCell.image = image
    }
    static func nib() -> UINib {
        return UINib(nibName: "goodCollectionViewCell", bundle: nil)
    }

}
