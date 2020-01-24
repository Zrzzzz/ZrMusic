//
//  ZrBtn.swift
//  ZrMus
//
//  Created by Zr埋 on 2020/1/24.
//  Copyright © 2020 Zr埋. All rights reserved.
//

import UIKit

class ZrBtn: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        
//        居中
        let wid = frame.width
        let spaceWid = UIScreen.main.bounds.width
        self.frame.origin.x = (spaceWid - wid) / 2
        
//        圆角
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 14.0
    }
}
