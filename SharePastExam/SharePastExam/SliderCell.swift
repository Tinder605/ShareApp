//
//  SliderCell.swift
//  SharePastExam
//
//  Created by 馬場大夢 on 2021/10/16.
//

import UIKit
import FirebaseStorage

class SliderCell: UICollectionViewCell {
    
    var images = UIImage(named: "IMG_6906")
    var number = 0
//    var path:String  = ""{
//        didSet{
//            print("パスの変更を表示")
//            print(self.path)
//        }
//    }
    
    var getpath = UserDefaults.standard.array(forKey: "RecentlyPath") as? [String] ?? []
    private let sliderId = "sliderId"
    static let identifier = "SliderCell"
    
    lazy var SliderCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        //slidercollectionviewの背景色の変更
        collectionView.backgroundColor = UIColor.rgb(red: 166, green: 252, blue: 132)
        
        return collectionView
    }()
    //collectionviewの中のcollectionviewをリロードする関数
    public func WakeupCell(){
        self.getpath = UserDefaults.standard.array(forKey: "RecentlyPath") as? [String] ?? []
        self.SliderCollectionView.reloadData()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(SliderCollectionView)
        
        [
        SliderCollectionView.topAnchor.constraint(equalTo: self.topAnchor),
        SliderCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        SliderCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
        SliderCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ].forEach{ $0.isActive = true}
        
        
        SliderCollectionView.contentInset = .init(top: 0, left: 15, bottom: 0, right: 15)
        SliderCollectionView.register(UINib(nibName: "SliderCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: sliderId)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
//    private func getPastDocuments(){
//        if self.path != ""{
//            //アクセス方法が多いのですが、
//            let path_dep = self.path.components(separatedBy: "/")
//            let FireStorage_Path = Storage.storage().reference(withPath: "gs://sharepastexamapp.appspot.com").child("images").child("\(path_dep[0])").child("\(path_dep[1])").child("\(path_dep[2]).jpeg")
//            FireStorage_Path.getData(maxSize: 1024*1024*10){ (data,err) in
//                if data != nil{
//
//                }
//                else{
//                    print("失敗しています。")
//                }
//            }
//
//
//        }
//    }
    
}

extension SliderCell: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = self.frame.height
        return.init(width: 280, height: height)
    }
    
func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    var count = 3
    if self.getpath.count<3{
        count = self.getpath.count
        print("個数が異なります。\(self.getpath.count)")
        print(self.getpath)
    }
    else{
        count = 3
    }
    return count
 }

func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    print(self.getpath)
    let cell = SliderCollectionView.dequeueReusableCell(withReuseIdentifier: sliderId.self, for: indexPath) as! SliderCollectionViewCell
    if indexPath.row < self.getpath.count{
        cell.path = self.getpath[indexPath.row] as! String
    }
    cell.awakeFromNib()
    return cell
 }

}
