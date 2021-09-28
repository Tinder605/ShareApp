//
//  HomeViewController.swift
//  LoginWithFirebaseApp
//
//  Created by 馬場大夢 on 2021/09/09.
//  Copyright © 2021 馬場大夢. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class HomeViewController: UIViewController {
    
    var user: User? {
        didSet {
            print("user?.name: ",user?.name)
        }
    }
    
    
    private func handleLogout() {
        do {
            try Auth.auth().signOut()
            presentToMainViewController()
        }catch (let err) {
            print("ログアウトに失敗しました。\(err)")
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        confirmLoggedInUser()
    }
    
    private func confirmLoggedInUser() {
        if Auth.auth().currentUser?.uid == nil || user == nil {
            presentToMainViewController()
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

