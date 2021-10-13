//
//  changeProfileViewController.swift
//  SharePastExam
//
//  Created by 馬場大夢 on 2021/10/07.
//
import Foundation
import UIKit
import FirebaseStorage
import Firebase
import PKHUD

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
    
    // 写真を選んだ後に呼ばれる処理
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // 選択した写真を取得する
        let image = info[.originalImage] as! UIImage
        // ビューに表示する
        circularImageView.image = image
        // 写真を選ぶビューを引っ込める
        self.dismiss(animated: true)
        
    }
    
    @objc func showKeyboard(notification: Notification) {
        let keyboardFrame = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        
        guard let keyboardMinY = keyboardFrame?.minY else {return}
        let registerBottonMaxY = renewButton.frame.maxY
        let distance = registerBottonMaxY - keyboardMinY + 20
        
        let transform = CGAffineTransform(translationX: 0, y: -distance)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [], animations: {
            self.view.transform = transform
        })
        
        //print("keyboardFrame : ", keyboardFrame)
    }
    @objc func hideKeyboard() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [], animations: {
            self.view.transform = .identity
        })
    }
}
    
    
    
    


