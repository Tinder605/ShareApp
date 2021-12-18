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

class ShareRoomCollectionCellView : UICollectionViewCell {
    static let identifier = "cellid"
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    var Goodvalue = 0

    var number = 0
    
    
    @IBOutlet weak var PostImages: UIImageView!
    @IBOutlet weak var PostImageHeight: NSLayoutConstraint!
    @IBOutlet weak var PostImageWidth: NSLayoutConstraint!
    //投稿内容のタイトル
    @IBOutlet weak var PostTitle: UILabel!
    @IBOutlet weak var PostTitleHeight: NSLayoutConstraint!
    @IBOutlet weak var PostTitleWidth: NSLayoutConstraint!
    @IBOutlet weak var PostTitleTop: NSLayoutConstraint!
    
    @IBOutlet weak var ReviewStackView: UIStackView!
    @IBOutlet weak var ReviewStackHeihgt: NSLayoutConstraint!
    @IBOutlet weak var ReviewStackWidth: NSLayoutConstraint!
    @IBOutlet weak var ReviewStackTop: NSLayoutConstraint!
    @IBOutlet weak var ViewCount: UILabel!
    @IBOutlet weak var ReviewButton: UIButton!
    
    let times = UserDefaults.standard.string(forKey: "RecentlyTimes") ?? "a"
    let sub = (UserDefaults.standard.array(forKey: "RecentlySub") ?? ["a"])
    
    @IBAction func ActionGoodButton(_ sender: Any) {
        if Goodvalue == 0{
            let image = UIImage(systemName: "heart.fill")
//nilの場合を避ける
            var GoodCount = 0
            var GoodList:[String] = []
            let uid = Auth.auth().currentUser?.uid
            var dicData:Dictionary<String,Any>
            print(uid)
            if (times != "a") && (sub[0] as! String != "a" ){
                let ref = Firestore.firestore().collection("\(sub[0] )").document("times").collection("\(times)").document("\(self.number)")
                ref.getDocument(){ (snapshot,err) in
                    if let err = err{
                        var doc:Dictionary<String,Any>
                        doc = snapshot?.data() as! [String:Any]
                        //デバックのため一応です
                        if doc["GoodList"] == nil{
                            //goodlistを作る関数
                            GoodList = ["\(uid!)"]
                        }else{
                            GoodList = doc["GoodList"] as! [String]
                            GoodList.append(uid!)
                        }
                        GoodCount = doc["good"] as! Int
                        GoodCount = GoodCount + 1
                        self.updateGoodRef(goodlist: GoodList, goodcount: GoodCount)
                        self.ReviewButton.setImage(image, for: .normal)
                        print("更新完了")
                    }
                    else{
                        print("データの取得に失敗しました。")
                        return
                    }
                }
            }
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
    
    private func updateGoodRef(goodlist:[String],goodcount:Int){
            let ref = Firestore.firestore().collection("\(sub[0])").document("times").collection("\(times)").document("\(self.number)")
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
    
    private func getPostTestData(){
        let sub = UserDefaults.standard.array(forKey: "RecentlySub") as! [String]
        let times = UserDefaults.standard.string(forKey: "RecentlyTimes")!
        
        let ref = Firestore.firestore().collection("images").document(sub[0])
        let imginforef = ref.collection("times").document(times).collection("count")
        var imgminuid:Int = 10000
        imginforef.getDocuments(){(querySnapshots,err) in
            if let err = err{
                print("データ取得失敗")
                return
            }
            else{
                for document in querySnapshots!.documents{
//                    print("\(document.documentID) =>\(document.data())")
//                    print(type(of: document.documentID))
                    let nowuid = Int(document.documentID)
                    if imgminuid>nowuid!{
                        imgminuid = nowuid!
                    }
                }
                print(imgminuid)
            }
        }
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        self.fittoView(size: (width-30)/3)
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.fittoView(size: (width-30)/3)

    }
    
    
    private func fittoView(size:CGFloat){
        PostImageHeight.constant = size/2
        PostImageWidth.constant = size
        PostTitleHeight.constant = size/4
        
        PostTitle.backgroundColor = .orange
        PostTitleTop.constant = 0
        PostTitle.topAnchor.constraint(equalTo: PostTitle.bottomAnchor)
        PostTitleWidth.constant = size
        
        ReviewStackWidth.constant = size
        ReviewStackHeihgt.constant = size/4
        ReviewStackTop.constant = 0
        
        ReviewButton.titleLabel?.text = ""
        
        
    }
 
//    static func nib() -> UINib {
//        return UINib(nibName: "ShareRoomCollectionViewCell", bundle: nil)
//    }
//    static func makelabel(text:String) {
//        let view = UINib(nibName: "ShareRoomCollectionViewCell", bundle: nil).instantiate(withOwner: nil, options: nil).first as! ShareRoomCollectionCellView
//
//        view.TextTitleLabel.text = "aks"
//
//    }
    
//    public func configure(title :String){
//        TextTitleLabel.text = title
//    }
    
    
//
//    static func nib() -> UINib {
//        return UINib(nibName: "ShareRoomCollectionViewCell", bundle: nil)
//    }
}
