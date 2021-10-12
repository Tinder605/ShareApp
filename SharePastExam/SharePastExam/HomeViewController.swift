//
//  HomeViewController.swift
//  SharePastExam
//
//  Created by Takashi Sakai on 2021/09/27.
//

import Foundation
import UIKit
import Firebase




class HomeViewController: UIViewController {
    

    @IBOutlet weak var RecentlySubTable: UITableView!
    
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
