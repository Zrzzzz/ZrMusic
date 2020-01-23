//
//  Btn.swift
//  ZrMus
//
//  Created by Zr埋 on 2020/1/24.
//  Copyright © 2020 Zr埋. All rights reserved.
//

import UIKit

class Btn {
    
    static let changeNCBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .red
        btn.frame = CGRect(x: 0, y: 0, width: 50, height: 40)
        
        return btn
    }()
    
    static let checkBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .cyan
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 14.0
        btn.setTitle("登录", for: .normal)
        btn.frame = CGRect(x: 0, y: 0, width: 50, height: 40)
        
        return btn
    }()
}
