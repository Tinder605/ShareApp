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
    
    @IBOutlet weak var allCell: UIStackView!
    //画像の縦、横
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    @IBOutlet weak var imageWidth: NSLayoutConstraint!
    
    //教科名の縦、横
    @IBOutlet weak var subHeight: NSLayoutConstraint!
    @IBOutlet weak var subWidth: NSLayoutConstraint!
    
    //タイトルの縦、横
    //@IBOutlet weak var titleHeight: NSLayoutConstraint!
    //@IBOutlet weak var titleWidth: NSLayoutConstraint!
    
    //投稿者の縦、横
    @IBOutlet weak var posterHeight: NSLayoutConstraint!
    @IBOutlet weak var posterWidth: NSLayoutConstraint!
    
    
    @IBOutlet weak var goodCollectionViewCell: UIImageView!
    
    @IBOutlet weak var subName: UILabel!
    //@IBOutlet weak var posterTitle: UILabel!
    @IBOutlet weak var posterName: UILabel!

    
    var subjection:String = ""
    var times:String = ""
    var count:String = ""
    var postuserid:String = ""
    static let identifier = "goodCollectionViewCell"
    var titleLabel = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 10
        
        //フォントを横幅に合わせる
        self.subName.adjustsFontSizeToFitWidth = true
        self.posterName.adjustsFontSizeToFitWidth = true
        

        self.titleLabel = UILabel()
        //画像の上にタイトルを表示
        titleLabel.textAlignment = NSTextAlignment.left
        //titleLabel.text = self.posterTitle.text as? String
        titleLabel.textColor = .white
        //titleLabel.frame = CGRect(x: 0, y:self.goodCollectionViewCell.frame.height, width: self.goodCollectionViewCell.frame.width - 5, height: self.goodCollectionViewCell.frame.height-5)
        titleLabel.frame = CGRect(x: 5, y:4*self.goodCollectionViewCell.frame.height/5, width: self.goodCollectionViewCell.frame.width - 5, height: self.goodCollectionViewCell.frame.height-5)
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        //titleLabel.font = titleLabel.font.withSize(20)
        //self.titleLabel.adjustsFontSizeToFitWidth = true
        self.goodCollectionViewCell.addSubview(titleLabel)
        
    
        
        if self.subjection != "" && self.times != "" && self.count != ""{
            
            print(self.subjection)
            self.getGoodDocuments()
        }
        else{
            goodCollectionViewCell.image = UIImage()
            
            let width = UIScreen.main.bounds.width
//            let height = UIScreen.main.bounds.height
            
            self.fittoView(size: (width-10)/2)
            
        }
    }
    
    //画像タイトル等の配置を設定
    private func fittoView(size:CGFloat){
        
        imageHeight.constant = 7*size/9
        imageWidth.constant = size
        
        //subName.adjustsFontSizeToFitWidth = true
        subHeight.constant = 2*size/9
        subWidth.constant = size
        
        posterHeight.constant = size/9
        posterWidth.constant = size
        
        
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
                let data = snapshot?.data() as? [String:Any] ?? [:]
                self.titleLabel.text = data["title"] as? String ?? "NoTitle"
                //self.posterTitle.text = data["title"] as? String ?? "NoTitle"
                self.postuserid = data["postuser"] as? String ?? ""
                
                //self.titleLabel.text = self.posterTitle.text as? String
                //ユーザ名の取得のファンクション
                self.getpostuserName(uid: self.postuserid)
                
                //画像の取得に関する動作
                let cache = ImageCache.default
                let path = self.subjection + "/" + self.times + "/" + self.count
                if cache.isCached(forKey: path){
                    cache.retrieveImage(forKey: path){ result in
                        switch result{
                        case .success(let value):
                            print("キャッシュによる取得")
                            print(path)
                            self.goodCollectionViewCell.image = value.image
                        case .failure(let err):
                            print(err)
                            self.goodCollectionViewCell.image = UIImage(named: "noimage.jpeg")
                        }
                        
                    }
                    
                    //授業名/回数
                    self.subName.text = "【" + self.subjection + "/" + self.times + "】"
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
    
    private func getpostuserName(uid:String){
        if uid != ""{
            let userref = Firestore.firestore().collection("users").document(uid)
            userref.getDocument(){ (snapshot,err) in
                if err != nil{
                    self.posterName.text = "投稿者：" + "unknown"
                }
                else{
                    let data = snapshot?.data() as? [String:Any] ?? [:]
                    self.posterName.text = (data["name"] as? String ?? "unknown")
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

    
    

