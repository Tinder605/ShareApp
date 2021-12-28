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
    
    @IBAction func ActionGoodButton(_ sender: Any) {
        
        if ReviewButton.imageView?.image == UIImage(systemName: "heart"){
            let image = UIImage(systemName: "heart.fill")
            ReviewButton.setImage(image, for: .normal)
            ReviewButton.imageView?.tintColor = UIColor.rgb(red: 166, green: 252, blue: 132)
        }
        else{
            let image = UIImage(systemName: "heart")
            ReviewButton.setImage(image, for: .normal)
        }
        print("ボタンが押されました")
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
        HUD.show(.progress, onView: self.superview)
        self.getPostTestData()
        HUD.flash(.success, onView: self.superview,delay: 1)
        
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
        
        //PostTitle.backgroundColor = UIColor.rgb(red: 166, green: 252, blue: 132)
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
