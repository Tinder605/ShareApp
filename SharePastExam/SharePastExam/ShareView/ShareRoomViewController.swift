//
//  ShareRoomViewController.swift
//  SharePastExam
//
//  Created by Takashi Sakai on 2021/10/11.
//

import UIKit
import SDWebImage
import Firebase
import FirebaseStorage
import PKHUD


class PastData:NSObject{
    
    var count:String?
    var GoodCount:Int?
    var ViewCount:Int?
    var Title:String?
    var url :String?
    var goodList:[String]?
    var postuserid:String?
    //辞書型の要素を確認
    init(document:QueryDocumentSnapshot) {
        let doc = document.data()
        self.count = doc["count"] as? String
        self.ViewCount = doc["viewcount"] as? Int
        self.GoodCount = doc["good"] as? Int
        self.Title = doc["title"] as? String
        self.url = doc["imageurl"] as? String
        self.goodList = doc["GoodList"] as? [String]
        self.postuserid = doc["postuser"] as? String ?? ""
    }
    
}



class ShareRoomViewController: UIViewController, UICollectionViewDataSource ,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout, UIAdaptivePresentationControllerDelegate{

    @IBOutlet weak var PostButton: UIButton!
    @IBOutlet weak var ShareRoomCollectionView: UICollectionView!
    @IBOutlet weak var ShareRoomViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var ShareRoomCollectionViewWidth: NSLayoutConstraint!
    
    @IBAction func PostButtonAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "CreatePastExam", bundle: nil)
        let nextwindow = storyboard.instantiateViewController(withIdentifier: "CreatePastExam") as! CreateExamViewController
        self.present(nextwindow, animated: true, completion: nil)
    }
    //前回押した第何講義か
    var timestile :String = ""
    var count:String!
    var itemcount = 0 //cellの初期状態の個数
    
    var testDataArray:[PastData] = [] //データベースの情報一覧
    
    var imagearray :[UIImage] = []
    let width = UIScreen.main.bounds.width
    let height  = UIScreen.main.bounds.height
    let navheight = UIViewController().navigationController?.navigationBar.frame.size.height
    
    let uid = Auth.auth().currentUser?.uid//念の為再定義(userdefaultにあれば削除）
    
    override func viewDidLayoutSubviews() {
       super.viewDidLayoutSubviews()
        //タブバー縦の幅
        let tabstract = tabBarController?.tabBar.frame.height
        let navstract = navigationController?.navigationBar.frame.height
        print(navstract ?? 1000)
        print(tabstract ?? 1000)
        let wid = (width-10)/2
        self.ShareRoomCollectionViewWidth.constant = width
        self.ShareRoomViewHeight.constant = height - (navstract ?? 0) - (tabstract ?? 0) - 50
        self.ShareRoomCollectionView.clipsToBounds = true
        print("フレームの表示")
        print(self.ShareRoomCollectionView.frame)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UserDefaults.standard.array(forKey: "RecentlySub") != nil{
            let subjection = UserDefaults.standard.array(forKey: "RecentlySub") as! [String]
            print("subjectionの表示\(subjection)")
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.rgb(red: 166, green: 252, blue: 132)
        ShareRoomCollectionView.backgroundColor = UIColor.rgb(red: 166, green: 252, blue: 132)

        PostButton.layer.cornerRadius = 30
        PostButton.setTitle("", for: .normal)
        navigationItem.title = timestile
        self.getStartDocuments()
        
        
//        guard let tabBarController = tabBarController else { return }
//        let tabBarAppearance = UITabBarAppearance()
//        tabBarController.tabBar.standardAppearance = tabBarAppearance
//        if #available(iOS 15.0, *) { // 新たに追加
//            tabBarController.tabBar.scrollEdgeAppearance = tabBarAppearance
//        }
        let nib = UINib(nibName: "ShareRoomCollectionViewCell", bundle: nil)
        self.ShareRoomCollectionView.register(nib, forCellWithReuseIdentifier: "CellView")
        ShareRoomCollectionView.dataSource = self
        ShareRoomCollectionView.delegate = self
        ShareRoomCollectionView.isScrollEnabled = true
        
        
    }
    //imageの情報の取得
    private func getStartDocuments(){
        HUD.show(.progress, onView: self.view)
        let times = UserDefaults.standard.string(forKey: "RecentlyTimes") ?? " "
        let sub = UserDefaults.standard.array(forKey: "RecentlySub") ?? [""]
        print(sub)
        let ref = Firestore.firestore().collection("images").document("\(sub[0])")
        let imginforef = ref.collection("times").document(times).collection("count")
        HUD.hide{ (_) in
            imginforef.getDocuments(){(querySnapshots,err) in
                if let err = err{
                    print("データ取得失敗")
                    return
                }
                else{
                    
                    self.testDataArray = querySnapshots!.documents.map{ document in
                        let data = PastData(document: document)
                        print(data)
                        return data
                    }
                    HUD.flash(.success, onView: self.view)
                    self.ShareRoomCollectionView.reloadData()
                }
            }
        }
    }
}

extension ShareRoomViewController {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //print("データベースの要素数は、\(self.testDataArray.count)")
        return self.testDataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.view.frame.width
        let wid = (width-10)/2
        return .init(width: wid, height: 7*wid/5)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let window = UIStoryboard(name: "SelectDocExtesion", bundle: nil)
        let nextscreen = window.instantiateViewController(withIdentifier: "SelectDocExtesion") as! SelectDocExtesionViewController
        let cell = collectionView.cellForItem(at: indexPath) as? ShareRoomCollectionCellView
        if let nexttitle = testDataArray[indexPath.row].Title{
            nextscreen.doctitle = testDataArray[indexPath.row].Title!
            let sub = UserDefaults.standard.array(forKey: "RecentlySub") ?? [""]
            let times = UserDefaults.standard.string(forKey: "RecentlyTimes") ?? ""
            let path = "\(sub[0])" + "/" + "\(times)" + "/" + "\(self.testDataArray[indexPath.row].count ?? "")"
            var getPath = UserDefaults.standard.array(forKey: "RecentlyPath") ?? []
            if getPath.count != 0{
                getPath.insert(path, at: 0)
                if getPath.count>3{
                    while getPath.count>3{
                        getPath.removeLast()
                    }
                    
                }
                let orderset = NSOrderedSet(array: getPath)
                getPath = orderset.array as! [String]
                print("getPath:" + "\(getPath)")
            }
            else{
                getPath = [path]
            }
            UserDefaults.standard.set(getPath, forKey: "RecentlyPath")
        }
        if let nextimage = testDataArray[indexPath.row].url{
            nextscreen.imageurl = URL(string: nextimage)
        }
        if testDataArray[indexPath.row].postuserid != ""{
            nextscreen.PosrUserId = self.testDataArray[indexPath.row].postuserid ?? ""
        }
        if cell?.PostImages.image != nil{
            nextscreen.mainImage = cell?.PostImages.image ?? UIImage()
        }
        //goodvalueの値渡し
        nextscreen.Goodvalue = cell?.Goodvalue as? Int ?? 0
        nextscreen.presentationController?.delegate = self
        self.present(nextscreen, animated: true, completion: nil)
        
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellView", for: indexPath) as! ShareRoomCollectionCellView
        //cell.fittoview(width: (width-30)/3, height: (width-30)/3)
        cell.number = testDataArray[indexPath.row].count ?? ""
        //viewcountの取得
        //if let viewcount = testDataArray[indexPath.row].ViewCount{
            //cell.ViewCount.text = "\(viewcount)"
        //}else{
            //cell.ViewCount.text = "unknown"
        //}
        
        //タイトルの取得
        if let doctitle = testDataArray[indexPath.row].Title{
            cell.titleLabel.text  = "\(doctitle)"
        }else{
            cell.titleLabel.text = "No Title"
        }
        //いいね表示
        let docgood = testDataArray[indexPath.row].goodList ?? [""]
        
        let yourgood = docgood.filter({$0 == String(uid!)})
        var image = UIImage(systemName: "heart")
        print("aiu",yourgood)
        if !(yourgood.isEmpty){
            cell.Goodvalue = 1
            image = UIImage(systemName: "heart.fill")
            cell.ReviewButton.setImage(image!, for: .normal)
        }else{
            cell.Goodvalue = 0
            cell.ReviewButton.setImage(image!, for: .normal)
            
        }
        
        //viewのimageの取得
        let sub = UserDefaults.standard.array(forKey: "RecentlySub") as? [String] ?? [""]
        let times = UserDefaults.standard.string(forKey: "RecentlyTimes") ?? ""
        
        //セルの変数に代入
        cell.subjection = sub[0]
        cell.subtimes = times
        cell.PostImages.image = UIImage(named: "noimage.jpeg")!
        cell.ViewCount.text = String(self.testDataArray[indexPath.row].ViewCount ?? 0)
        cell.postuid = self.testDataArray[indexPath.row].postuserid ?? ""
        cell.awakeFromNib()
        
        
        return cell
    }

}
extension ShareRoomViewController{
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        print("dismissしました")
        self.getStartDocuments()
    }
}

