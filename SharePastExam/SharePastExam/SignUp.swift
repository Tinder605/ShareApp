//
//  SignUp.swift
//  SharePastExam
//
//  Created by 馬場大夢 on 2021/09/18.
//

import UIKit

class SignUp: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var departmentTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var donthaveaccountButton: UIButton!
    
    var pickerView: UIPickerView = UIPickerView()
        let list = ["エネルギー循環化学科", "機械システム工学科", "情報システム工学科", "建築デザイン学科", "環境生命工学科", "英米学科", "中国学科", "国際関係学科", "経済学科", "経営情報学科", "比較文化学科","人間関係学科","法律学科","政策科学科","地域創生学群地域創生学類"]
    
    
    
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
        
               let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(LoginViewController.done))
               let cancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(LoginViewController.cancel))
        
               toolbar.setItems([cancelItem, doneItem], animated: true)

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
               // Dispose of any resources that can be recreated.
            
            
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
        
        //print("keyboardFrame : ", keyboardFrame)
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
        print("textField.text", textField.text)
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

