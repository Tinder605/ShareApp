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
import SwiftUI


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
    var postImageData :NSData = NSData()
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
//        let storage = Storage.storage()
//        let storageRef = storage.reference()
        let user = Auth.auth().currentUser
        if let user = user{
            let userdep = UserDefaults.standard.string(forKey: "dep") ?? " "
            let usersub = UserDefaults.standard.array(forKey: "RecentlySub") ?? [""]
            let usertimes = UserDefaults.standard.string(forKey: "RecentlyTimes") ?? " "
            let countRef = Firestore.firestore().collection("imagescount").document("\(usersub[0])").collection("times").document("\(usertimes)")//投稿されている数を取得
           
            countRef.getDocument{ (shapshot,err) in
                if let err = err{
                    //ローディングして、中断 or ここで生成してもらうか
                    print("中断します")
                    return
                }
                var dicData:Dictionary<String,Any>
                var number = 0
                if let data = shapshot?.data(){
                    dicData = shapshot?.data() as! [String:Any]
                }else{
                    number = number + 1
                    //Firestore上のcountを更新
                    self.CreateImagesCountDocuments(sub: "\(usersub[0])",times: "\(usertimes)")
                    dicData = ["count":"0"]
                    print("合計は \(number)")
                    
                }
                print(type(of: dicData))
                //imagescountの講義名＆第○講義の何個目か
                let count = dicData["count"] as! String
                //Firestorageに画像を保存
                self.PostToFireStore(count:count, department: userdep,subjection: "\(usersub[0])",subtimes: "\(usertimes)")
                ///Firestorageに画像の投函
                self.UpdateImagesCount(count: count, sub: "\(usersub[0])",times: "\(usertimes)")
                self.dismiss(animated: true, completion: nil)
            }
        }
        
    }

    
    ///Imagescountの生成
    private func CreateImagesCountDocuments(sub:String,times:String){
        let countRef = Firestore.firestore().collection("imagescount").document(sub).collection("times").document(times)
        let imgRef = countRef.collection("count").document("0")
        let dic = ["subjection":sub,"count":"0"]
        imgRef.setData(dic){ (err) in
            if let err = err{
                print("セットするデータがありません。")
                return
            }
        }
        print("Mission Complete")
  
    }
    ///imagescountの更新
    private func UpdateImagesCount(count:String, sub:String,times:String){
        let data = Firestore.firestore().collection("imagescount").document(sub).collection("times").document(times)
        let countInt = Int(count)!
        print(countInt)
        let counstr = "\(countInt + 1)"
        let doc = ["subtimes":times,"count":counstr] as! [String:String]
        data.setData(doc){ (err) in
            if let err = err {
                print("ImageCountの更新に失敗しました。")
                return
            }
        }
        print("ImageCountの更新に成功しました。")
        
        
    }
    
    private func PostToFireStore(count:String,department:String,subjection:String,subtimes:String){
        let StorageRef = Storage.storage().reference()
        
        if let data = SelectPickerImage.image?.pngData() {
                let reference = StorageRef.child("images/" + subjection + "/" + "\(subtimes)" + "/" + "\(count)" + ".jpeg")
                let meta = StorageMetadata()
                meta.contentType = "image/jpeg"
                reference.putData(data as Data, metadata: meta, completion: {(metaData,err) in
                if let err = err{
                    print("投稿に失敗しました。")
                    return
                }
                    print("画像のデータ情報の取得")
                    print(metaData!)
                     reference.downloadURL{ (url,err) in
                        if let url = url{
                            let dowloadURL = url.absoluteString
                            self.CreateImagesDocumente(sub: subjection, url: dowloadURL,count: count,times: subtimes)
                        }
                }
            })
        }
        else{
            print("画像の取得ができません")
            return
        }
    }
    
    ///imagesのドキュメント生成
    private func CreateImagesDocumente(sub:String,url:String,count:String,times:String){
        let imageRef = Firestore.firestore().collection("images").document(sub).collection("times").document(times)
        let imgRef = imageRef.collection("count").document("\(count)")
        let uid = Firebase.Auth.auth().currentUser?.uid
        let times = UserDefaults.standard.string(forKey: "RecentlyTimes")!
        let doctitle = PostTitleTextField.text as! String
        let doc = ["postuser":uid,"subtimes":times,"good":0,"viewcount":0 ,"imageurl":url,"count":count,"title":doctitle] as! [String : Any]
        
        imgRef.setData(doc){(err) in
            if let err = err{
                print("imagesの更新に失敗しました。")
                return
            }
            //ここで自身のfirestoreに投稿した画像のurlを掲載する（関数)引数として、
            self.selfPostData(sub: sub, count: count, times: times, uid: uid!)
            print("imagesの更新に成功しました。")
            
        }
        
    }
    //自分のポストしたデータについて
    private func selfPostData(sub:String,count:String,times:String,uid:String){
        let ref = Firestore.firestore().collection("users").document(uid)
        ref.getDocument(){ (snapshot,err) in
            if let err = err{
                print("再度ログインしてください")
            }
            else{
                let data = snapshot?.data() as [String:Any]
                var userpostdata = [""]
                let newdata = "\(sub)"+"/"+"\(times)"+"/"+"\(count)"
                let PostDataBox = data["PostData"]
                print(PostDataBox)
                
                if PostDataBox==nil{
                    print("こっちに来ています")
                    
                    
                    userpostdata = [newdata]
                }else{
                    
                    userpostdata = (PostDataBox as! [String])
                    print(userpostdata)
                    userpostdata.append(newdata)
                }
                ref.updateData(["PostData":userpostdata]){ (err) in
                    if let err = err{
                        print("アップデートに失敗しました")
                    }
                    
                }
            }
        }
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
            postImageData = (SelectPickerImage.image as! UIImage).pngData() as! NSData
            
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
    }
}
