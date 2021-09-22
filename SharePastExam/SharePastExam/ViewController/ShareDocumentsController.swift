//
//  ShareDocumentsController.swift
//  SharePastExam
//
//  Created by Takashi Sakai on 2021/09/22.
//

import UIKit

class ShareDocumentsController: UIViewController {
    var timestitile:String = ""{
        didSet{
            navigationItem.title = timestitile
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue
    }
}
