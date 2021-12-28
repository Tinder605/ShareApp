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
        let substract = tabBarController?.tabBar.frame.height as! CGFloat
        SubjectionTableHeight.constant = height - substract - 5
        SelectSubjectionTableTop.constant = 0
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = .systemGreen
        UITabBar.appearance().backgroundImage = UIImage()
        tabBarController?.tabBar.barTintColor = .systemGreen
        
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
    }
    


    
}

//section cellの設定
extension SelectionTableViewController{

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            var eachsub:[String] = []
            //var subcount :Int = 0
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
        
        //ヘッダーの高さ
        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 50
        }
        //sectionごとのfooter
        func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
            return .leastNonzeroMagnitude
        }
    
        
        //ヘッダーの内容について
       func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let label = UILabel()
            label.text = "一年次"
            label.backgroundColor = .gray
            label.textAlignment = .center
            
            label.textColor = .white
        
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
            

            return cell
        }
    
    ///選択したセルのindexの調整
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         print(allsub)
        print(allsub.count)
        print(indexPath.section)
        
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
        
        var defaults :[String] = UserDefaults.standard.array(forKey: "RecentlySub") as! [String]
        defaults.insert(usersub, at: 0)
        
        if defaults.count > 15 {
            defaults.removeLast()
        }
        let orderset = NSOrderedSet(array: defaults)
        let uniqueValues = orderset.array as! [String]
        UserDefaults.standard.set(uniqueValues, forKey: "RecentlySub")
        
        print(UserDefaults.standard.array(forKey: "RecentlySub"))
        
        self.navigationController?.pushViewController(nextview, animated: true)
        
    }
    
        
        
}

