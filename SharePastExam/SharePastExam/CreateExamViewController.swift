//
//  CreateExamViewController.swift
//  SharePastExam
//
//  Created by Takashi Sakai on 2021/10/14.
//

import Foundation
import UIKit
import Firebase
import FirebaseStorage

class CreateExamViewController: UIViewController {
    
    @IBAction func AddPickerImage(_ sender: Any) {
        PostFromLibrary()
    }
    
    @IBAction func PostPastExam(_ sender: Any) {
        PostToFirebase()
    }
    
    @IBOutlet weak var SelectPickerImage: UIImageView!
    @IBOutlet weak var PostPastExamButton: UIButton!
    @IBOutlet weak var PostTitleTextField: UITextField!
    
    
    var postsub:String = ""
    var selectImage :UIImage = UIImage()
   // var ImageCountEmpty:Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

            PostPastExamButton.backgroundColor = .red
            PostPastExamButton.isEnabled = false
        
        PostTitleTextField.delegate = self
  
    }
    //pickerから画面のImageへ投函
    private func PostFromLibrary(){
        pickImageFromLibbrary()
    }
    
    //Firebaseに投稿
    private func PostToFirebase(){
        
    }
    
    @objc func showKeyboard(notification: Notification) {
        let keyboardFrame = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        
        guard let keyboardMinY = keyboardFrame?.minY else {return}
        let registerBottonMaxY = PostPastExamButton.frame.maxY
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



extension CreateExamViewController:UITextFieldDelegate{
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let TitleText = PostTitleTextField.text?.isEmpty ?? true
        
        if TitleText == true{
            PostPastExamButton.isEnabled = false
            PostPastExamButton.backgroundColor = .red
        }
        else{
            if let images = SelectPickerImage.image{
            PostPastExamButton.isEnabled = true
            PostPastExamButton.backgroundColor = .systemGreen
           }
        }
    }
}

extension CreateExamViewController:UINavigationControllerDelegate{
    func pickImageFromLibbrary(){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            let controller = UIImagePickerController()
            controller.delegate = self
            controller.sourceType =  UIImagePickerController.SourceType.photoLibrary

            present(controller, animated: true, completion: nil)
        }
    }
}

extension CreateExamViewController :UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let data = (info[UIImagePickerController.InfoKey.originalImage] as! UIImage).pngData(){
            
            
            SelectPickerImage.image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            
            
        }
        if let vaildImage = SelectPickerImage.image{
            if let posttitle = PostTitleTextField.text?.isEmpty{
                PostPastExamButton.isEnabled = false
                PostPastExamButton.backgroundColor = .red
            }
            else {
                PostPastExamButton.isEnabled = true
                PostPastExamButton.backgroundColor = .systemGreen
            }
        }
        dismiss(animated: true)
//        let storage = Storage.storage()
//        let storageRef  = storage.reference()
//        let user = Auth.auth().currentUser
//        if let user = user{
//            if let data = (info[UIImagePickerController.InfoKey.originalImage] as! UIImage).pngData(){
//                let department = UserDefaults.standard.string(forKey: "dep") as! String
//                let recetly = UserDefaults.standard.array(forKey: "RecentlySub") as! [String]
//
//                let reference = storageRef.child("images/" + "\(department)" + "/" + "\(recetly[0])" + "count" + ".jpeg")
//                let meta = StorageMetadata()
//                let postdata[String:Int]  = ["\(recetly[0])":(Int)]
//                UserDefaults.standard.set(, forKey: <#T##String#>)
//                meta.contentType = "image/png"
//                reference.putData(<#T##uploadData: Data##Data#>, metadata: <#T##StorageMetadata?#>, completion: <#T##((StorageMetadata?, Error?) -> Void)?##((StorageMetadata?, Error?) -> Void)?##(StorageMetadata?, Error?) -> Void#>)
//            }
//        }
    }
}
