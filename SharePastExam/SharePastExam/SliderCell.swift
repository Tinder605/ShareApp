//
//  SliderCell.swift
//  SharePastExam
//
//  Created by 馬場大夢 on 2021/10/16.
//

import UIKit

class SliderCell: UICollectionViewCell {
    
    var images = UIImage(named: "IMG_6906")
    private let sliderId = "sliderId"
    static let identifier = "SliderCell"
    
    lazy var SliderCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
        return collectionView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(SliderCollectionView)
        
        [
        SliderCollectionView.topAnchor.constraint(equalTo: self.topAnchor),
        SliderCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        SliderCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
        SliderCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ].forEach{ $0.isActive = true}
        
        
        SliderCollectionView.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        
        SliderCollectionView.register(UINib(nibName: "SliderCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: sliderId)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension SliderCell: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = self.frame.height
        return.init(width: 280, height: height)
    }
    
func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 5
}

func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = SliderCollectionView.dequeueReusableCell(withReuseIdentifier: sliderId.self, for: indexPath) as! SliderCollectionViewCell
    
    return cell
}

}
