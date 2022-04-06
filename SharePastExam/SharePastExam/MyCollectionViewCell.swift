//
//  MyCollectionViewCell.swift
//  SharePastExam
//
//  Created by 馬場大夢 on 2021/10/05.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore

class MyCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    var url = ""
    var cellpath = ""{
        didSet{
            print(self.cellpath)
        }
    }
    var title = ""
    var goodcount = 0
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    
    static let identifier = "MyCollectionViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        if self.cellpath != ""{
            let sep_cellpath = self.cellpath.components(separatedBy: "/")
            self.getPostPicture(sep_cellpath:sep_cellpath)
            self.getPostDocData(sep_cellpath: sep_cellpath)
        }
        
        
    }
    private func getPostPicture(sep_cellpath:[String]){
        
        let cell_storage = Storage.storage().reference(forURL: "gs://sharepastexamapp.appspot.com").child("images").child("\(sep_cellpath[0])").child("\(sep_cellpath[1])").child("\(sep_cellpath[2]).jpeg")
        cell_storage.getData(maxSize: 1024*1024*100){ (imgdata,err) in
            if imgdata != nil{
                print("きてはいます")
                self.imageView.image = UIImage(data: imgdata!)!
            }
            else{
                print("バッグている")
                print(err)
                self.imageView.image = UIImage(named: "noimage.jpeg")!
            }
        }
        
    }
    //各セルのドキュメント情報の所得(必要ないのかもしれない）
    private func getPostDocData(sep_cellpath:[String]){
        let ref = Firestore.firestore().collection("images").document(sep_cellpath[0]).collection("times").document(sep_cellpath[1]).collection("count").document(sep_cellpath[2])
        ref.getDocument(){(snapshot,err) in
            if snapshot != nil{
                let data = snapshot?.data() ?? [:]
                print("正しく所得したデータ")
                print(data["title"] as? String ?? "")
                self.title = data["title"] as? String ?? ""
                self.goodcount = data["good"] as? Int ?? 0
            }
        }
    }
    
    public func configure(with image: UIImage) {
        imageView.image = image

    }
    static func nib() -> UINib {
        return UINib(nibName: "MyCollectionViewCell", bundle: nil)
    }
    
}
