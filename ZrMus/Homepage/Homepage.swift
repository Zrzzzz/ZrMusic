//
//  Homepage.swift
//  ZrMus
//
//  Created by Zr埋 on 2020/1/21.
//  Copyright © 2020 Zr埋. All rights reserved.
//

import UIKit

class Homepage: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //判断登录状态
        isRegistered()
        
        navigationController?.title = "发现"
        view.backgroundColor = .white
        
        
        
        
    }
}

extension Homepage {
    func isRegistered() {
        let userid = UserDefaults.standard.string(forKey: "zrzz")
        if userid == nil {
            navigationController?.pushViewController(Login(), animated: true)
        }
    }
}
