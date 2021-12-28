//
//  SliderCollectionViewCell.swift
//  SharePastExam
//
//  Created by 馬場大夢 on 2021/10/21.
//

import UIKit

class SliderCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var sliderImage: UIImageView!
    @IBOutlet weak var sliderText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 10
        
        backgroundColor = .purple
    }
    public func configure(with image: UIImage) {
        sliderImage.image = image
    }
    public func configure(with text: String) {
        sliderText.text = text
    }
    
}
