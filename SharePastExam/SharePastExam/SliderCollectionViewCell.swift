//
//  SliderCollectionViewCell.swift
//  SharePastExam
//
//  Created by 馬場大夢 on 2021/10/21.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore
import Kingfisher

class SliderCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var sliderImage: UIImageView!
    @IBOutlet weak var slider_sub_name:UILabel!
    @IBOutlet weak var sliderText: UILabel!
    @IBOutlet weak var slider_poster_name: UILabel!
    
    
    var path:String  = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        print("awakeしています")
//        print(self.path)
        self.getPastDocuments()
        layer.cornerRadius = 15
        //backgroundColor = .purple
    }
    
    public func getPastDocuments(){
        if self.path != ""{
            //アクセス方法が多いのですが、
            let path_dep = self.path.components(separatedBy: "/")
            //ドキュメントの取得
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
                    let sliderSubName = path_dep[0]
                    let sliderSubCount = path_dep[1]
                    let sliderPosterName = path_dep[2]
                    self.sliderText.text = titletext
                    self.slider_sub_name.text = "【" + sliderSubName + "/" + sliderSubCount + "】"
                    
                    self.slider_poster_name.text = "投稿者:" + sliderPosterName + "--"
                    // labelはUILabelのインスタンスとする
                    self.slider_sub_name.numberOfLines = 0;
                }
                
            }
            let cache = ImageCache.default
            if cache.isCached(forKey: self.path){
                cache.retrieveImage(forKey: self.path){ result in
                    switch result{
                    case .success(let value):
                        print("キャッシュを利用しています")
                        self.sliderImage.image = value.image
                    case .failure(let err):
                        print(err)
                        self.sliderImage.image = UIImage(named: "noimage.jpeg")!
                    }
                }
            }
            else{
                
                let FireStorage_Path = Storage.storage().reference(forURL: "gs://sharepastexamapp.appspot.com").child("images").child("\(path_dep[0])").child("\(path_dep[1])").child("\(path_dep[2]).jpeg")
                print(FireStorage_Path)
                FireStorage_Path.getData(maxSize: 1024*1024*1000){ (data,err) in
                    if data != nil{
                        self.sliderImage.image = UIImage(data: data!)!
                        cache.store(UIImage(data: data!)!, forKey: self.path)
                    }
                    else{
                        print(err)
                        print("失敗しています。")
                        //userDefaults内の削除
                        var cacheDoc = UserDefaults.standard.array(forKey: "RecentlyPath") as? [String] ?? []
                        print("気になる\(self.path)")
                        print("気になる\(cacheDoc)")
                        if cacheDoc.contains(self.path){
                            print(cacheDoc)
                            cacheDoc.removeAll(where: {$0 == self.path})
                            UserDefaults.standard.set(cacheDoc, forKey: "RecentlyPath")
                        }
                    }
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
