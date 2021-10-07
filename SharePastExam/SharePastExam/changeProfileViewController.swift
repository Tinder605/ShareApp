//
//  changeProfileViewController.swift
//  SharePastExam
//
//  Created by 馬場大夢 on 2021/10/07.
//

import UIKit

class changeProfileViewController: UIViewController  {
    
    @IBOutlet weak var renewButton: UIButton!
    @IBAction func tappedRenewButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    
    
    override func viewDidLoad() {
        renewButton.layer.cornerRadius = 10
    }
    
    private func presentToHomeViewController(user: User) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        let profileViewController = storyBoard.instantiateViewController(identifier: "ProfileViewController") as! ProfileViewController
        
        profileViewController.modalPresentationStyle = .fullScreen
        
        self.present(profileViewController, animated: true, completion: nil)
        
    }
    
    
    
}
