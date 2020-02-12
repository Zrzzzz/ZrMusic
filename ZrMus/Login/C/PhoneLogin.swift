//
//  PhoneLogin.swift
//  ZrMus
//
//  Created by Zr埋 on 2020/1/22.
//  Copyright © 2020 Zr埋. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire

class PhoneLogin: UIViewController {
    
    let phoneNumTF = ZrTF()
    let passwordTF = ZrTF()
    let checkBtn = ZrBtn()
    //        弹窗
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(phoneNumTF)
        view.addSubview(passwordTF)
        view.addSubview(checkBtn)
        
        drawUI()
        
        
        
    }
}
//MARK: - UI界面
extension PhoneLogin {
    
    func drawUI() {
        phoneNumTF.frame = CGRect(x: 0, y: 300, width: 200, height: 40)
        phoneNumTF.placeholder = "请输入手机号"
        phoneNumTF.keyboardType = .numberPad

        passwordTF.frame = CGRect(x: 0, y: 350, width: 200, height: 40)
        passwordTF.placeholder = "请输入密码"
        passwordTF.isSecureTextEntry = true
        
        checkBtn.setTitle("登录", for: .normal)
        checkBtn.backgroundColor = .cyan
        checkBtn.addTarget(self, action: #selector(check), for: .touchUpInside)
        
        checkBtn.snp.updateConstraints { (make) in
            make.width.equalTo(50)
            make.height.equalTo(40)
            make.centerY.equalTo(450)
        }
        
        
    }
}
//MARK: - 数据管理
extension PhoneLogin {
    @objc func check() {
        Login.login(from: self, accountTF: phoneNumTF, passwordTF: passwordTF, type: .phone)
    }
}
