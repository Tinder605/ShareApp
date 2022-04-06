//
//  ExFullDocViewController.swift
//  SharePastExam
//
//  Created by Takashi Sakai on 2022/04/06.
//

import Foundation
import UIKit


class ExFullDocViewController: UIViewController {
    
    @IBOutlet weak var FullImage: UIImageView!
    
    @IBOutlet weak var DismissButton: UIButton!
    @IBAction func action(_ sender: Any) {
        print("アイウエオ")
        self.dismiss(animated: true)
    }
    
    var mainimage = UIImage()
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.FullImage.frame = CGRect(x: 0, y: 0, width: width, height: height)
        //print("アイウエオ")
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.DismissButton.setTitle("", for: .normal)
        self.DismissButton.layer.cornerRadius = self.DismissButton.frame.width/2
        self.FullImage.contentMode = .scaleAspectFit
        self.FullImage.clipsToBounds = true
        self.FullImage.image = self.mainimage
        
//        let close = UIButton()
//        close.setImage(UIImage(systemName: "xmark"), for: .normal)
//        close.frame = CGRect(x: 50, y: 50, width: 30, height: 30)
//        // ボタンを押した時に実行するメソッドを指定
//        close.addTarget(self, action: #selector(buttonEvent(_:)), for: UIControl.Event.touchUpInside)
//        close.backgroundColor = .blue
//        self.FullImage.addSubview(close)
        
    }
//    @objc func buttonEvent(_ sender: UIButton) {
//        print("ボタンの情報: \(sender)")
//    }
}
