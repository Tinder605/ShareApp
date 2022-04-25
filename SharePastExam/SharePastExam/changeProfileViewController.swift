//
//  changeProfileViewController.swift
//  SharePastExam
//
//  Created by 馬場大夢 on 2021/10/07.
//
import Foundation
import UIKit
import Firebase
import PKHUD
import RxSwift
import FirebaseFirestore
import RxCocoa
import FirebaseStorage
import SwiftUI
import SDWebImage

class changeProfileViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    //var childCallBack: ((String) -> Void)?
    
    private let disposeBag = DisposeBag()
    private var name = ""
    private var message = ""
    private var profileImageUrl = ""
    
    
    var user: User? {
        didSet {
            usernameTextField.text = user?.name
            profileTextField.text = user?.message
            
        }
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
    
    @IBAction func ClosePage(_ sender: Any) {
        print("tapped tauch")
        self.dismiss(animated: true)
    }
    
    
    
    
    @IBOutlet weak var CloseButton: UIButton!
    
    @IBOutlet weak var circularImageView:UIImageView?
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var profileTextField: UITextField!
    @IBOutlet weak var renewButton: UIButton!
    @IBAction func tappedRenewButton(_ sender: UIButton) {
        HUD.show(.progress, onView: self.view)
        
        guard let changename = usernameTextField.text else{return}
        let username = changename
        UserDefaults.standard.set(username, forKey: "name")
        print(username)
        
        guard let changemessage = profileTextField.text else{return}
        let message = changemessage
        UserDefaults.standard.set(message, forKey: "message")
        print(message)
        
        //UserDefaults.standard.set(profileImageUrl, forKey: "profileImageUrl")
        self.updateProfileImage()
        //self.dismiss(animated: true, completion: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.CloseButton.setTitle("", for: .normal)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        circularImageView?.contentMode = .scaleAspectFill
        circularImageView?.layer.cornerRadius = (circularImageView?.frame.size.height)! / 2
        circularImageView?.clipsToBounds = true
        
        renewButton.layer.cornerRadius = 10
    
        let username = UserDefaults.standard.string(forKey: "name")!
        usernameTextField.text = username
        
        let message = UserDefaults.standard.string(forKey: "message")!
        profileTextField.text = message
        
        let profileImageUrl = UserDefaults.standard.string(forKey: "profileImageUrl")!
        do{
            let url = URL(string: profileImageUrl ?? "noimage")
            let data = try Data(contentsOf: url!)
            circularImageView?.image = UIImage(data: data)!
        }catch let error{
            print(error)
        }
        print(profileImageUrl)
        
        changingProfile()
    }
    
    private func updateProfileImage() {
        HUD.show(.progress, onView: self.view)
        guard let image = circularImageView?.image else {return}
        guard let uploadImage = image.jpegData(compressionQuality: 0.1) else {return}
        
        let fileName = NSUUID().uuidString
        print(fileName)
        let storageRef = Storage.storage().reference().child("Prefile_image").child(fileName)
        
        storageRef.putData(uploadImage,metadata: nil) {(matadata,err) in
            if let err = err {
                print("Firestorageへの情報の保存に失敗しました。\(err)")
                return
            }
            print("Firestorageへの情報の保存に成功しました。")
            storageRef.downloadURL { [self] (url, err) in
                if let err = err {
                    print("Firestorageからのダウンロードに失敗しました。\(err)")
                    return
                }
                guard let userId = Auth.auth().currentUser?.uid else{fatalError()}
                let ref = Firestore.firestore().collection("users").document(userId)
                guard let urlString = url?.absoluteString else {return}
                guard let data = image.pngData() else {
                    return
                }
                ref.updateData(["profileImageUrl":urlString])
                    { err in
                    if let err = err {
                        HUD.hide { (_) in
                            HUD.flash(.error,delay: 1)}
                        print("Error updating document:\(err)")
                    }else{
                        print("Document successfully updated image")
                    }
                        HUD.hide { (_) in
                            HUD.flash(.success, onView: self.view, delay: 1) { (_) in
                                print("cucces update")
                                self.dismiss(animated: true, completion: nil)
                            }
                        }
                }
                
                print("urlString: ",urlString)
                UserDefaults.standard.set(urlString, forKey: "profileImageUrl")
            }
        }
        
        guard let userId = Auth.auth().currentUser?.uid else{fatalError()}
        let ref = Firestore.firestore().collection("users").document(userId)
        guard let changename = usernameTextField.text else{return}
        
        ref.updateData(["name":changename])
            { err in
            if let err = err {
                HUD.hide { (_) in
                    HUD.flash(.error,delay: 1)}
                print("Error updating document:\(err)")
            }else{
                print("Document successfully updated name")
                
            }
        }
        
        guard let userId = Auth.auth().currentUser?.uid else{fatalError()}
//        let ref = Firestore.firestore().collection("users").document(userId)
        guard let changemessage = profileTextField.text else{return}
        ref.updateData(["message":changemessage ])
            { err in
            if let err = err {
                print("Error updating document:\(err)")
                HUD.hide { (_) in
                    HUD.flash(.error,delay: 1)}
            }else{
                print("Document successfully updated message")
            }
        }
    }
    
    private func changingProfile() {
        usernameTextField.rx.text
            .asDriver()
            .drive{[weak self] text in
                print("text:", text as Any)
            self?.name = text ?? ""
        }
        .disposed(by: disposeBag)
        
        profileTextField.rx.text
            .asDriver()
            .drive{[weak self] text in
                print("text:", text as Any)
            self?.message = text ?? ""
        }
        .disposed(by: disposeBag)
    }
    
    
    // 写真を選んだ後に呼ばれる処理
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // 選択した写真を取得する
        let image = info[.originalImage] as! UIImage
        // ビューに表示する
        circularImageView?.image = image
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
    
 
    


