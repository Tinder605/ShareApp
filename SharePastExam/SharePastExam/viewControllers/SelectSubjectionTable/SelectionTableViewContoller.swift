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
    
    var department :String  = ""
    var departments:[[String]] = []/////強化を入れるための変数

    
    override func viewWillLayoutSubviews() {
        SubjectionTableWidth.constant = width
        SubjectionTableHeight.constant = height
        SelectSubjectionTableTop.constant = 0
    
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = .systemGreen
        
        //SelectSubjectionTable.backgroundColor = .red
        self.getDepartment()
        SelectSubjectionTable.isScrollEnabled = true
        SelectSubjectionTable.register(SelectTableViewCell.self, forCellReuseIdentifier: cellID)
        
        ///delegateの登録
        SelectSubjectionTable.delegate = self
        SelectSubjectionTable.dataSource = self
    }
    
    private func getDepartment(){
        let uid = Auth.auth().currentUser!.uid
        
        let docRef = Firestore.firestore().collection("users").document(uid)
        docRef.getDocument { (snapshot, error) in
            if let err = error {
                return
            } else {
                guard let data = snapshot?.data() else {return}
                self.department = data["department"] as! String
                print(self.department.description)
                ///分類のメソッド(引数：self.department)///
                self.GetSubjection(specilization:self.department.description)
            }
        }
    }
    
    private func GetSubjection(specilization:String) ->Array<[String]>{
        
    let department = specilization
        var list:[[String]] = []
    
        switch department {
        case "エネルギー循環化学科":
            let list = Subjecsion()
            list.list_ene
        case "機械システム工学科":
            let list = Subjecsion()
            list.list_kikai
        case "情報システム工学科":
            let list = Subjecsion()
            list.list_jouhou
        case "建築デザイン学科":
            let list = Subjecsion()
            list.list_kennchiku
            
        case "環境生命工学科":
            let list = Subjecsion()
            list.list_seimei
        case "英米学科":
            let list = Subjecsion()
            list.list_eibei
        case "中国学科":
            let list = Subjecsion()
            list.list_cyugoku
        case "国際関係学科":
            let list = Subjecsion()
            list.list_kokkan
        case "経済学科":
            let list = Subjecsion()
            list.list_keizai
        case "経営情報学科":
            let list = Subjecsion()
            list.list_eijou
        case "比較文化学科":
            let list = Subjecsion()
            list.list_hibun
        case "人間関係学科":
            let list = Subjecsion()
            list.list_jinkan
        case "法律学科":
            let list = Subjecsion()
            list.list_houritu
        case "政策科学科":
            let list = Subjecsion()
            list.list_seisaku
        default:
            let list = Subjecsion()
            list.list_chiikisousei
    }
        print(list.count)
        departments = list
        print(departments)
    
    return list
  }
    
}

extension SelectionTableViewController{

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return departments.count
        }
        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 50
        }
        
        //ヘッダーの高さ
        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 50
        }
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
            print(departments[1])
            cell.textLabel?.text = "\(departments[indexPath.row])"
            
            
        

            return cell
        }
        
        
}

