//
//  SubTimesViewController.swift
//  SharePastExam
//
//  Created by Takashi Sakai on 2021/10/08.
//

import Foundation
import UIKit
import Firebase

class SubTimesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    
    @IBOutlet weak var SubTimesTableView: UITableView!
    @IBOutlet weak var SubTimesTableHeight: NSLayoutConstraint!
    @IBOutlet weak var SubTimesTableWidth: NSLayoutConstraint!
    
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    let cellID = "cellID"
    
    let subtimes = ["第一回講義","第二回講義","第三回講義","第四回講義","第五回講義","第六回講義","第七回講義","第八回講義","第九回講義","第十回講義","第十一回講義","第十二回講義","第十三回講義","第十四回講義","第十五回講義","中間テスト","期末テスト","レポート"]
    
    
    var subTitle:String = ""
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        UITabBar.appearance().backgroundImage = UIImage()
        tabBarController?.tabBar.barTintColor = UIColor.rgb(red: 166, green: 252, blue: 132)
        guard let tabBarController = tabBarController else { return }
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.backgroundColor = UIColor.rgb(red: 166, green: 252, blue: 132)
        tabBarController.tabBar.standardAppearance = tabBarAppearance

        if #available(iOS 15.0, *) { // 新たに追加
            tabBarController.tabBar.scrollEdgeAppearance = tabBarAppearance
        }
        SubTimesTableWidth.constant = width
        //let substract = tabBarController.tabBar.frame.height as! CGFloat
        //SubTimesTableHeight.constant = height - substract - 5
        
        //タブバー縦の幅
        let tabstract = tabBarController.tabBar.frame.height
        //ナビバー縦の幅
        let nabstract = navigationController?.navigationBar.frame.height
        SubTimesTableHeight.constant = height - (tabstract ) - (nabstract ?? 0) - 50
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SubTimesTableView.backgroundColor = .white
        navigationItem.title = subTitle
        //print(tabBarController?.tabBar.frame.height)
        SubTimesTableView.register(SubTImesViewCell.self, forCellReuseIdentifier: cellID)
        SubTimesTableView.isScrollEnabled = true
        SubTimesTableView.dataSource = self
        SubTimesTableView.delegate = self
        
        
    }
    
    
}

//セルの設定
extension SubTimesViewController{
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subtimes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
        cell.textLabel?.text = subtimes[indexPath.row]
        
        tableView.separatorColor = UIColor.rgb(red: 140, green: 97, blue: 32) //線を茶色にする
        tableView.separatorInset.left = 0
        tableView.separatorInset.right = 0
        tableView.tableFooterView = UIView()//空のセルの区切りをなくす
        cell.contentView.backgroundColor = UIColor.rgb(red: 241, green: 251, blue: 231)//セルのバックグラウンド変更
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let reference = Firestore.firestore().
        let selectsubtimes = subtimes[indexPath.row]
        print(selectsubtimes)
        
        //セルの選択を解除
        tableView.deselectRow(at: indexPath, animated: true)
        
        let storyboard = UIStoryboard(name: "ShareRoom", bundle: nil)
        let nextview = storyboard.instantiateViewController(withIdentifier: "ShareRoom") as! ShareRoomViewController
        nextview.timestile = subtimes[indexPath.row]
        
        tableView.separatorColor = UIColor.rgb(red: 140, green: 97, blue: 32) //線を茶色にする
        tableView.separatorInset.left = 0
        tableView.separatorInset.right = 0
        tableView.tableFooterView = UIView()//空のセルの区切りをなくす
            //cell.contentView.backgroundColor = UIColor.rgb(red: 241, green: 251, blue: 231)//セルのバックグラウンド変更
        
        UserDefaults.standard.set(subtimes[indexPath.row] , forKey: "RecentlyTimes")
        navigationController?.pushViewController(nextview, animated: true)
    }

}
