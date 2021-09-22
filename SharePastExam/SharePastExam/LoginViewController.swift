//
//  LoginViewController.swift
//  SharePastExam
//
//  Created by 馬場大夢 on 2021/09/17.
//

import UIKit

class LoginViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var departmentTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var donthaveaccountButton: UIButton!
    
    var pickerView: UIPickerView = UIPickerView()
        let list = ["エネルギー循環化学科", "機械システム工学科", "情報システム工学科", "建築デザイン学科", "環境生命工学科", "英米学科", "中国学科", "国際関係学科", "経済学科", "経営情報学科", "比較文化学科","人間関係学科","法律学科","政策科学科","地域創生学群地域創生学類"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.isEnabled = false
        loginButton.layer.cornerRadius = 10
        loginButton.isEnabled = false
        loginButton.backgroundColor = UIColor.rgb(red: 255, green: 242, blue: 255)
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        usernameTextField.delegate = self
        departmentTextField.delegate = self
        
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
    }

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        print("textField.text", textField.text)
        let emailIsEmpty = emailTextField.text?.isEmpty ?? true
        let passwordIsEmpty = passwordTextField.text?.isEmpty ?? true
        let usernameIsEmpty = usernameTextField.text?.isEmpty ?? true
        let departmentIsEmpty = departmentTextField.text?.isEmpty ?? true
        
        if emailIsEmpty || passwordIsEmpty || usernameIsEmpty || departmentIsEmpty {
            loginButton.isEnabled = false
        }else {
            loginButton.isEnabled = true
        }
    }
    
}


