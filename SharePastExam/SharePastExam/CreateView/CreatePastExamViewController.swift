//
//  CreatePastExamViewController.swift
//  SharePastExam
//
//  Created by Takashi Sakai on 2022/03/20.
//

import Foundation
import UIKit
import PKHUD
import Firebase



class CreatePastExamViewController: UIViewController {
    @IBOutlet weak var DeletePostDocButton: UIButton!
    @IBOutlet weak var doctitle: UILabel!
    @IBOutlet weak var MainStackView: UIStackView!
    @IBOutlet weak var CountStackView: UIStackView!
    @IBOutlet weak var DocImage: UIImageView!
    @IBOutlet weak var GoodCount: UILabel!
    @IBOutlet weak var ViewCount: UILabel!
    
    var docimage = UIImage()
    
    @IBAction func PostDocDelete(_ sender: Any) {
        let alert = UIAlertController(title: "投稿の削除", message:"投稿を削除してもよろしいですか？",preferredStyle: .alert)
        let delete = UIAlertAction(title: "削除", style: .default, handler: {_ in
            HUD.show(.progress,onView: self.view)
            self.PostImgDelete()
            self.PostDocDelete()
            
        })
        let cancel = UIAlertAction(title: "キャンセル", style: .default, handler: {_ in
            print("キャンセルします。")
        })
        alert.addAction(delete)
        alert.addAction(cancel)
        
        self.present(alert,animated: true,completion: nil)
    }
    
    var DocTitle = ""
    var username:String = ""
    var cellPath = ""
    var goodcount = 0
    var viewcount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.doctitle.adjustsFontSizeToFitWidth = true
        doctitle.text = DocTitle
        
        self.view.backgroundColor = UIColor.rgb(red: 241, green: 251, blue: 231)
        DeletePostDocButton.layer.cornerRadius = 5
//        MainStackView.layer.borderWidth = 1.0
//        MainStackView.layer.borderColor = UIColor.systemBrown.cgColor
//        MainStackView.layer.cornerRadius = 10
//        CountStackView.layer.borderWidth = 1.0
//        CountStackView.layer.borderColor = UIColor.systemBrown.cgColor
//        CountStackView.layer.cornerRadius = 10
        self.DocImage.image = self.docimage
        //self.DocImage.contentMode = .scaleAspectFit
        self.DocImage.clipsToBounds = true
        self.DocImage.layer.cornerRadius = 15
        
        self.GoodCount.text = String(self.goodcount)
        self.ViewCount.text = String(self.viewcount)
        
        let border = CALayer()
        border.frame = CGRect(x: 0, y: 0, width: self.MainStackView.frame.width, height: 1.0)
        border.backgroundColor = UIColor.gray.cgColor
        self.MainStackView.layer.addSublayer(border)
        
        let underborder = CALayer()
        underborder.frame = CGRect(x: 0, y: self.MainStackView.frame.height, width: self.MainStackView.frame.width, height: 1.0)
        underborder.backgroundColor =  UIColor.gray.cgColor
        self.MainStackView.layer.addSublayer(underborder)
        
        let countstatckborder = CALayer()
        countstatckborder.frame = CGRect(x: 0, y: self.CountStackView.frame.height, width: self.CountStackView.frame.width, height: 1.0)
        countstatckborder.backgroundColor = UIColor.gray.cgColor
        self.CountStackView.layer.addSublayer(countstatckborder)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    //Storageの画像を取得し、削除する関数へパスしている。
    private func PostImgDelete(){
        if !(cellPath.isEmpty){
            print("削除を実行します。")
            let cell_sep = self.cellPath.components(separatedBy: "/")
            print(cell_sep)
            
            //Storageからの削除、StoreからDocの削除
            if cell_sep.count == 3{
                let ExitImgRef = Storage.storage().reference(forURL: "gs://sharepastexamapp.appspot.com").child("images").child(cell_sep[0]).child(cell_sep[1]).child("\(cell_sep[2]).jpeg")
                
                ExitImgRef.getData(maxSize: 1024*1024*100){ (data,err) in
                    if data != nil{
                        self.putImgDataToDel(ImgData: data!,patharray: cell_sep)
                    }
                    
                }
            }
        }
        
    }
    //deleteフォルダに保存&上記の削除も実行
    private func putImgDataToDel(ImgData:Data,patharray:[String]){
        let DelImgRef = Storage.storage().reference(forURL: "gs://sharepastexamapp.appspot.com").child("DeleteImage").child(patharray[0]).child(patharray[1]).child("\(patharray[2]).jpeg")
        let ExitImgRef = Storage.storage().reference(forURL: "gs://sharepastexamapp.appspot.com").child("images").child(patharray[0]).child(patharray[1]).child("\(patharray[2]).jpeg")
        
        DelImgRef.putData(ImgData, metadata: nil){ (metadata,err) in
            if err != nil{
                print(err.debugDescription)
            }
            else{
                print("Delへのアップデート完了")
                ExitImgRef.delete(){ err in
                    if err != nil{
                        print("該当するデータが存在しません")
                    }
                    else{
                        //消した後にuserdefaults内の情報も更新、削除する
                        var cacheDoc = UserDefaults.standard.array(forKey: "RecentlyPath") as? [String] ?? []
                        let path = patharray[0] + "/" + patharray[1] + "/" + patharray[2]
                        if cacheDoc.contains(path){
                            cacheDoc.removeAll(where: {$0 == path})
                            UserDefaults.standard.set(cacheDoc, forKey: "RecentlyPath")
                        }
                    }
                }
            }
        }
    }
    
    //FireStoreの画像の削除
    private func PostDocDelete(){
        if !(cellPath.isEmpty){
            print("削除を実行します。")
            let cell_sep = self.cellPath.components(separatedBy: "/")
            print(cell_sep)
            
            //Storageからの削除、StoreからDocの削除
            if cell_sep.count == 3{
                let ExitDocRef = Firestore.firestore().collection("images").document(cell_sep[0]).collection("times").document(cell_sep[1]).collection("count").document(cell_sep[2])
                ExitDocRef.getDocument(){ (snapshot,err) in
                    if snapshot != nil{
                        let data = snapshot?.data()
                        self.putDocDataToDel(DocData: data!,patharray: cell_sep)
                        
                    }
                }
            }
        }
    }
    
    //Deleteフォルダに保存&上記の削除
    private func putDocDataToDel(DocData:[String:Any],patharray:[String]){
        print("ここでDocの実施")
        print(DocData)
        let ExitDocRef = Firestore.firestore().collection("images").document(patharray[0]).collection("times").document(patharray[1]).collection("count").document(patharray[2])
        let DelDocRef = Firestore.firestore().collection("DeleteImages").document(patharray[0]).collection("times").document(patharray[1]).collection("count").document(patharray[2])
        
        DelDocRef.setData(DocData){ (err) in
            if err != nil{
                print("setに失敗しました。")
                print(err.debugDescription)
            }
            else{
                ExitDocRef.delete(){ (err) in
                    if err != nil{
                        print("削除に失敗しました。")
                    }
                    else{
                        HUD.hide(){ (_) in
                            self.PostUserDocDataDelete()
                            HUD.flash(.success,onView: self.view)
                            self.dismiss(animated: true)
                        }
                    }
                }
            }
        }
    }
    //削除のタイミングで自身のリストからも削除する
    private func PostUserDocDataDelete(){
        let uid = Auth.auth().currentUser?.uid
        let userRef = Firestore.firestore().collection("users").document(uid!)
        
        userRef.getDocument(){ (snapshot,err) in
            if err != nil{
                print(err.debugDescription)
                print("バグが生じいます。")
            }
            else{
                let data = snapshot?.data() as? [String:Any] ?? [:]
                print(self.cellPath)
                var postData = data["PostData"] as? [String] ?? []
                if postData.count != 0{
                    postData.removeAll(where: {$0 == self.cellPath})
                    userRef.updateData(["PostData":postData]){ (err) in
                        if err != nil{
                            print(err.debugDescription)
                        }
                        else{
                            print("更新成功です。")
                        }
                    }
                }
            }
            
        }
    }
    
    
}
