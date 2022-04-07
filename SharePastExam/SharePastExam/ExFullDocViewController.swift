//
//  ExFullDocViewController.swift
//  SharePastExam
//
//  Created by Takashi Sakai on 2022/04/06.
//

import Foundation
import UIKit
import Firebase


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
        self.updateViewCount()
//        let close = UIButton()
//        close.setImage(UIImage(systemName: "xmark"), for: .normal)
//        close.frame = CGRect(x: 50, y: 50, width: 30, height: 30)
//        // ボタンを押した時に実行するメソッドを指定
//        close.addTarget(self, action: #selector(buttonEvent(_:)), for: UIControl.Event.touchUpInside)
//        close.backgroundColor = .blue
//        self.FullImage.addSubview(close)
        
    }
    
    private func updateViewCount(){
        let recentlypath = UserDefaults.standard.array(forKey: "RecentlyPath") ?? []
        if recentlypath.count != 0{
            let sep_path = (recentlypath[0] as! String).components(separatedBy: "/")
            let ref = Firestore.firestore().collection("images").document(sep_path[0]).collection("times").document(sep_path[1]).collection("count").document(sep_path[2])
            ref.getDocument(){ (snapshot,err) in
                if err != nil{
                    print("viewcountの更新を中断します")
                }
                else{
                    let data = snapshot?.data() as? [String:Any] ?? [:]
                    var viewcount = data["viewcount"] as! Int
                    viewcount = viewcount + 1
                    ref.updateData(["viewcount":viewcount]){ err in
                        if err == nil{
                            print(viewcount)
                            print("viewcount更新完了です。")
                        }
                    }
                }
            }
        }
    }
//    @objc func buttonEvent(_ sender: UIButton) {
//        print("ボタンの情報: \(sender)")
//    }
}
