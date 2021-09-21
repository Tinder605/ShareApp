//
//  SubTimesViewController.swift
//  SharePastExam
//
//  Created by Takashi Sakai on 2021/09/21.
//

import UIKit

class SubTimesViewController: UIViewController {
    
    var subtitle:String? {
        didSet{
            navigationItem.title = subtitle!
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ooo\(subtitle)")
        navigationItem.title = subtitle
        
    }
}
