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

    
    

    @IBOutlet weak var RecentlyTable: UITableView!
    @IBOutlet weak var RecentlyTableHeight: NSLayoutConstraint!
    @IBOutlet weak var RecentlyTableWidth: NSLayoutConstraint!
    
    
    let cellID = "cellID"
    let width = UIScreen.main.bounds.width
    var RecentlySub = UserDefaults.standard.array(forKey: "RecentlySub") as! [String]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        RecentlySub = UserDefaults.standard.array(forKey: "RecentlySub") as! [String]
        print(RecentlySub)
        RecentlyTable.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        RecentlyTableWidth.constant = width
        RecentlyTableHeight.constant = 15*30
        
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        RecentlyTable.delegate = self
        RecentlyTable.dataSource = self
        RecentlyTable.register(RecentlyTableViewCell.self, forCellReuseIdentifier: "cellID")
        RecentlyTable.backgroundColor = .systemGreen
        RecentlyTable.isScrollEnabled = true


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

extension HomeViewController{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RecentlySub.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
        cell.textLabel?.text  = RecentlySub[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Subtimes", bundle: nil)
        let jumpview = storyboard.instantiateViewController(withIdentifier: "Subtimes") as! SubTimesViewController
        
        jumpview.subTitle = RecentlySub[indexPath.row] as! String
        navigationController?.pushViewController(jumpview, animated: true)
    }
    
}
