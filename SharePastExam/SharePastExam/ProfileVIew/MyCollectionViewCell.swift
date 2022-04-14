//
//  MyCollectionViewCell.swift
//  SharePastExam
//
//  Created by 馬場大夢 on 2021/10/05.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore
import Kingfisher

class MyCollectionViewCell: UICollectionViewCell {
    
    //画像の縦、横
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    @IBOutlet weak var imageWidth: NSLayoutConstraint!
    
    //教科名の縦、横
    @IBOutlet weak var subHeight: NSLayoutConstraint!
    @IBOutlet weak var subWidth: NSLayoutConstraint!
    
    @IBOutlet weak var goodHeight: NSLayoutConstraint!
    @IBOutlet weak var goodWidth: NSLayoutConstraint!
    
    
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    @IBOutlet weak var viewWidth: NSLayoutConstraint!
    //タイトルの縦、横
    //@IBOutlet weak var titleHeight: NSLayoutConstraint!
    //@IBOutlet weak var titleWidth: NSLayoutConstraint!
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var subName: UILabel!
    //@IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var goodCount: UILabel!
    @IBOutlet weak var viewCount: UILabel!
    
    
    var url = ""
    var cellpath = ""{
        didSet{
            print(self.cellpath)
        }
    }
    var title = ""
    var goodcount = 0
    var viewcount = 0
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    let titleLabel = UILabel()
    
    
    
    static let identifier = "MyCollectionViewCell"
    

    override func awakeFromNib() {
        super.awakeFromNib()
        if self.cellpath != ""{
            let sep_cellpath = self.cellpath.components(separatedBy: "/")
            //self.getPostPicture(sep_cellpath:sep_cellpath)
            //self.getPostDocData(sep_cellpath: sep_cellpath)
            
            self.subName.adjustsFontSizeToFitWidth = true
            //self.postTitle.adjustsFontSizeToFitWidth = true
            self.layer.cornerRadius = 10
            
            self.fittoView(size: (width-10)/2)
            
            //フォントを横幅に合わせる
            self.subName.adjustsFontSizeToFitWidth = true
            
            //画像の上にタイトルを表示
            titleLabel.textAlignment = NSTextAlignment.left
            //titleLabel.text = self.posterTitle.text as? String
            titleLabel.textColor = .white
            //titleLabel.frame = CGRect(x: 0, y:self.goodCollectionViewCell.frame.height, width: self.goodCollectionViewCell.frame.width - 5, height: self.goodCollectionViewCell.frame.height-5)
            titleLabel.frame = CGRect(x: 5,y:self.imageView.frame.height/3+10 ,  width:self.imageView.frame.width - 5, height: self.imageView.frame.height-5)
            
            //titleLabel.font = titleLabel.font.withSize(20)
            titleLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
            
            //self.titleLabel.adjustsFontSizeToFitWidth = true
            self.imageView.addSubview(titleLabel)
        }
        
        
    }
    public func getPostPicture(sep_cellpath:[String]){
        let cache = ImageCache.default
        if cache.isCached(forKey: cellpath){
            cache.retrieveImage(forKey: cellpath){ result in
                switch result{
                case .success(let value):
                    print("キャッシュの利用")
                    self.imageView.image = value.image
                case .failure(let err):
                    print("キャッシュにはありません")
                    self.imageView.image = UIImage(named: "noimage.jpeg")
                }
            }
        }
        else{
            let cell_storage = Storage.storage().reference(forURL: "gs://sharepastexamapp.appspot.com").child("images").child("\(sep_cellpath[0])").child("\(sep_cellpath[1])").child("\(sep_cellpath[2]).jpeg")
            cell_storage.getData(maxSize: 1024*1024*100){ (imgdata,err) in
                if imgdata != nil{
                    print("きてはいます")
                    self.imageView.image = UIImage(data: imgdata!)!
                    cache.store(UIImage(data: imgdata!)!, forKey: self.cellpath)
                }
                else{
                    print("バッグている")
                    print(err)
                    self.imageView.image = UIImage(named: "noimage.jpeg")!
                }
            }
        }
    }
    //各セルのドキュメント情報の所得(必要ないのかもしれない）
    public func getPostDocData(sep_cellpath:[String]){
        let ref = Firestore.firestore().collection("images").document(sep_cellpath[0]).collection("times").document(sep_cellpath[1]).collection("count").document(sep_cellpath[2])
        ref.getDocument(){(snapshot,err) in
            if snapshot != nil{
                let data = snapshot?.data() ?? [:]
                print("正しく所得したデータ")
                print(data["title"] as? String ?? "")
                self.title = data["title"] as? String ?? ""
                self.goodcount = data["good"] as? Int ?? 0
                self.viewcount = data["viewcount"] as? Int ?? 0
                //self.postTitle.text = data["title"] as? String ?? "NoTitle"
                self.subName.text = "【" + sep_cellpath[0] + "/" + sep_cellpath[1] + "】"
                self.titleLabel.text = data["title"] as? String ?? "NoTitle"
                //授業名/回数
                //self.subName.text = "【" + self.sep_cellpath[0] + "/" + self.sep_cellpath[1] + "】"
            }
        }
    }
    //画像タイトル等の配置を設定
    private func fittoView(size:CGFloat){
        
        imageHeight.constant = 3*size/6
        imageWidth.constant = size
        
        //subName.adjustsFontSizeToFitWidth = true
        subHeight.constant = size/6
        subWidth.constant = size
        
        goodHeight.constant = size/6
        goodWidth.constant = size
        
        viewHeight.constant = size/6
        viewWidth.constant = size
        
        //titleHeight.constant = size/6
        //titleWidth.constant = size
        //posterTitle.adjustsFontSizeToFitWidth = true
        
        
    }
    
    public func configure(with image: UIImage) {
        imageView.image = image

    }
    static func nib() -> UINib {
        return UINib(nibName: "MyCollectionViewCell", bundle: nil)
    }
    
}
