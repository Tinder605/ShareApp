//
//  ProfileViewController.swift
//  SharePastExam
//
//  Created by 馬場大夢 on 2021/10/04.
//
import Foundation
import UIKit
import Firebase
import PKHUD
import FirebaseFirestore
import Nuke
import FirebaseStorage
import SDWebImage

class PostData:NSObject{
    
    var count:String?
    var GoodCount:Int?
    var ViewCount:Int?
    var Title:String?
    var url :String?
    var goodList:[String]?
    //辞書型の要素を確認
    init(document:DocumentSnapshot) {
        let doc = document.data()
        self.count = doc!["count"] as? String ?? "0"
        self.ViewCount = doc!["viewcount"] as? Int ?? 0
        self.GoodCount = doc!["good"] as? Int ?? 0
        self.Title = doc!["title"] as? String ?? "notitle"
        self.url = doc!["imageurl"] as? String ?? "nourl"
        self.goodList = doc!["GoodList"] as? [String] ?? [" "]
    }
    
}


class ProfileViewController: UIViewController {
    
    var user: User? {
        didSet {
            print("user?.name: ",user!.name)
        }
    }
    var PostDataCount:[String] = []
    var PostDataPath :[String] = []
    
    @IBOutlet weak var voteCount: UILabel!
    @IBOutlet weak var usernameTextField: UILabel!
    @IBOutlet weak var profileImage:UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var goodCount: UILabel!
    @IBOutlet weak var profileMessage: UILabel!
    @IBOutlet weak var changeProfile: UIButton!
    @IBAction func tappedChangeAcountButton(_ sender: Any) {
        
        let storyBoard = UIStoryboard(name: "RenewProfile", bundle: nil)
        let homeViewController = storyBoard.instantiateViewController(identifier: "changeProfileViewController") as! changeProfileViewController
        homeViewController.modalPresentationStyle = .fullScreen
        
        self.present(homeViewController, animated: true, completion: nil)
        
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        //下のバー
        tabBarController?.tabBar.barTintColor = UIColor.rgb(red: 166, green: 252, blue: 132)
        guard let tabBarController = tabBarController else { return }
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.backgroundColor = UIColor.rgb(red: 166, green: 252, blue: 132)
        tabBarController.tabBar.standardAppearance = tabBarAppearance

            //ここのif文いるのか
        if #available(iOS 15.0, *) { // 新たに追加
            tabBarController.tabBar.scrollEdgeAppearance = tabBarAppearance
        }

        //self.navigationController!.navigationBar.titleTextAttributes = [
                    //.foregroundColor: UIColor.white
                //]
        //UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        
        profileImage.image = UIImage(named: "noimage.jpeg")!
        profileImage.contentMode = .scaleAspectFill
        profileImage.layer.cornerRadius = profileImage.frame.size.height / 2
        profileImage.clipsToBounds = true
        
        changeProfile.layer.borderColor = UIColor.yellow.cgColor  // 枠線の色
        changeProfile.layer.borderWidth = 0.1
        
        
        let useremail = UserDefaults.standard.string(forKey: "email") as! String
        navigationItem.title = useremail
        
        
        let username = UserDefaults.standard.string(forKey: "name") as! String
        usernameTextField.text = username
        
        let message = UserDefaults.standard.string(forKey: "message") as! String
        profileMessage.text = message
        
        //プロフィール編集ボタンのviewの設定
        changeProfile.layer.cornerRadius = 5
        changeProfile.layer.borderColor = UIColor.black.cgColor
        changeProfile.layer.borderWidth = 0.1
        
        //collectionviewのセルの設定
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 123, height: 123)
        collectionView.collectionViewLayout = layout
        collectionView.register(MyCollectionViewCell.nib(), forCellWithReuseIdentifier: MyCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        
         
        //投稿数といいね数、そのデータを取得
        //self.getSelfDocuments()
        
    }
    
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let username = UserDefaults.standard.string(forKey: "name") as! String
        usernameTextField.text = username
        
        let message = UserDefaults.standard.string(forKey: "message") as! String
        profileMessage.text = message
        
        let profileImageUrl = UserDefaults.standard.string(forKey: "profileImageUrl") ?? "noimage"
        
        //プロフィール画像の挿入
        if profileImageUrl == "noimage"{
            let uid = Auth.auth().currentUser?.uid
            let ref = Firestore.firestore().collection("users").document(uid!)
            ref.getDocument(){ (snapshot,err) in
                if err != nil{
                    self.profileImage.image = UIImage(named: "noimage.jpeg")!
                }
                else{
                    let data = snapshot?.data() as? [String:Any] ?? [:]
                    let profileurl = data["profileImageURL"] as? String ?? ""
                    if profileurl != "noimage" && profileurl != ""{
                        let url = URL(string: profileurl )
                        do{
                            let imgdata = try Data(contentsOf: url!)
                            self.profileImage.image = UIImage(data: imgdata)!
                        }catch{
                            self.profileImage.image = UIImage(named: "noimage.jpeg")!
                        }
                    }
                    else{
                        self.profileImage.image = UIImage(named: "noimage.jpeg")!
                    }
                }
            }
        }
        else{
            do{
                let url = URL(string: profileImageUrl as! String)
                let data = try Data(contentsOf: url!)
                profileImage.image = UIImage(data: data)!
            }catch{
                print("catchされています。")
                print("errr")
            }
            
        }
        print("ここに表示するで\(profileImageUrl)")
    }
    
    override func viewWillAppear(_ animated:Bool ) {
        HUD.show(.progress, onView: self.view)
        self.getSelfDocuments()
    }
    
    private func confirmLoggedInUser() {
        if Auth.auth().currentUser?.uid == nil  {
            presentToMainViewController()
            print(Auth.auth().currentUser!.uid)
        }
    }
    
    private func presentToMainViewController() {
    let storyBoard = UIStoryboard(name: "RenewProfile", bundle: nil)
        let ChangeProfileViewController = storyBoard.instantiateViewController(identifier: "changeProfileViewController") as! changeProfileViewController
        
        let navController = UINavigationController(rootViewController: ChangeProfileViewController)
        
        navController.modalPresentationStyle = .fullScreen
        
        self.present(navController, animated: true, completion: nil)
    }
    private func getSelfDocuments(){
        let uid = Auth.auth().currentUser?.uid
        let selfRef = Firestore.firestore().collection("users").document(uid!)
        HUD.hide{ (_) in
        selfRef.getDocument(){(snapshot,err) in
            if let err = err{
                print("アカウント情報の取得に失敗しました")
                //ログイン画面に移動という手もあり
                return
            }
            let userData = snapshot?.data() as? [String:Any] ?? [:]
            self.goodCount.text = "\(userData["AllGoodCount"] ?? 0)"
            //投稿している資料の数を取得して挿入する
            let PostDocumentsPath = userData["PostData"] as? [String] ?? []
            self.PostDataPath = userData["PostData"] as? [String] ?? []
            print(PostDocumentsPath)
            self.voteCount.text = "\(PostDocumentsPath.count)"
            print("ここに投稿数を表示します")
            print(PostDocumentsPath.count)
            self.collectionView.reloadData()
            HUD.flash(.success, onView: self.view)
          }
        }
    }
}


extension ProfileViewController:UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        print("you tapped me")
        let window = UIStoryboard(name: "CreatePastDoc", bundle: nil)
        let nextscreen = window.instantiateViewController(withIdentifier: "CreatePastDoc") as! CreatePastExamViewController
        //紐付けされているcellから情報を取得
        let name = UserDefaults.standard.string(forKey: "name") ?? "Unknown"
        print("profileのname")
        print(name)
        let cell = collectionView.cellForItem(at: indexPath) as? MyCollectionViewCell
        let cell_text = cell?.title
        print(cell_text ?? "")
        nextscreen.DocTitle = cell_text ?? "Notitle"
        nextscreen.username = name
        nextscreen.cellPath = self.PostDataPath[indexPath.row]
        print(self.PostDataPath[indexPath.row])
        self.present(nextscreen, animated: true, completion: nil)
        
    }
}

extension ProfileViewController:UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.PostDataPath.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:MyCollectionViewCell.identifier, for: indexPath) as! MyCollectionViewCell
        if self.PostDataPath.count == 0{
            cell.configure(with: UIImage(named: "noimage.jpeg")!)
        }
        else{
            cell.cellpath = self.PostDataPath[indexPath.row]
            print(self.PostDataPath[indexPath.row])
            cell.awakeFromNib()
        }
        return cell
    }
}

extension ProfileViewController:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.view.frame.width
        let wid = (width-30)/3
        return CGSize(width: wid, height: wid)
    }
}

