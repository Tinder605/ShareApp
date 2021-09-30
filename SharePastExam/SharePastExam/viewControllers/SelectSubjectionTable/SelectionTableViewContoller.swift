//
//  SelectionTableViewContoller.swift
//  SharePastExam
//
//  Created by Takashi Sakai on 2021/09/27.
//

import UIKit

class SelectionTableViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var SelectSubjectionTable: UITableView!
    @IBOutlet weak var SubjectionTableHeight: NSLayoutConstraint!
    @IBOutlet weak var SubjectionTableWidth: NSLayoutConstraint!
    
    @IBOutlet weak var SelectSubjectionTableTop: NSLayoutConstraint!
    
    let cellID = "cellID"
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    override func viewWillLayoutSubviews() {
        SubjectionTableWidth.constant = width
        SubjectionTableHeight.constant = height
        SelectSubjectionTableTop.constant = 0
    
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = .systemGreen
        
        //SelectSubjectionTable.backgroundColor = .red
        SelectSubjectionTable.isScrollEnabled = true
        SelectSubjectionTable.register(SelectTableViewCell.self, forCellReuseIdentifier: cellID)
        SelectSubjectionTable.delegate = self
        SelectSubjectionTable.dataSource = self
    }
    
}
extension SelectionTableViewController{

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 5
        }
        func numberOfSections(in tableView: UITableView) -> Int {
            return 3
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
            cell.textLabel?.text = "\(indexPath.row)"
            
            
        

            return cell
        }
        
        
}


