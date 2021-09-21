
//
//  SelectionSubjectCell.swift
//  PracticeTableFirebase
//
//  Created by Takashi Sakai on 2021/09/21.
//

import Foundation
import UIKit

class SelectionSubjectCell: UITableViewCell {
    
    
    let checkbutton: UIButton = {
    
        let button = UIButton()
        button.layer.cornerRadius = 10
        button.backgroundColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = true
        return button
        
        
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(checkbutton)
        
        [
            checkbutton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10),
            checkbutton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            checkbutton.heightAnchor.constraint(equalToConstant: 50),
            checkbutton.widthAnchor.constraint(equalToConstant: 50)
            
        ].forEach{$0.isActive = true}
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//ボタンを押した時の処理をどうするか？
extension SelectionSubjectCell{
    
}

