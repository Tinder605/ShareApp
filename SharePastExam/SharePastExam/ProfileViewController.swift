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
    
    var PostDataArray:[PostData] = []
    //インデックスごとの情報を補完する
    var IndexSub:[String] = []
    var IndexTimes:[String] = []
    var IndexCount:[String] = []
    
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
        
        HUD.show(.progress, onView: self.view)
        //投稿数といいね数、そのデータを取得
        self.getSelfDocuments()
        
    }
    
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let username = UserDefaults.standard.string(forKey: "name") as! String
        usernameTextField.text = username
        
        let message = UserDefaults.standard.string(forKey: "message") as! String
        profileMessage.text = message
        
        let profileImageUrl = UserDefaults.standard.string(forKey: "profileImageUrl") as! String
        
        do{
            let url = URL(string: profileImageUrl as! String)
            let data = try Data(contentsOf: url!)
            profileImage.image = UIImage(data: data)!
        }catch let error{
            print("errr")
        }
    }
    
    override func viewWillAppear(_ animated:Bool ) {
        self.presentedViewController
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
        selfRef.getDocument(){(snapshot,err) in
            if let err = err{
                print("アカウント情報の取得に失敗しました")
                //ログイン画面に移動という手もあり
                return
            }
            let userData = snapshot?.data() as? [String:Any] ?? [:]
            
            
            //投稿している資料の数を取得して挿入する
            let PostDocumentsPath = userData["PostData"] as? [String] ?? []
            print(PostDocumentsPath)
            self.voteCount.text = "\(PostDocumentsPath.count)"
            print("ここに投稿数を表示します")
            print(PostDocumentsPath.count)
            //投稿機能の資料の取得
            self.getPostDocuments(PostDataPath: PostDocumentsPath)
        }
        
    }
        //渡されたpathを参照して、documentsを取得する
    private func getPostDocuments(PostDataPath:[String]){
        print(PostDataPath)
        
        var Goodcount :Int = 0
        var roopCount:Int = 0
        HUD.hide{ (_) in
         for i in PostDataPath{
            print(i)
            let arr :[String] = i.components(separatedBy: "/")
            self.IndexSub.append(arr[0])
            self.IndexTimes.append(arr[1])
            self.IndexCount.append(arr[2])
             
            let DocRef = Firestore.firestore().collection("images").document(arr[0]).collection("times").document(arr[1]).collection("count").document(arr[2])
            print(DocRef)
            DocRef.getDocument{(snapshot,err) in
                if let err = err{
                    print("ドキュメントの情報が間違っています")
                    return
                }
                let data = snapshot?.data()
                //危ない気もする
                let part_data = PostData(document: snapshot!)
                self.PostDataArray.append(part_data)
                
                print("辞書型の内容の提示")
                
                //必要なデータの取得
                print("辞書型に変更")
               
                
                print("ここからいいね数")
                let count = data?["good"] as? Int ?? 0
                print(data?["good"] as? Int ?? 0)
                print(data?["imageurl"] as? String ?? "")
                Goodcount = Goodcount + count
                self.goodCount.text = "\(Goodcount)"
                
                ///画像の取得(おそらく間に合わない)
                
                
                ///ここから再度画像の取得(if-forは遅い)
                roopCount = roopCount + 1
                if roopCount >= PostDataPath.count{
                    HUD.flash(.success, onView: self.view)
                    self.collectionView.reloadData()
                    print(self.PostDataArray[0].url!)
                    print("hideします")
                    print(self.PostDataArray.count)
                }
            }
         }
       }
        
    }

    
    
}


extension ProfileViewController:UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        print("you tapped me")
        
    }
}

extension ProfileViewController:UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.PostDataArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:MyCollectionViewCell.identifier, for: indexPath) as! MyCollectionViewCell
        cell.count = IndexCount[indexPath.row]
        cell.subject = IndexSub[indexPath.row]
        cell.times = IndexTimes[indexPath.row]
        cell.url = PostDataArray[indexPath.row].url ?? ""
        let path = URL(string: cell.url)
        print("pathの中身を表示")
        print(path)
        if (path != nil) {
            do{
                let data = try Data(contentsOf: path!)
                print("こっちにはきています")
                cell.imageView.image = UIImage(data: data)!
            }catch let error{
                cell.configure(with: UIImage(named: "IMG_6906")!)
                print("errr")
            }
        }
        else{
            cell.configure(with: UIImage(named: "IMG_6906")!)
        }
        print("ここにcell情報の表示")
        print(cell.subject)
        
        
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

