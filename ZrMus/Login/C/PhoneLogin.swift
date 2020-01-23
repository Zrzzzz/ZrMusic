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
    
    let phoneNumTF = TF.nameTF
    let passwordTF = TF.passwordTF
    let checkBtn = Btn.checkBtn

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(phoneNumTF)
        view.addSubview(passwordTF)
        view.addSubview(checkBtn)
        
        phoneNumTF.placeholder = "请输入手机号"
        phoneNumTF.snp.updateConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(300)
        }
        passwordTF.placeholder = "请输入密码"
        passwordTF.snp.updateConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(400)
        }
        
        checkBtn.addTarget(self, action: #selector(check), for: .touchUpInside)
        
        checkBtn.snp.updateConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(450)
        }
        
    }
    @objc func check() {
        let param1 = phoneNumTF.text
        let param2 = passwordTF.text
//        Alamofire.request("/login/cellphone?phone=\(param1)&password=\(param2)").responseJSON(
//            let data =
//        )
    }
}
