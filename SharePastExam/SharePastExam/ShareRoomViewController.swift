//
//  ShareRoomViewController.swift
//  SharePastExam
//
//  Created by Takashi Sakai on 2021/10/11.
//

import UIKit
import SDWebImage
import Firebase
import FirebaseStorage

class ShareRoomViewController: UIViewController, UICollectionViewDataSource ,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{

    @IBOutlet weak var PostButton: UIButton!
    @IBOutlet weak var ShareRoomCollectionView: UICollectionView!
    @IBOutlet weak var ShareRoomViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var ShareRoomCollectionViewWidth: NSLayoutConstraint!
    
    @IBAction func PostButtonAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "CreatePastExam", bundle: nil)
        let nextwindow = storyboard.instantiateViewController(withIdentifier: "CreatePastExam") as! CreateExamViewController
        self.present(nextwindow, animated: true, completion: nil)
    }
    
    var timestile :String = ""
    var count:String!
    
    let width = UIScreen.main.bounds.width
    let height  = UIScreen.main.bounds.height
    
    
    override func viewDidLayoutSubviews() {
        ShareRoomCollectionViewWidth.constant = width
        ShareRoomViewHeight.constant = height
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue
        PostButton.layer.cornerRadius = 40
        PostButton.setTitle("", for: .normal)
        navigationItem.title = timestile
        UserDefaults.standard.set(timestile, forKey: "RecentlyTimes")
        
        let nib = UINib(nibName: "ShareRoomCollectionViewCell", bundle: nil)
        self.ShareRoomCollectionView.register(nib, forCellWithReuseIdentifier: "CellView")
        ShareRoomCollectionView.dataSource = self
        ShareRoomCollectionView.delegate = self
        ShareRoomCollectionView.isScrollEnabled = true
        
        
        
//        let lay = ShareRoomCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
//        lay.itemSize = CGSize(width: (width-10)/3, height: 100)
//        print(lay.itemSize)
        
//        let layout = UICollectionViewFlowLayout()
//        layout.estimatedItemSize = .zero
//        layout.itemSize = CGSize(width: (width-10)/3, height: 120)
//        ShareRoomCollectionView.collectionViewLayout = layout
    }

}

extension ShareRoomViewController {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        9
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.view.frame.width
        let wid = (width-30)/3
        return .init(width: wid, height: wid)
    }
    
    

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellView", for: indexPath) as! ShareRoomCollectionCellView
        //cell.fittoview(width: (width-30)/3, height: (width-30)/3)
        return cell
    }

}

