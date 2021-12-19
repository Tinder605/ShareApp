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
    
    init(document:QueryDocumentSnapshot) {
        let doc = document.data()
        self.count = doc["count"] as? String
        self.ViewCount = doc["viewcount"] as? Int
        print("ここに\(self.ViewCount)")
        self.GoodCount = doc["good"] as? Int
        self.Title = doc["title"] as? String
        self.url = doc["imageurl"] as? String
        self.goodList = doc["GoodList"] as? [String]
    }
    
}



class ShareRoomViewController: UIViewController, UICollectionViewDataSource ,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{

    @IBOutlet weak var PostButton: UIButton!
    @IBOutlet weak var ShareRoomCollectionView: UICollectionView!
    @IBOutlet weak var ShareRoomViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var ShareRoomCollectionViewWidth: NSLayoutConstraint!
    
    @IBAction func PostButtonAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "CreatePastExam", bundle: nil)
        let nextwindow = storyboard.instantiateViewController(withIdentifier: "CreatePastExam") as! CreateExamViewController
        self.present(nextwindow, animated: true, completion: nil)
    }
    
    var timestile :String = ""
    var count:String!
    var itemcount = 0 //cellの初期状態の個数
    
    var testDataArray:[PastData] = [] //データベースの情報一覧
    
    var imagearray :[UIImage] = []
    let width = UIScreen.main.bounds.width
    let height  = UIScreen.main.bounds.height
    
    let sub = UserDefaults.standard.array(forKey: "RecentlySub") as! [String]
    let uid = Auth.auth().currentUser?.uid//念の為再定義(userdefaultにあれば削除）
    
    override func viewDidLayoutSubviews() {
        ShareRoomCollectionViewWidth.constant = width
        ShareRoomViewHeight.constant = height
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.backgroundColor = .systemGreen
        ShareRoomCollectionView.backgroundColor = UIColor.rgb(red: 144, green: 238, blue: 144)
        PostButton.layer.cornerRadius = 40
        PostButton.setTitle("", for: .normal)
        navigationItem.title = timestile
        UserDefaults.standard.set(timestile, forKey: "RecentlyTimes")
        
        self.getStartDocuments()
        
        let nib = UINib(nibName: "ShareRoomCollectionViewCell", bundle: nil)
        self.ShareRoomCollectionView.register(nib, forCellWithReuseIdentifier: "CellView")
        ShareRoomCollectionView.dataSource = self
        ShareRoomCollectionView.delegate = self
        ShareRoomCollectionView.isScrollEnabled = true
        
        
    }
    //imageの情報の取得
    private func getStartDocuments(){
        let sub = UserDefaults.standard.array(forKey: "RecentlySub") as! [String]
        let times = UserDefaults.standard.string(forKey: "RecentlyTimes") as! String
        
        let ref = Firestore.firestore().collection("images").document(sub[0])
        let imginforef = ref.collection("times").document(times).collection("count")
        HUD.show(.progress, onView: self.view)

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
            }
            HUD.hide{ (_) in
                HUD.flash(.success, onView: self.view)
                self.ShareRoomCollectionView.reloadData()
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
        let wid = (width-30)/3
        return .init(width: wid, height: wid)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let window = UIStoryboard(name: "SelectDocExtesion", bundle: nil)
        let nextscreen = window.instantiateViewController(withIdentifier: "SelectDocExtesion") as! SelectDocExtesionViewController
        if let nexttitle = testDataArray[indexPath.row].Title{
            nextscreen.doctitle = testDataArray[indexPath.row].Title!
            print(nexttitle)
        }
        if let nextimage = testDataArray[indexPath.row].url{
            nextscreen.imageurl = URL(string: nextimage)
        }
        self.present(nextscreen, animated: true, completion: nil)
        
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellView", for: indexPath) as! ShareRoomCollectionCellView
        //cell.fittoview(width: (width-30)/3, height: (width-30)/3)
        cell.number = indexPath.row
        //viewcountの取得
        if let viewcount = testDataArray[indexPath.row].ViewCount{
            cell.ViewCount.text = "\(viewcount)"
        }else{
            cell.ViewCount.text = "unknown"
        }
        
        //タイトルの取得
        if let doctitle = testDataArray[indexPath.row].Title{
            cell.PostTitle.text  = "\(doctitle)"
        }else{
            cell.PostTitle.text = "No Title"
        }
        
        let docgood = testDataArray[indexPath.row].goodList ?? [""]
        
        let yourgood = docgood.filter({$0 == String(uid!)})
        print("aiu",yourgood)
        if !(yourgood.isEmpty){
            cell.Goodvalue = 1
            let image = UIImage(systemName: "heart.fill")
            cell.ReviewButton.setImage(image, for: .normal)
        }
        
        //viewのimageの取得
        if let urlstr = testDataArray[indexPath.row].url{
            let url = URL(string: "\(urlstr)")
//           url探索ではレート時間が大きい
            print(url)
            do{
                let data = try Data(contentsOf: url!)
                cell.PostImages.image = UIImage(data: data)
            }catch{
                print("Err: ")
                cell.PostImages.image = UIImage()

            }
        }
        
        
        return cell
    }

}

