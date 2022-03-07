//
//  SliderCollectionViewCell.swift
//  SharePastExam
//
//  Created by 馬場大夢 on 2021/10/21.
//

import UIKit
import FirebaseStorage

class SliderCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var sliderImage: UIImageView!
    @IBOutlet weak var sliderText: UILabel!
    
    var path:String  = ""{
        didSet{
            print("パスの変更を表示")
            print(self.path)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print("awakeしています")
        print(self.path)
        //self.getPastDocuments()
        layer.cornerRadius = 15
        backgroundColor = .purple
    }
    
    public func getPastDocuments(){
        if self.path != ""{
            //アクセス方法が多いのですが、
            let path_dep = self.path.components(separatedBy: "/")
            let FireStorage_Path = Storage.storage().reference(withPath: "gs://sharepastexamapp.appspot.com").child("images").child("\(path_dep[0])").child("\(path_dep[1])").child("\(path_dep[2]).jpeg")
            FireStorage_Path.getData(maxSize: 1024*1024*10){ (data,err) in
                if data != nil{
                    self.sliderImage.image = UIImage(data: data!)!
                }
                else{
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
