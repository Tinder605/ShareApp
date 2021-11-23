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
    var url :URL?
    
    init(document:QueryDocumentSnapshot) {
        let doc = document.data()
        self.count = doc["count"] as? String
        self.ViewCount = doc["viewcount"] as? Int
        print("ここに\(self.ViewCount)")
        self.GoodCount = doc["good"] as? Int
        self.Title = doc["subtimes"] as? String
        self.url = doc["url"] as? URL
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
    
    let width = UIScreen.main.bounds.width
    let height  = UIScreen.main.bounds.height
    //並列できない
    let dispatchGroup = DispatchGroup()
            // 並列で実行できるよ〜
    let dispatchQueue = DispatchQueue(label: "queue", attributes: .concurrent)
    
    
    
    override func viewDidLayoutSubviews() {
        ShareRoomCollectionViewWidth.constant = width
        ShareRoomViewHeight.constant = height
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.backgroundColor = .systemBlue
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
    
    private func getStartDocuments(){
        let sub = UserDefaults.standard.array(forKey: "RecentlySub") as! [String]
        let times = UserDefaults.standard.string(forKey: "RecentlyTimes") as! String
        
        let ref = Firestore.firestore().collection("images").document(sub[0])
        let imginforef = ref.collection("times").document(times).collection("count")
        
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
//                for document in querySnapshots!.documents{
//                    print("\(document.documentID) =>\(document.data())")
//                    print(type(of: document.documentID))
//
//                    let nowuid = Int(document.documentID)
//                    if imgminuid>nowuid!{
//                        imgminuid = nowuid!
//                    }
//                }
//                print(imgminuid)
//
            }
            self.ShareRoomCollectionView.reloadData()
        }
    }


}

extension ShareRoomViewController {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("データベースの要素数は、\(self.testDataArray.count)")
        return self.testDataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.view.frame.width
        let wid = (width-30)/3
        return .init(width: wid, height: wid)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let window = UIStoryboard(name: "", bundle: nil)
        
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellView", for: indexPath) as! ShareRoomCollectionCellView
        //cell.fittoview(width: (width-30)/3, height: (width-30)/3)
        if let viewcount = testDataArray[indexPath.row].ViewCount{
            cell.ViewCount.text = "\(viewcount)"
        }else{
            cell.ViewCount.text = "unknown"
        }
        cell.PostTitle.text = "\(indexPath)"
        
        return cell
    }

}

