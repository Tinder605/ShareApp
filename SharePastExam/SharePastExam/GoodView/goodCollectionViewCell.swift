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
    
    //画像の縦、横
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    @IBOutlet weak var imageWidth: NSLayoutConstraint!
    
    //教科名の縦、横
    @IBOutlet weak var subHeight: NSLayoutConstraint!
    @IBOutlet weak var subWidth: NSLayoutConstraint!
    
    //タイトルの縦、横
    @IBOutlet weak var titleHeight: NSLayoutConstraint!
    @IBOutlet weak var titleWidth: NSLayoutConstraint!
    
    //投稿者の縦、横
    @IBOutlet weak var posterHeight: NSLayoutConstraint!
    @IBOutlet weak var posterWidth: NSLayoutConstraint!
    
    //いいね数、ボタンの縦、横
    @IBOutlet weak var goodHeight: NSLayoutConstraint!
    @IBOutlet weak var goodWidth: NSLayoutConstraint!
    
    @IBOutlet weak var goodCollectionViewCell: UIImageView!
    @IBOutlet weak var subName: UILabel!
    @IBOutlet weak var posterTitle: UILabel!
    @IBOutlet weak var posterName: UILabel!
    
    @IBOutlet weak var goodCount: UILabel!
    @IBOutlet weak var goodButton: UIButton!
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
            
            let width = UIScreen.main.bounds.width
            let height = UIScreen.main.bounds.height
            
            
            self.fittoView(size: (width-10)/2)
            self.goodButton.titleLabel?.text = ""
            self.goodButton.setTitle("", for: .normal)
            self.goodButton.imageView?.contentMode = .scaleAspectFit
            self.goodButton.contentVerticalAlignment = .fill
            self.goodButton.contentHorizontalAlignment = .fill
        }
    }
    
    //画像タイトル等の配置を設定
    private func fittoView(size:CGFloat){
        
        //imageHeight.constant = size/3
        //imageWidth.constant = size
        
        subHeight.constant = 2*size/21
        subWidth.constant = size
        
        titleHeight.constant = size/3
        titleWidth.constant = size
        
        posterHeight.constant = size/3
        posterWidth.constant = size
        
        goodHeight.constant = 2*size/21
        goodWidth.constant = size
        
        
        
        goodButton.titleLabel?.text = ""
        
        
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
                    
                    //授業名/回数
                    self.subName.text = "【" + self.subjection + "/" + self.times + "】"
                    // subNameを複数行で表示
                    self.subName.numberOfLines = 0;
                    
                    //投稿タイトル
                    //if let doctitle = testDataArray[indexPath.row].Title{
                        //self.posterTitle.text  = "\(doctitle)"
                    //}else{
                        //self.posterTitle.text = "No Title"
                    //}
                    
                    //投稿者名
                    //self.posterName.text = "投稿者:" + PosterName + "--"
                    
                    //いいね数表示
                    self.goodCount.text = self.count
                    
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
