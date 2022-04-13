//
//  ShareRoomCollectionCellView.swift
//  SharePastExam
//
//  Created by Takashi Sakai on 2021/10/22.
//

import Foundation
import UIKit
import Firebase
import PKHUD
import Nuke
import Kingfisher

class ShareRoomCollectionCellView : UICollectionViewCell {
    static let identifier = "cellid"
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    //いいねをしたのか取り消したのか決めるパラメータ
    var Goodvalue = 0
    var postuid = ""
    var subjection = ""
    var subtimes = ""
    var number = ""
    
    
    @IBOutlet weak var PostImages: UIImageView!
    @IBOutlet weak var PostImageHeight: NSLayoutConstraint!
    @IBOutlet weak var PostImageWidth: NSLayoutConstraint!
    //投稿内容のタイトル
    @IBOutlet weak var PostTitle: UILabel!
    @IBOutlet weak var PostTitleHeight: NSLayoutConstraint!
    @IBOutlet weak var PostTitleWidth: NSLayoutConstraint!
    //@IBOutlet weak var PostTitleTop: NSLayoutConstraint!
    
    @IBOutlet weak var posterHeight: NSLayoutConstraint!
    @IBOutlet weak var posterWidth: NSLayoutConstraint!
    
    
    @IBOutlet weak var ReviewStackView: UIStackView!
    @IBOutlet weak var ReviewStackHeihgt: NSLayoutConstraint!
    @IBOutlet weak var ReviewStackWidth: NSLayoutConstraint!
    //@IBOutlet weak var ReviewStackTop: NSLayoutConstraint!
    @IBOutlet weak var ReviewButton: UIButton!
    

    @IBOutlet weak var ViewCount: UILabel!
    @IBOutlet weak var posterName: UILabel!
    
    let times = UserDefaults.standard.string(forKey: "RecentlyTimes") ?? "a"
    let sub = (UserDefaults.standard.array(forKey: "RecentlySub") ?? ["a"])
    
    @IBAction func ActionGoodButton(_ sender: Any) {
        //nilの場合を避ける
        var GoodCount = 0
        var GoodList:[String] = []
        let uid = Auth.auth().currentUser?.uid
        var dicData:Dictionary<String,Any>
        print(uid)
//        最近の講義の回数と講義がからでなければ(この処理は関数でまとめるべきかもしれない)
        if (times != "a") && (sub[0] as! String != "a" ){
            let ref = Firestore.firestore().collection("images").document("\(sub[0])").collection("times").document("\(times)").collection("count").document("\(self.number)")
            ref.getDocument(){ (snapshot,err) in
                if snapshot != nil{
                    var image = UIImage()
                    var doc:Dictionary<String,Any>
                    doc = snapshot?.data() as! [String:Any]
                    //デバックのため一応です(Godのリストがなかったら)
                    let postUser = doc["postuser"] as? String ?? ""
                    if doc["GoodList"] == nil{
                        GoodList = ["\(uid!)"]
                        GoodCount = GoodCount + 1
                        image = UIImage(systemName: "heart.fill") ?? UIImage()
                        self.Goodvalue = 1
                    }
                    //ある場合とで
                    else{
                        GoodCount = doc["good"] as! Int
                        GoodList = doc["GoodList"] as! [String]
                        if self.Goodvalue == 0{
                            GoodList.append(uid!)
                            GoodCount = GoodCount + 1
                            image = UIImage(systemName: "heart.fill") ?? UIImage()
                            self.Goodvalue = 1
                        }
                        else{
                            print(type(of: uid!))
                            GoodList.removeAll(where: {$0 == String(uid!)})
                            GoodCount = GoodCount - 1
                            image = UIImage(systemName: "heart") ?? UIImage()
                            self.Goodvalue = 0
                        }
                    }
                    self.updateGoodRef(goodlist: GoodList, goodcount: GoodCount)
                    self.updateUserGoodList()
                    self.updatePostUserGoodCount(uid:postUser)
                    self.ReviewButton.setTitle("", for: .normal)
                    self.ReviewButton.setImage(image, for: .normal)
                }
                else{
                    print("データの取得に失敗しました。")
                    return
                }
            }
        }
        else{
            print("こっちに来ております")
        }
//
//        if ReviewButton.imageView?.image == UIImage(systemName: "heart"){
//            let image = UIImage(systemName: "heart.fill")
//            ReviewButton.setImage(image, for: .normal)
//            ReviewButton.imageView?.tintColor = .systemGreen
//        }
//        else{
//            let image = UIImage(systemName: "heart")
//            ReviewButton.setImage(image, for: .normal)
//        }
        print("ボタンが押されました")
    }
    //imagesのGOODの更新(誰がいいねしたかがわかる)
    private func updateGoodRef(goodlist:[String],goodcount:Int){
        let ref = Firestore.firestore().collection("images").document("\(sub[0])").collection("times").document("\(times)").collection("count").document("\(self.number)")
        print(goodlist)
        ref.updateData(["good":goodcount,"GoodList":goodlist]){ err in
            if let err = err{
                print("いいねの更新に失敗しました。")
            }
            else{
                print("いいねの更新に成功しました。")
            }
            
        }
    }
    //
    private func updateUserGoodList(){
        guard let uid = Auth.auth().currentUser?.uid else{return}
        let ref = Firestore.firestore().collection("users").document(uid)
        
        ref.getDocument(){ (snapshot,err) in
            if let err = err{
                print("エラーとなりました")
                return
            }
            let data = snapshot?.data() as? [String:Any] ?? [:]
            print("newelemntの表示")
            let newelement = "\(self.sub[0])" + "/" + "\(self.times)" + "/" + "\(self.number)"
            var GoodList:[String] = []
            var AllGoodCount = data["AllGoodCount"] as? Int ?? 0
            print("ここにGoodValueを表示")
            print(self.Goodvalue)
            if let goodlist = data["GoodList"]{
                GoodList = goodlist as! [String]
                if self.Goodvalue == 0{
                    GoodList.removeAll(where: {$0 == String(newelement)})
                }
                else{
                    GoodList.append(newelement)
                }
            }
            else{
                GoodList = [newelement]
            }
            print(GoodList)
            ref.updateData(["GoodList":GoodList]){(err) in
                if let err = err{
                    print("GoodListの更新に失敗しました。")
                }
                else{
                    print("GoodListの更新に成功しました")
                }
            }
        }
        
    }
    
    private func updatePostUserGoodCount(uid:String){
        if uid != "" {
            let postUserRef = Firestore.firestore().collection("users").document(uid)
            postUserRef.getDocument(){ (snapshot,err) in
                if err != nil{
                    print(err.debugDescription)
                    print("取得の失敗")
                }
                else{
                    let data = snapshot?.data() as? [String:Any] ?? [:]
                    var postUserAllgoodcount = data["AllGoodCount"] as? Int ?? 0
                    if self.Goodvalue == 0{
                        postUserAllgoodcount = postUserAllgoodcount - 1
                        if postUserAllgoodcount < 0{
                            postUserAllgoodcount = 0
                        }
                    }
                    else{
                        postUserAllgoodcount = postUserAllgoodcount + 1
                    }
                    postUserRef.updateData(["AllGoodCount":postUserAllgoodcount]){ (err) in
                        if err != nil{
                            print(err.debugDescription)
                            print("AllGoodCountの更新失敗")
                        }
                    }
                }
            }
        }
    }
    
    //画面の初期状態に関する関数
    //awakeします。
    override func awakeFromNib() {
        super.awakeFromNib()
        self.fittoView(size: (width-10)/2)
        self.getShareRoomImage()
        self.backgroundColor = UIColor.rgb(red: 214, green: 183, blue: 123)
        self.layer.cornerRadius = 10
        self.ReviewButton.setTitle("", for: .normal)
        self.getpostuserName(uid: self.postuid)
        
        //フォントのサイズを横幅に合わせる
        self.PostTitle.adjustsFontSizeToFitWidth = true
        self.posterName.adjustsFontSizeToFitWidth = true
        self.ViewCount.adjustsFontSizeToFitWidth = true
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.fittoView(size: (width-10)/2)

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
                    self.posterName.text = "投稿者：" + (data["name"] as? String ?? "unknown")
                }
            }
        }
    }
    private func getShareRoomImage(){
        print("関数内での動き")
        print(self.subjection)
        print(self.subtimes)
        
        if self.subjection != "" && self.subtimes != "" && self.number != ""{
            let cache = ImageCache.default
            let path = self.subjection + "/" + self.subtimes + "/" + self.number
            if cache.isCached(forKey: path){
                cache.retrieveImage(forKey: path){ result in
                    switch result{
                    case .success(let value):
                        DispatchQueue.main.async {
                            self.PostImages.image = value.image
                        }
                    case .failure(let err):
                        print(err)
                        self.PostImages.image = UIImage(named: "noimage")!
                    }
                    
                }
            }
            else{
                let FireStorage_Path = Storage.storage().reference(forURL: "gs://sharepastexamapp.appspot.com").child("images").child("\(self.subjection)").child("\(self.subtimes)").child("\(self.number).jpeg")
                
                FireStorage_Path.getData(maxSize: 1024*1024*100){ (data,err) in
                    if data != nil{
                        print("入ってます")
                        self.PostImages.image = UIImage(data: data!)!
                        cache.store(UIImage(data: data!)!, forKey: path)
                    }
                    else{
                        self.PostImages.image = UIImage(named: "noimage.jpeg")
                    }
                }
            }
        }
        else{
            print("あれへんで")
            self.PostImages.image = UIImage(named: "noimage.jpeg")
        }
        
    }
    
    //画像タイトル等の配置を設定
    private func fittoView(size:CGFloat){
        PostImageHeight.constant = 5*size/9
        PostImageWidth.constant = size
        
        PostTitleHeight.constant = size/9
        PostTitle.topAnchor.constraint(equalTo: PostTitle.bottomAnchor)
        PostTitleWidth.constant = size
        
        posterHeight.constant = size/9
        posterWidth.constant = size
        
        ReviewStackHeihgt.constant = 2*size/9
        ReviewStackWidth.constant = size
        
        
        self.ReviewButton.titleLabel?.text = ""
        self.ReviewButton.contentHorizontalAlignment = .center
        
    }
}
