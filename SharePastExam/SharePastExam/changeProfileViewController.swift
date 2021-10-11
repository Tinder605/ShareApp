//
//  changeProfileViewController.swift
//  SharePastExam
//
//  Created by 馬場大夢 on 2021/10/07.
//

import UIKit
import Firebase
import FirebaseStorage

class changeProfileViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet weak var renewButton: UIButton!
    @IBAction func tappedRenewButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func UploadImage(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                    // 写真を選ぶビュー
                    let pickerView = UIImagePickerController()
                    // 写真の選択元をカメラロールにする
                    // 「.camera」にすればカメラを起動できる
                    pickerView.sourceType = .photoLibrary
                    // デリゲート
                    pickerView.delegate = self
                    // ビューに表示
                    self.present(pickerView, animated: true)
                }
    }
    
    
    
    @IBOutlet weak var circularImageView:UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        circularImageView.image = UIImage(named: "IMG_6906")
        circularImageView.layer.cornerRadius = circularImageView.frame.size.height / 2
        circularImageView.clipsToBounds = true
        
        renewButton.layer.cornerRadius = 10
    }
    
    
    private func presentToHomeViewController(user: User) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        let profileViewController = storyBoard.instantiateViewController(identifier: "ProfileViewController") as! ProfileViewController
        
        profileViewController.modalPresentationStyle = .fullScreen
        
        self.present(profileViewController, animated: true, completion: nil)
        
    }
    
    

}
