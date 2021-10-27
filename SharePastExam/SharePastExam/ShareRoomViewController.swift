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

class ShareRoomViewController: UIViewController {
    
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
        
        
        //ShareRoomCollectionView.delegate = self
        //ShareRoomCollectionView.register(<#T##cellClass: AnyClass?##AnyClass?#>, forCellWithReuseIdentifier: <#T##String#>)
    }
    
    
    
    
}

