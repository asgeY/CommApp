//
//  CircleImage.swift
//  CommApp
//
//  Created by Asgedom Yohannes on 12/4/18.
//  Copyright © 2018 Asgedom Yohannes. All rights reserved.
//

import UIKit

class CircleImage: UIImageView {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = self.frame.width / 2
        
        self.clipsToBounds = true
    }

}
