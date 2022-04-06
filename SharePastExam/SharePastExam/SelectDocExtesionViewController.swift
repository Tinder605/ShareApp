//
//  SelectDocExtesionViewController.swift
//  SharePastExam
//
//  Created by Takashi Sakai on 2021/11/24.
//

import UIKit
import FirebaseFirestore
import Kingfisher
import PKHUD
import Firebase

class SelectDocExtesionViewController: UIViewController {
    
    @IBOutlet weak var DocExtensionImage: UIButton!
    @IBOutlet weak var DocExtensionTitle: UILabel!
    @IBOutlet weak var CreateUserImage: UIImageView!
    @IBOutlet weak var CreateUserName: UILabel!
    @IBOutlet weak var GoodButton: UIButton!
    
    @IBAction func GoodAction(_ sender: Any) {
        let recentlypath = UserDefaults.standard.array(forKey: "RecentlyPath") ?? [""]
        print(recentlypath[0])
        self.changeGoodValue()
    }
    @IBAction func PresentedFullDoc(_ sender: Any) {
        let storyboard = UIStoryboard(name: "ExFullDoc", bundle: nil)
        let nextscreen = storyboard.instantiateViewController(identifier: "ExFullDoc") as! ExFullDocViewController
        nextscreen.mainimage = self.mainImage
        nextscreen.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        nextscreen.modalPresentationStyle = .fullScreen
        self.present(nextscreen, animated: true)
    }
    
    
    var doctitle = ""
    var PosrUserId = ""
    var imageurl = URL(string: "")
    var mainImage :UIImage = UIImage()
    var Goodvalue = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        HUD.show(.progress, onView: self.view)
        self.view.backgroundColor = UIColor.rgb(red: 214, green: 183, blue: 123)
        self.DocExtensionTitle.text = doctitle
        let width = UIScreen.main.bounds.width
        self.DocExtensionImage.frame = CGRect(x: (width-300)/2, y: 100, width: 300, height: 300)
        self.DocExtensionImage.backgroundColor = UIColor.rgb(red: 166, green: 252, blue: 132)
        self.DocExtensionImage.layer.cornerRadius = 20
        self.DocExtensionImage.contentMode = .scaleAspectFill
        self.DocExtensionImage.clipsToBounds = true
        self.DocExtensionImage.contentVerticalAlignment = .fill
        self.DocExtensionImage.contentHorizontalAlignment = .fill
        self.DocExtensionImage.setImage(self.mainImage, for: .normal)
        
        self.CreateUserImage.contentMode = .scaleAspectFill
        self.CreateUserImage.layer.cornerRadius = self.CreateUserImage.frame.width/2
        self.CreateUserImage.clipsToBounds = true
        self.CreateUserImage.backgroundColor = UIColor.rgb(red: 166, green: 252, blue: 132)
        
        self.GoodButton.titleLabel?.text = ""
        self.GoodButton.setTitle("", for: .normal)
        self.GoodButton.imageView?.contentMode = .scaleAspectFit
        self.GoodButton.contentVerticalAlignment = .fill
        self.GoodButton.contentHorizontalAlignment = .fill

        print("いいねの値は\(self.Goodvalue)")
        if self.Goodvalue == 0{
            self.GoodButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        else{
            self.GoodButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
        let recentlypath = UserDefaults.standard.array(forKey: "RecentlyPath") ?? []
        self.getPostUserDetail()
//        do{
//            let data = try Data(contentsOf: imageurl!)
//            self.DocExtensionImage.image = UIImage(data: data)
//        }catch{
//            self.DocExtensionImage.image = UIImage()
//            self.DocExtensionImage.backgroundColor = .systemGreen
//
//        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.GoodButton.titleLabel?.text = ""
        
    }
    
    //いいね情報の取得
    
    
    private func getPostUserDetail(){
        HUD.show(.progress,onView: self.view)
        HUD.hide(){ (_) in
            if self.PosrUserId != ""{
                let userref = Firestore.firestore().collection("users").document(self.PosrUserId)
                userref.getDocument(){ (snapshot,err) in
                    if err != nil{
                        self.CreateUserName.text = "unknown user"
                        self.CreateUserImage.image = UIImage(named: "noimage.jpeg")
                    }
                    else{
                        let userdata = snapshot?.data() as? [String:Any] ?? [:]
                        self.CreateUserName.text = userdata["name"] as? String ?? "unknown user"
                        let userurl = userdata["profileImageUrl"] as? String ?? ""
                        if userurl != ""{
                            do{
                                let url = URL(string: userurl)
                                let imgdata = try Data(contentsOf: url!)
                                self.CreateUserImage.image = UIImage(data: imgdata)
                                HUD.flash(.success,onView: self.view)
                            }catch{
                                self.CreateUserImage.image = UIImage(named: "noimage.jpeg")!
                                HUD.flash(.error,onView: self.view)
                            }
                        }
                    }
                }
            }
            else{
                self.CreateUserImage.image = UIImage(named: "noimage.jpeg")!
                HUD.flash(.error,onView: self.view)
            }
        }
    }
    
    private func changeGoodValue(){
        var GoodCount = 0
        var GoodList:[String] = []
        let uid = Auth.auth().currentUser?.uid
        let recentlypath = UserDefaults.standard.array(forKey: "RecentlyPath") ?? []
        if recentlypath.count != 0{
            let path = recentlypath[0] as! String
            let arr = path.components(separatedBy: "/")
            print("使用するpath:\(arr)")
            let ref = Firestore.firestore().collection("images").document("\(arr[0])").collection("times").document("\(arr[1])").collection("count").document("\(arr[2])")
            ref.getDocument(){ (snapshot,err) in
                if snapshot != nil{
                    var image = UIImage()
                    var doc:Dictionary<String,Any>
                    doc = snapshot?.data() as! [String:Any]
                    //デバックのため一応です(Godのリストがなかったら)
                    let postUser = doc["postuser"] as? String ?? ""
                    if doc["GoodList"] == nil{
                        GoodList = ["\(uid!)"]
                        GoodCount = GoodCount + 1
                        image = UIImage(systemName: "heart.fill") ?? UIImage()
                        self.Goodvalue = 1
                    }
                    //ある場合とで
                    else{
                        GoodCount = doc["good"] as! Int
                        GoodList = doc["GoodList"] as! [String]
                        if self.Goodvalue == 0{
                            GoodList.append(uid!)
                            GoodCount = GoodCount + 1
                            image = UIImage(systemName: "heart.fill") ?? UIImage()
                            self.Goodvalue = 1
                        }
                        else{
                            print(type(of: uid!))
                            GoodList.removeAll(where: {$0 == String(uid!)})
                            GoodCount = GoodCount - 1
                            image = UIImage(systemName: "heart") ?? UIImage()
                            self.Goodvalue = 0
                        }
                    }
                    self.updateGoodRef(goodlist: GoodList, goodcount: GoodCount,path:arr)
                    self.updateUserGoodList(path:arr)
                    self.updatePostUserGoodCount(uid:postUser)
                    self.GoodButton.setImage(image, for: .normal)
                }
               }
            }
        }
            
    private func updateGoodRef(goodlist:[String],goodcount:Int,path:[String]){
            let ref = Firestore.firestore().collection("images").document("\(path[0])").collection("times").document("\(path[1])").collection("count").document("\(path[2])")
            print(goodlist)
            ref.updateData(["good":goodcount,"GoodList":goodlist]){ err in
                if let err = err{
                    print("いいねの更新に失敗しました。")
                }
                else{
                    print("いいねの更新に成功しました。")
                }
                
            }
    }
    private func updateUserGoodList(path:[String]){
        guard let uid = Auth.auth().currentUser?.uid else{return}
        let ref = Firestore.firestore().collection("users").document(uid)
        
        ref.getDocument(){ (snapshot,err) in
            if let err = err{
                print("エラーとなりました")
                return
            }
            let data = snapshot?.data() as? [String:Any] ?? [:]
            print("newelemntの表示")
            let newelement = "\(path[0])" + "/" + "\(path[1])" + "/" + "\(path[2])"
            var GoodList:[String] = []
            var AllGoodCount = data["AllGoodCount"] as? Int ?? 0
            print("ここにGoodValueを表示")
            print(self.Goodvalue)
            if let goodlist = data["GoodList"]{
                GoodList = goodlist as! [String]
                if self.Goodvalue == 0{
                    GoodList.removeAll(where: {$0 == String(newelement)})
                }
                else{
                    GoodList.append(newelement)
                }
            }
            else{
                GoodList = [newelement]
            }
            print(GoodList)
            ref.updateData(["GoodList":GoodList]){(err) in
                if let err = err{
                    print("GoodListの更新に失敗しました。")
                }
                else{
                    print("GoodListの更新に成功しました")
                }
            }
        }
    }
    private func updatePostUserGoodCount(uid:String){
        if uid != "" {
            let postUserRef = Firestore.firestore().collection("users").document(uid)
            postUserRef.getDocument(){ (snapshot,err) in
                if err != nil{
                    print(err.debugDescription)
                    print("取得の失敗")
                }
                else{
                    let data = snapshot?.data() as? [String:Any] ?? [:]
                    var postUserAllgoodcount = data["AllGoodCount"] as? Int ?? 0
                    if self.Goodvalue == 0{
                        postUserAllgoodcount = postUserAllgoodcount - 1
                        if postUserAllgoodcount < 0{
                            postUserAllgoodcount = 0
                        }
                    }
                    else{
                        postUserAllgoodcount = postUserAllgoodcount + 1
                    }
                    postUserRef.updateData(["AllGoodCount":postUserAllgoodcount]){ (err) in
                        if err != nil{
                            print(err.debugDescription)
                            print("AllGoodCountの更新失敗")
                        }
                    }
                }
            }
        }
    }
    
    
    
    
    
}
