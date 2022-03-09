//
//  SliderCollectionViewCell.swift
//  SharePastExam
//
//  Created by 馬場大夢 on 2021/10/21.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore

class SliderCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var sliderImage: UIImageView!
    @IBOutlet weak var sliderText: UILabel!
    
    var path:String  = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        print("awakeしています")
//        print(self.path)
        self.getPastDocuments()
        layer.cornerRadius = 15
        backgroundColor = .purple
    }
    
    public func getPastDocuments(){
        if self.path != ""{
            //アクセス方法が多いのですが、
            let path_dep = self.path.components(separatedBy: "/")
            
            let firestore = Firestore.firestore().collection("images").document(path_dep[0]).collection("times").document(path_dep[1]).collection("count").document(path_dep[2])
            firestore.getDocument(){ (snapshot,err) in
                if let err = err{
                    print("失敗した")
                }
                else{
                    let data = snapshot?.data() as? [String:Any] ??
                    [:]
                    print("snapshot取得")
                    print(data["title"] as? String ?? "")
                    let titletext  = data["title"] as? String ?? ""
                    self.sliderText.text = titletext
                }
                
            }
            
            let FireStorage_Path = Storage.storage().reference(forURL: "gs://sharepastexamapp.appspot.com").child("images").child("\(path_dep[0])").child("\(path_dep[1])").child("\(path_dep[2]).jpeg")
            print(FireStorage_Path)
            FireStorage_Path.getData(maxSize: 1024*1024*1000){ (data,err) in
                if data != nil{
                    self.sliderImage.image = UIImage(data: data!)!
                }
                else{
                    print(err)
                    print("失敗しています。")
                }
            }
            
            
        }
    }
    public func configure(with image: UIImage) {
        sliderImage.image = image
    }
    public func configure(with text: String) {
        sliderText.text = text
    }
    
}
