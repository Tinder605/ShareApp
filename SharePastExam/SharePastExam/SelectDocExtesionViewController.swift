//
//  SelectDocExtesionViewController.swift
//  SharePastExam
//
//  Created by Takashi Sakai on 2021/11/24.
//

import UIKit

class SelectDocExtesionViewController: UIViewController {
    
    @IBOutlet weak var DocExtensionImage: UIImageView!
    @IBOutlet weak var DocExtensionTitle: UILabel!
    @IBOutlet weak var CreateUserImage: UIImageView!
    @IBOutlet weak var CreateUserName: UILabel!
    
    
    var doctitle = ""
    var imageurl = URL(string: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.DocExtensionTitle.text = doctitle
        do{
            let data = try Data(contentsOf: imageurl!)
            self.DocExtensionImage.image = UIImage(data: data)
        }catch{
            self.DocExtensionImage.image = UIImage()
            //self.DocExtensionImage.backgroundColor = .systemGreen
            DocExtensionImage.layer.cornerRadius = 10
            
        }
        
    }
    
    
}
