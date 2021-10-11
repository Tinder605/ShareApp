//
//  SubTimesViewController.swift
//  SharePastExam
//
//  Created by Takashi Sakai on 2021/10/08.
//

import Foundation
import UIKit

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
        SubTimesTableWidth.constant = width
        let substract = tabBarController?.tabBar.frame.height as! CGFloat
        SubTimesTableHeight.constant = height - substract - 5
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SubTimesTableView.backgroundColor = .white
        print(tabBarController?.tabBar.frame.height)
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
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectsubtimes = subtimes[indexPath.row] as! String
        print(selectsubtimes)
        
        let storyboard = UIStoryboard(name: "ShareRoom", bundle: nil)
        let nextview = storyboard.instantiateViewController(withIdentifier: "ShareRoom") as! ShareRoomViewController
        nextview.timestile = subtimes[indexPath.row] as! String
        navigationController?.pushViewController(nextview, animated: true)
    }

}
