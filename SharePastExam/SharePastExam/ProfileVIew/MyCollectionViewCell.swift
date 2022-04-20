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
    
    //画像の縦、横の大きさ
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    @IBOutlet weak var imageWidth: NSLayoutConstraint!
    
    //教科名の縦、横の大きさ
    @IBOutlet weak var subHeight: NSLayoutConstraint!
    @IBOutlet weak var subWidth: NSLayoutConstraint!
    
    //Goodの縦、横の大きさ
    @IBOutlet weak var goodHeight: NSLayoutConstraint!
    @IBOutlet weak var goodWidth: NSLayoutConstraint!
    
    //Viewの縦、横の大きさ
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    @IBOutlet weak var viewWidth: NSLayoutConstraint!
    
    //画像
    @IBOutlet weak var imageView: UIImageView!
    
    //教科名のLabel
    @IBOutlet weak var subName: UILabel!
    
    //Good数のLabel
    @IBOutlet weak var goodCount: UILabel!
    
    //View数のLabel
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
            
            self.subName.adjustsFontSizeToFitWidth = true
            
            self.layer.cornerRadius = 10
            
            self.fittoView(size: (width-10)/2)
            print("実行してんでー")
            
            //フォントを横幅に合わせる
            self.subName.adjustsFontSizeToFitWidth = true
            
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
                self.goodCount.text = String(data["good"] as? Int ?? 0)
                self.viewCount.text = String(data["viewcount"] as? Int ?? 0)
                self.subName.text = "【" + sep_cellpath[0] + "/" + sep_cellpath[1] + "】"
                self.titleLabel.text = data["title"] as? String ?? "NoTitle"
    
            }
        }
    }
    //画像タイトル等の配置を設定
    public func fittoView(size:CGFloat){
        //画像の縦、横のサイズ
        imageHeight.constant = 3*size/6
        imageWidth.constant = size
        
        //教科名の縦、横のサイズ
        subHeight.constant = size/6
        subWidth.constant = size
        
        //Goodの縦、横のサイズ
        goodHeight.constant = size/6
        goodWidth.constant = size
        
        //Viewの縦、横のサイズ
        viewHeight.constant = size/6
        viewWidth.constant = size
        
        //画像の上にタイトルを表示
        titleLabel.textAlignment = NSTextAlignment.left
        titleLabel.textColor = .white
        titleLabel.frame = CGRect(x: 5,y:(self.frame.height)/2 ,  width:self.frame.width - 5, height: 20)
        
        print("frameを確認する")
        print(self.imageView.frame)
        print(self.frame)
        print(width)
        print(height)
        print(3*size/6)
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        
        self.imageView.addSubview(titleLabel)
        
        
    }
    
    public func configure(with image: UIImage) {
        imageView.image = image

    }
    static func nib() -> UINib {
        return UINib(nibName: "MyCollectionViewCell", bundle: nil)
    }
    
}
