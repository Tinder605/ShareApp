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

class changeProfileViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    var childCallBack: ((String) -> Void)?
    
    private let disposeBag = DisposeBag()
    private var name = ""
    private var message = ""
    
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
    
    
    
    @IBOutlet weak var circularImageView:UIImageView!
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var profileTextField: UITextField!
    @IBOutlet weak var renewButton: UIButton!
    @IBAction func tappedRenewButton(_ sender: UIButton) {
        updadeProfileName()
        updadeProfileMessage()
        guard let changename = usernameTextField.text else{return}
        let username = changename as! String
        UserDefaults.standard.set(username, forKey: "name")
        print(username)
        
        guard let changemessage = profileTextField.text else{return}
        let message = changemessage as! String
        UserDefaults.standard.set(message, forKey: "message")
        print(message)
        
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        circularImageView.image = UIImage(named: "IMG_6906")
        circularImageView.layer.cornerRadius = circularImageView.frame.size.height / 2
        circularImageView.clipsToBounds = true
        
        renewButton.layer.cornerRadius = 10
        
        
        //let username = usernameTextField.text as! String
        UserDefaults.standard.set(name, forKey: "name")
        usernameTextField.placeholder = name
        
        //let message = profileTextField.text as! String
        UserDefaults.standard.set(message, forKey: "message")
        profileTextField.placeholder = message
        
        
        changingProfile()
        
        
        
    }
    
    private func updadeProfileName() {
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
                print("Document successfully updated")
                
            }
        }
    }
    
    private func updadeProfileMessage() {
        guard let userId = Auth.auth().currentUser?.uid else{fatalError()}
        let ref = Firestore.firestore().collection("users").document(userId)
        guard let changemessage = profileTextField.text else{return}
        ref.updateData(["message":changemessage ])
            { err in
            if let err = err {
                print("Error updating document:\(err)")
                HUD.hide { (_) in
                    HUD.flash(.error,delay: 1)}
            }else{
                print("Document successfully updated")
            }
        }
    }
    
    
    private func changingProfile() {
        usernameTextField.rx.text
            .asDriver()
            .drive{[weak self] text in
            print("text:", text)
            self?.name = text ?? ""
        }
        .disposed(by: disposeBag)
        
        profileTextField.rx.text
            .asDriver()
            .drive{[weak self] text in
            print("text:", text)
            self?.message = text ?? ""
        }
        .disposed(by: disposeBag)
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


    
 
    


