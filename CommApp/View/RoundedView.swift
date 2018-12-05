//
//  RoundedView.swift
//  CommApp
//
//  Created by Asgedom Yohannes on 12/4/18.
//  Copyright © 2018 Asgedom Yohannes. All rights reserved.
//

import UIKit

class RoundedView: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 20
        
        self.clipsToBounds = true
        
        layer.borderColor = UIColor.lightGray.cgColor
        
        layer.borderWidth = 0.5
    }
}
