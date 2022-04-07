//
//  FullDocumentViewController.swift
//  SharePastExam
//
//  Created by Takashi Sakai on 2022/04/04.
//

import Foundation
import UIKit

class FullDocumentViewController: UIViewController {
    
    var mainimage = UIImage()
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    @IBOutlet weak var imageheight: NSLayoutConstraint!
    
    @IBOutlet weak var FullImage: UIImageView!
    @IBOutlet weak var imagewidth: NSLayoutConstraint!
//    @IBOutlet weak var CloseButton: UIButton!
//    
//    @IBAction func CloseScreen(_ sender: Any) {
//        print("この画面を閉じます")
//    }
//    
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.imageheight.constant = 300
        self.imagewidth.constant = 300
//        self.CloseButton.backgroundColor = .red
//        self.CloseButton.setTitle("", for: .normal)
        //print("アイウエオ")
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.FullImage.image = self.mainimage
        print("アイウエオ")
        
        
        let close = UIButton()
        close.setImage(UIImage(systemName: "xmark"), for: .normal)
        close.frame = CGRect(x: 50, y: 50, width: 30, height: 30)
        // ボタンを押した時に実行するメソッドを指定
        close.addTarget(self, action: #selector(buttonEvent(_:)), for: UIControl.Event.touchUpInside)
        close.backgroundColor = .blue
        self.FullImage.addSubview(close)
    }
    @objc func buttonEvent(_ sender: UIButton) {
        print("ボタンの情報: \(sender)")
    }
    
    
}
