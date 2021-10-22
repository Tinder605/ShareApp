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
    
    @IBAction func PostButtonAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "CreatePastExam", bundle: nil)
        let nextwindow = storyboard.instantiateViewController(withIdentifier: "CreatePastExam") as! CreateExamViewController
        self.present(nextwindow, animated: true, completion: nil)
    }
    
    var timestile :String = ""
    var count:String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue
        PostButton.layer.cornerRadius = 40
        PostButton.setTitle("", for: .normal)
        navigationItem.title = timestile
        UserDefaults.standard.set(timestile, forKey: "RecentlyTimes")
    }
    
    
    
    
}

