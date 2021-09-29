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
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var dontHaveAcountButton: UIButton!
    
    @IBAction func tappedDontHaveAcountButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
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
                return
            }
            print("ログインに成功しました。")
            
            guard let uid = res?.user.uid else {return}
            print(uid)
            
            let userRef = Firestore.firestore().collection("users").document(uid)
            
            
            userRef.getDocument{(snapshot, err) in
                if let err = err {
                print("ユーザー情報の取得に失敗しました。\(err)")
                HUD.hide{(_) in
                    HUD.flash(.error, delay: 1)
                }
                return
                }
                guard let data = snapshot?.data() else {return}
                print(data)
                let user = User.init(dic: data)
                print("ユーザー情報の取得ができました。\(user.name)")
                HUD.hide{ (_) in
                    HUD.flash(.success , onView: self.view, delay: 1){(_) in
                    self.presentToHomeViewController(user: user)
                    }
                }
                
                
            }
        }
    }
    
    private func presentToHomeViewController(user: User) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
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
        
        print("textField.text:",textField.text)
    }
    
}


