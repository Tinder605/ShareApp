//
//  SelectSubjectionTableViewCell.swift
//  SharePastExam
//
//  Created by Takashi Sakai on 2021/09/30.
//

import Foundation
import UIKit

class SelectTableViewCell: UITableViewCell {
    
    var department:String = ""
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
