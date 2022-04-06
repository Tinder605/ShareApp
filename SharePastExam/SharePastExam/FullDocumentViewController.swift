//
//  FullDocumentViewController.swift
//  SharePastExam
//
//  Created by Takashi Sakai on 2022/04/04.
//

import Foundation
import UIKit

class FullDocumentViewController: UIViewController {
    
    var mainimage = UIImage()
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    @IBOutlet weak var imageheight: NSLayoutConstraint!
    
    @IBOutlet weak var FullImage: UIImageView!
    @IBOutlet weak var imagewidth: NSLayoutConstraint!
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageheight.constant = height
        imagewidth.constant = width
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.FullImage.image = self.mainimage
    }
}
