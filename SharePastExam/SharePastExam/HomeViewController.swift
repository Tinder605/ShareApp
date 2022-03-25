//
//  HomeViewController.swift
//  SharePastExam
//
//  Created by Takashi Sakai on 2021/09/27.
//

import Foundation
import UIKit
import Firebase

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var histryCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var SlideWidth: NSLayoutConstraint!
    
    @IBOutlet weak var RecentlyTable: UITableView!
    @IBOutlet weak var RecentlyTableHeight: NSLayoutConstraint!
    @IBOutlet weak var RecentlyTableWidth: NSLayoutConstraint!
    
    private var images = UIImage(named: "IMG_6906")
    
    let cellID = "cellID"
    let height = UIScreen.main.bounds.height
    let width = UIScreen.main.bounds.width
    var RecentlySub = UserDefaults.standard.array(forKey: "RecentlySub") ?? ["現在閲覧履歴はありません"]
    let SliderCellId = "SliderCellId"
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        RecentlySub = UserDefaults.standard.array(forKey: "RecentlySub") ?? ["現在閲覧履歴はありません"]
        print(RecentlySub)
        self.RecentlyTable.reloadData()
        self.histryCollectionView.reloadData()
        
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        RecentlyTableWidth.constant = width
        //RecentlyTableHeight.constant = 15*30
        //タブバー縦の幅
        let tabstract = tabBarController?.tabBar.frame.height as! CGFloat
        //ナビバー縦の幅
        let nabstract = navigationController?.navigationBar.frame.height as! CGFloat
        RecentlyTableHeight.constant = height - tabstract - nabstract - 286
        

        
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("viewdidload")
        histryCollectionView.backgroundColor = .red
        //self.navigationController!.navigationBar.titleTextAttributes = [
                    //.foregroundColor: UIColor.white
               // ]
        //下のバー
        //tabBarController?.tabBar.barTintColor = UIColor.rgb(red: 166, green: 252, blue: 132)
        guard let tabBarController = tabBarController else { return }
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.backgroundColor = UIColor.rgb(red: 166, green: 252, blue: 132)
        tabBarController.tabBar.standardAppearance = tabBarAppearance

        if #available(iOS 15.0, *) { // 新たに追加
            tabBarController.tabBar.scrollEdgeAppearance = tabBarAppearance
        }
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: width, height: 200)
        histryCollectionView.collectionViewLayout = layout
        self.setupViews()
        
        
        RecentlyTable.delegate = self
        RecentlyTable.dataSource = self
        RecentlyTable.register(RecentlyTableViewCell.self, forCellReuseIdentifier: "cellID")
        RecentlyTable.isScrollEnabled = true

    }
    private func setupViews(){
        print("cell設定変更")
        histryCollectionView.delegate = self
        histryCollectionView.dataSource = self
        histryCollectionView.register(SliderCell.self, forCellWithReuseIdentifier: SliderCellId)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        confirmLoggedInUser()
        
    }
    
    private func confirmLoggedInUser() {
        if Auth.auth().currentUser?.uid == nil  {
            presentToMainViewController()
            print(Auth.auth().currentUser?.uid)
        }
    }
    
    
    private func presentToMainViewController() {
        let storyBoard = UIStoryboard(name: "SignUp", bundle: nil)
        let SignUp = storyBoard.instantiateViewController(identifier: "SignUp") as! SignUp
        
        let navController = UINavigationController(rootViewController: SignUp)
        
        navController.modalPresentationStyle = .fullScreen
        
        self.present(navController, animated: true, completion: nil)
    }
    
   
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) ->CGSize {
        let width = self.view.frame.width
        
            return.init(width: width, height: 200)
        }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let getpath = UserDefaults.standard.array(forKey: "RecentlyPath") ?? []
        print("cellの更新は行われています。")
        let cell = histryCollectionView.dequeueReusableCell(withReuseIdentifier:SliderCellId, for: indexPath) as! SliderCell
        cell.number = indexPath.row
        cell.WakeupCell()
        return cell
        }
}


extension HomeViewController{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RecentlySub.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
        cell.textLabel?.text  = RecentlySub[indexPath.row] as! String
        
        tableView.separatorColor = UIColor.rgb(red: 140, green: 97, blue: 32) //線を茶色にする
        tableView.separatorInset.left = 0
        tableView.separatorInset.right = 0
        tableView.tableFooterView = UIView()//空のセルの区切りをなくす
        cell.contentView.backgroundColor = UIColor.rgb(red: 241, green: 251, blue: 231)//セルのバックグラウンド変更
        //cell.textColor = UIColor.rgb(red: 140, green: 97, blue: 32)

        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Subtimes", bundle: nil)
        let jumpview = storyboard.instantiateViewController(withIdentifier: "Subtimes") as! SubTimesViewController
        
        jumpview.subTitle = RecentlySub[indexPath.row] as! String
        navigationController?.pushViewController(jumpview, animated: true)
    }
    
}


