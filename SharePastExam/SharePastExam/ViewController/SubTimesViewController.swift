//
//  SubTimesViewController.swift
//  SharePastExam
//
//  Created by Takashi Sakai on 2021/09/21.
//

import UIKit

class SubTimesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    

    
    @IBOutlet weak var SubTimesTable: UITableView!
    @IBOutlet weak var SubTimesTableHeight: NSLayoutConstraint!
    @IBOutlet weak var SubTImesTableWidth: NSLayoutConstraint!
    
    let subtimes = ["第1回講義","第2回講義","第3回講義","第4回講義","第5回講義","第6回講義","第7回講義","第8回講義","第9回講義","第10回講義","第11回講義","第12回講義","第13回講義","第14回講義","第15回講義","レポート","過去問テスト","小テスト"]
    
    let width = UIScreen.main.bounds.size.width
    let height = UIScreen.main.bounds.size.height
    
    var subtitle:String? {
        didSet{
            navigationItem.title = subtitle
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SubTimesTableHeight.constant = height
        SubTImesTableWidth.constant = width
        SubTimesTable.backgroundColor = .systemGreen
        print("ooo\(subtitle)")
        
        
        SubTimesTable.delegate = self
        SubTimesTable.dataSource = self
    }
}

extension SubTimesViewController{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        subtimes.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellview", for: indexPath)
        cell.textLabel?.text = subtimes[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard:UIStoryboard = UIStoryboard(name: "ShareDocuments", bundle: nil)
        let nextView = storyboard.instantiateViewController(identifier: "thirdMain") as! ShareDocumentsController
        nextView.timestitile = subtimes[indexPath.row]
        self.navigationController?.pushViewController(nextView, animated: true)
    }
}
