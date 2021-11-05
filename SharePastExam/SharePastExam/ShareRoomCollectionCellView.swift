//
//  ShareRoomCollectionCellView.swift
//  SharePastExam
//
//  Created by Takashi Sakai on 2021/10/22.
//

import Foundation
import UIKit

class ShareRoomCollectionCellView : UICollectionViewCell {
    static let identifier = "cellid"
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
//        self.fittoview(wid: (width-30)/3, high: (width-30)/3)
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
 
    static func nib() -> UINib {
        return UINib(nibName: "goodCollectionViewCell", bundle: nil)
    }
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
