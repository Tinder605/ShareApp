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
    
    var subject = ""{
        didSet{
            print(self.subject)
        }
    }
    var times = ""{
        didSet{
            print("ここにtimesを入れます")
            print(self.times)
        }
    }
    var count = ""
    var url = ""
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    let data = Data()
    static let identifier = "MyCollectionViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()

        


    }

    public func configure(with image: UIImage) {
        imageView.image = image

    }
    static func nib() -> UINib {
        return UINib(nibName: "MyCollectionViewCell", bundle: nil)
    }
    
}
