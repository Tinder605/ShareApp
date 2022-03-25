//
//  MyCollectionViewCell.swift
//  SharePastExam
//
//  Created by 馬場大夢 on 2021/10/05.
//

import UIKit
import FirebaseStorage

class MyCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    var url = ""
    var cellpath = ""{
        didSet{
            print(self.cellpath)
        }
    }
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    
    static let identifier = "MyCollectionViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        self.getPostPicture()
        
    }
    private func getPostPicture(){
        if self.cellpath != "" {
            let sep_cellpath = self.cellpath.components(separatedBy: "/")
            let cell_storage = Storage.storage().reference(forURL: "gs://sharepastexamapp.appspot.com").child("images").child("\(sep_cellpath[0])").child("\(sep_cellpath[1])").child("\(sep_cellpath[2]).jpeg")
            cell_storage.getData(maxSize: 1024*1024*100){ (imgdata,err) in
                if imgdata != nil{
                    print("きてはいます")
                    self.imageView.image = UIImage(data: imgdata!)!
                }
                else{
                    print("バッグている")
                    print(err)
                    self.imageView.image = UIImage(named: "noimage.jpeg")!
                }
            }
        }
    }
    
    public func configure(with image: UIImage) {
        imageView.image = image
        imageView.layer.cornerRadius = 10

    }
    static func nib() -> UINib {
        return UINib(nibName: "MyCollectionViewCell", bundle: nil)
    }
    
}
