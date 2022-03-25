//
//  SelectionTableViewContoller.swift
//  SharePastExam
//
//  Created by Takashi Sakai on 2021/09/27.
//

import UIKit
import Firebase


class SelectionTableViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var SelectSubjectionTable: UITableView!
    @IBOutlet weak var SubjectionTableHeight: NSLayoutConstraint!
    @IBOutlet weak var SubjectionTableWidth: NSLayoutConstraint!
    
    @IBOutlet weak var SelectSubjectionTableTop: NSLayoutConstraint!
    
    let cellID = "cellID"
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    let subjection = UserDefaults.standard.dictionary(forKey: "sub") as! [String:[String]]///強化を入れるための変数
    let department = UserDefaults.standard.string(forKey: "dep") as! String
    var allsub :[String] = []
    
    override func viewWillLayoutSubviews() {
        
        SubjectionTableWidth.constant = width
        //タブバー縦の幅
        let tabstract = tabBarController?.tabBar.frame.height as! CGFloat
        //ナビバー縦の幅
        let nabstract = navigationController?.navigationBar.frame.height as! CGFloat
        SubjectionTableHeight.constant = height - tabstract - nabstract - 50
        
        let substract = tabBarController?.tabBar.frame.height as! CGFloat
        SubjectionTableHeight.constant = height - substract - 5
        SelectSubjectionTableTop.constant = 0
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //下の背景の色
        tabBarController?.tabBar.barTintColor = UIColor.rgb(red: 166, green: 252, blue: 132)
        //上の文字の色
        UINavigationBar.appearance().tintColor = UIColor.brown
        //tabBarController?.tabBar.barTintColor = UIColor.white
        self.navigationController!.navigationBar.titleTextAttributes = [
                    .foregroundColor: UIColor.brown
                ]
        UITabBar.appearance().backgroundImage = UIImage()
        
        if #available(iOS 15, *) {
            UITableView.appearance().sectionHeaderTopPadding = 0
        }
        
        
        //SelectSubjectionTable.backgroundColor = .red
        print(subjection["一年生"] as! [String])
        let eachsub = subjection["一年生"] as! [String]
        print(subjection.keys)
        print(department)
        
        SelectSubjectionTable.isScrollEnabled = true
        SelectSubjectionTable.register(SelectTableViewCell.self, forCellReuseIdentifier: cellID)
        
        ///delegateの登録
        SelectSubjectionTable.delegate = self
        SelectSubjectionTable.dataSource = self
        
        print(SelectSubjectionTable.tableHeaderView?.heightAnchor)
    }
    


    
}

//section cellの設定
extension SelectionTableViewController{

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            var eachsub:[String] = []
            //var subcount :Int = 0
            tableView.separatorColor = UIColor.rgb(red: 140, green: 97, blue: 32) //線を茶色にする
            tableView.separatorInset.left = 0
            tableView.separatorInset.right = 0
            switch section {
            case 0:
                eachsub = subjection["一年生"] as! [String]
            case 1:
                eachsub = subjection["二年生"] as! [String]
            case 2:
                eachsub = subjection["三年生"] as! [String]
            default:
                eachsub = []
            }
            //print(eachsub.count)
            return eachsub.count
        }
    
        func numberOfSections(in tableView: UITableView) -> Int {
            //print(subjection.count)
            return subjection.count
        }
        //cellの高さ
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 50
        }
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
        
        //ヘッダーの高さ
        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 50
        }
       
        //sectionごとのfooter
        func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
            //return .leastNonzeroMagnitude
            return CGFloat.leastNormalMagnitude
        }
       
    
        
        //ヘッダーの内容について
       func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let label = UILabel()
            label.text = "一年次"
            label.backgroundColor = UIColor.rgb(red: 186, green: 249, blue: 146)
           
            label.textAlignment = .center
            
            label.textColor = UIColor.rgb(red: 140, green: 97, blue: 32)
        
        switch section {
        case 0:
            label.text = "学部1年生"
        case 1:
            label.text = "学部2年生"
        case 2:
            label.text = "学部3年生"
        case 3:
            label.text = "学部4年生"
        default:
            label.text = "その他"
        }
            return label
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath) as! SelectTableViewCell
            
        
            
            switch indexPath.section {
                
            case 0:
                allsub = subjection["一年生"] as! [String]
                //print(indexPath.row)
                cell.textLabel?.text = allsub[indexPath.row]
            case 1:
                allsub = subjection["二年生"] as! [String]
                cell.textLabel?.text = allsub[indexPath.row]
            case 2:
                allsub = subjection["三年生"] as! [String]
                cell.textLabel?.text = allsub[indexPath.row]
                
            default:
                cell.textLabel?.text = ""
            }
            cell.contentView.backgroundColor = UIColor.rgb(red: 241, green: 251, blue: 231)//セルのバックグラウンド変更

            return cell
        }
    
    ///選択したセルのindexの調整
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         print(allsub)
        print(allsub.count)
        print(indexPath.section)
        
        //セルの選択を解除
        tableView.deselectRow(at: indexPath, animated: true)
        
        var usersub :String = ""
        switch indexPath.section {
        case 0:
            allsub =  subjection["一年生"] as! [String]
            usersub = allsub[indexPath.row]
        case 1:
            allsub = subjection["二年生"] as! [String]
            usersub = allsub[indexPath.row]
        case 2:
            allsub = subjection["三年生"] as! [String]
            usersub = allsub[indexPath.row]
        default:
            allsub = []
            usersub = ""
        }
        let storyboard = UIStoryboard(name: "Subtimes", bundle: nil)
        let nextview = storyboard.instantiateViewController(withIdentifier: "Subtimes") as! SubTimesViewController
        nextview.subTitle = usersub
        
        var defaults :[String] = UserDefaults.standard.array(forKey: "RecentlySub") as? [String] ?? []
            
        defaults.insert(usersub, at: 0)
        
        if defaults.count > 15 {
            defaults.removeLast()
        }
        let orderset = NSOrderedSet(array: defaults)
        let uniqueValues = orderset.array as! [String]
        UserDefaults.standard.set(uniqueValues, forKey: "RecentlySub")
        
        
        self.navigationController?.pushViewController(nextview, animated: true)
        
    }
    
        
        
}

