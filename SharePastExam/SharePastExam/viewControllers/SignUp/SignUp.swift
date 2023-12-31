//
//  SignUp.swift
//  SharePastExam
//
//  Created by 馬場大夢 on 2021/09/18.
//

import UIKit
import Firebase
import PKHUD

struct User {
    let name: String
    let createdAt: Timestamp
    let email: String
    let department: String
    let message: String
    let profileImageUrl: String
    
    init(dic:[String: Any]) {
        self.name = dic["name"] as! String
        self.email = dic["email"] as! String
        self.department = dic["department"] as! String
        self.createdAt = dic["createdAt"] as! Timestamp
        self.message = dic["message"] as! String
        self.profileImageUrl = dic["profileImageUrl"] as! String
    }
}


class SignUp: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource {
    //メッセージのテキストフィールド
    @IBOutlet weak var messageTextField: UITextField!
    
    //メールのテキストフィールド
    @IBOutlet weak var emailTextField: UITextField!
    
    //パスワードのテキストフィールド
    @IBOutlet weak var passwordTextField: UITextField!
    
    //名前のテキストフィールド
    @IBOutlet weak var usernameTextField: UITextField!
    
    //学科のテキストフィールド
    @IBOutlet weak var departmentTextField: UITextField!
    
    //登録ボタン
    @IBOutlet weak var registerButton: UIButton!
    
    //アカウントを持っている人のボタン
    @IBOutlet weak var HaveAcountButton: UIButton!
    
    //登録ボタンを押したときの動作
    @IBAction func tappedRegisterButton(_ sender: Any) {
        handleAuthToFirebase()
        print("tappedRegisterButton")
    }
    
    //アカウントを持っている人のボタンを押したときの動作
    @IBAction func tappedHaveAcountButton(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Login", bundle: nil)
        let homeViewController = storyBoard.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
        homeViewController.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(homeViewController, animated: true)
        print("tappedHaveAcountButton")
    }
    
    private func next(_ sender: Any) {
        
        let tabbarController = self.storyboard?.instantiateViewController(withIdentifier: "Main") as! UITabBarController
        self.navigationController?.pushViewController(tabbarController, animated: true)
    }
    
    
    private func handleAuthToFirebase(){
        HUD.show(.progress,onView: view)
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        
        Auth.auth().createUser(withEmail: email, password: password) {(res,err) in
            if let err = err{
                print("認証情報の保存に失敗しました。\(err)")
                HUD.hide { (_) in
                    HUD.flash(.error,delay: 1)
                }
                return
            }
            self.addUserInfoFirestore(email:email, profileImageUrl: "")
        }
    }
    
    private func addUserInfoFirestore(email: String,profileImageUrl: String){
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        guard let name = self.usernameTextField.text else {return}
        guard let department = self.departmentTextField.text else {return}
        guard let message = self.messageTextField.text else {return}
        
        
        let profileImageUrl = "noimage"
        UserDefaults.standard.set(profileImageUrl, forKey: "profileImageUrl")
        
        let docData = ["email": email, "name": name, "department":department,"message": message, "createdAt": Timestamp(),"profileImageUrl":profileImageUrl] as [String : Any]
        let userRef = Firestore.firestore().collection("users").document(uid)
        userRef.setData(docData){(err) in
            if let err = err {
                print("Firestoreへの保存に失敗しました。\(err)")
                HUD.hide { (_) in
                    HUD.flash(.error,delay: 1)
                }
                return
            }
            print("Firestoreへの保存に成功しました。")
            
            userRef.getDocument{(snapshot,err) in
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
                let array:[String] = []
                UserDefaults.standard.set(array, forKey: "RecentlySub")
                let message = data["message"] as! String
                UserDefaults.standard.set(message, forKey: "message")
                let profileImageUrl = data["profileImageUrl"] as Optional<Any>
                UserDefaults.standard.set(profileImageUrl, forKey: "profileImageUrl")
                
                let user = User.init(dic: data)
                print("ユーザー情報の取得ができました。\(user.department)")
                HUD.hide { (_) in
                    HUD.flash(.success, onView: self.view, delay: 1) { (_) in
                        self.presentToHomeViewController(user: user)
                        //self.presentToProfileViewController(user: user)
                        print(uid)
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
    
    private func presentToHomeViewController(user: User){
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let homeViewController = storyBoard.instantiateViewController(identifier: "TabViewController") as! TabViewController
        homeViewController.modalPresentationStyle = .fullScreen
    
        self.present(homeViewController, animated: true, completion: nil)
    }
    
    
    var pickerView: UIPickerView = UIPickerView()
        let list = ["エネルギー循環化学科", "機械システム工学科", "情報システム工学科", "建築デザイン学科", "環境生命工学科", "英米学科", "中国学科", "国際関係学科", "経済学科", "経営情報学科", "比較文化学科","人間関係学科","法律学科","政策科学科","地域創生学群地域創生学類"]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerButton.isEnabled = false
        registerButton.layer.cornerRadius = 10
        registerButton.isEnabled = false
        registerButton.backgroundColor = UIColor.rgb(red: 223, green: 255, blue: 203)
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        usernameTextField.delegate = self
        departmentTextField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector (showKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.showsSelectionIndicator = true

               let toolbar = UIToolbar(frame: CGRectMake(0, 0, 0, 35))
        
               self.departmentTextField.inputView = pickerView
               self.departmentTextField.inputAccessoryView = toolbar
           }

           func numberOfComponents(in pickerView: UIPickerView) -> Int {
               return 1
           }

           func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
               return list.count
           }

           func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
               return list[row]
           }

           func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
               self.departmentTextField.text = list[row]
           }

    @objc func cancel() {
               self.departmentTextField.text = ""
               self.departmentTextField.endEditing(true)
           }

    @objc func done() {
               self.departmentTextField.endEditing(true)
           }

           func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
               return CGRect(x: x, y: y, width: width, height: height)
           }

           override func didReceiveMemoryWarning() {
               super.didReceiveMemoryWarning()
           }
    
    @objc func showKeyboard(notification: Notification) {
        let keyboardFrame = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        
        guard let keyboardMinY = keyboardFrame?.minY else {return}
        let registerBottonMaxY = registerButton.frame.maxY
        let distance = registerBottonMaxY - keyboardMinY + 20
        
        let transform = CGAffineTransform(translationX: 0, y: -distance)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [], animations: {
            self.view.transform = transform
        })
        
    }
    
    @objc func hideKeyboard() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [], animations: {
            self.view.transform = .identity
        })
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    }

extension SignUp: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let emailIsEmpty = emailTextField.text?.isEmpty ?? true
        let passwordIsEmpty = passwordTextField.text?.isEmpty ?? true
        let usernameIsEmpty = usernameTextField.text?.isEmpty ?? true
        let departmentIsEmpty = departmentTextField.text?.isEmpty ?? true
        
        if emailIsEmpty || passwordIsEmpty || usernameIsEmpty || departmentIsEmpty {
            registerButton.isEnabled = false
            registerButton.backgroundColor = UIColor.rgb(red: 223, green: 255, blue: 203)
        }else {
            registerButton.isEnabled = true
            registerButton.backgroundColor = UIColor.rgb(red: 0, green: 255, blue: 0)
        }
    }
}

