//
//  LoginViewController.swift
//  LoginWithFirebaseApp
//
//  Created by 馬場大夢 on 2021/09/10.
//  Copyright © 2021 馬場大夢. All rights reserved.
//

import UIKit
import Firebase
import PKHUD

class LoginViewController: UIViewController {
    //メールのテキストフィールド
    @IBOutlet weak var emailTextField: UITextField!
    
    //パスワードのテキストフィールド
    @IBOutlet weak var passwordTextField: UITextField!
    
    //ログインボタン
    @IBOutlet weak var loginButton: UIButton!
    
    //アカウントを持っていない人のボタン
    @IBOutlet weak var dontHaveAcountButton: UIButton!
    
    //アカウントを持っていない人のボタンを押したときの動作
    @IBAction func tappedDontHaveAcountButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    //ログインボタンを押したときの動作
    @IBAction func tappedLoginButton(_ sender: Any) {
        HUD.show(.progress, onView: self.view)
        print("tapped Login Button")
        guard let email = emailTextField.text else {return}
        print(email)
        guard  let password = passwordTextField.text else {return}
        print(password)
        
        Auth.auth().signIn(withEmail: email, password: password){
            (res, err) in if let err = err {
                print("ログイン情報の取得に失敗しました。", err)
                HUD.hide { (_) in
                    HUD.flash(.error,delay: 1)
                }
                return
            }
           
            print("ログインに成功しました。")
            
            guard let uid = res?.user.uid else {return}
            print(uid)
            
            let userRef = Firestore.firestore().collection("users").document(uid)
            
            userRef.addSnapshotListener{(snapshot, err) in
                if let err = err {
                print("ユーザー情報の取得に失敗しました。\(err)")
                    HUD.hide { (_) in
                        HUD.flash(.error,delay: 1)
                    }
                    return
                }
                guard let data = snapshot?.data() else {return}
                print(data["name"].debugDescription)
                let userdep = data["department"] as! String
                UserDefaults.standard.set(userdep, forKey: "dep")
                let usersub = self.getSubjeciton(department: userdep)
                UserDefaults.standard.set(usersub, forKey: "sub")
                let username = data["name"] as! String
                UserDefaults.standard.set(username, forKey: "name")
                let useremail = data["email"] as! String
                UserDefaults.standard.set(useremail, forKey: "email")
                let message = data["message"] as! String
                UserDefaults.standard.set(message, forKey: "message")
                let profileImageUrl = data["profileImageUrl"] as Optional<Any>
                UserDefaults.standard.set(profileImageUrl, forKey: "profileImageUrl")
                
                let user = User.init(dic: data)
                print("ユーザー情報の取得ができました。\(user.name)")
                print()
                HUD.hide{ (_) in
                    HUD.flash(.success , onView: self.view, delay: 1){(_) in
                    self.presentToHomeViewController(user: user)
                    
                    }
                }
            }
        }
    }
    
    private func getSubjeciton(department:String) ->[String:[String]]{
        var list:[String:[String]] = [:]
        switch department {
        case "情報システム工学科":
            list = Subjecsion.init().list_jouhou
        case "エネルギー循環化学科":
            list = Subjecsion.init().list_ene
        case "機械システム工学科":
            list = Subjecsion.init().list_kikai
        case "建築デザイン学科":
            list = Subjecsion.init().list_kennchiku
        case "環境生命工学科":
            list = Subjecsion.init().list_seimei
        default:
            list = [:]
        }
        return list
    }
    
    private func presentToHomeViewController(user: User) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        let profileViewController = storyBoard.instantiateViewController(identifier: "ProfileViewController") as! ProfileViewController
        profileViewController.user = user
        
        let loginViewController = storyBoard.instantiateViewController(identifier: "TabViewController") as! TabViewController
        
        loginViewController.modalPresentationStyle = .fullScreen
        
        self.present(loginViewController, animated: true, completion: nil)
        
    }

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        loginButton.layer.cornerRadius = 10
        loginButton.isEnabled = false
        loginButton.backgroundColor = UIColor.rgb(red: 223, green: 255, blue: 203)
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
}
//MARK: - UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let emailIsEmpty = emailTextField.text?.isEmpty ?? true
        
        let passwordIsEmpty = passwordTextField.text?.isEmpty ?? true
        
        if emailIsEmpty || passwordIsEmpty {
            
            loginButton.isEnabled = false
            loginButton.backgroundColor = UIColor.rgb(red: 223, green: 255, blue: 203)
        }else {
            loginButton.isEnabled = true
            loginButton.backgroundColor = UIColor.rgb(red: 0, green: 255, blue: 0)
        }
    
    }
    
}


