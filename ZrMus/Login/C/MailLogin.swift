//
//  MailLogin.swift
//  ZrMus
//
//  Created by Zr埋 on 2020/1/22.
//  Copyright © 2020 Zr埋. All rights reserved.
//

import UIKit

class MailLogin: UIViewController {
    
    let mailTF = ZrTF()
    let passwordTF = ZrTF()
    let checkBtn = ZrBtn()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(mailTF)
        view.addSubview(passwordTF)
        view.addSubview(checkBtn)
        
        drawTFs()
        drawBtns()
        
        
    }
}

extension MailLogin {
    
    func drawTFs() {
        mailTF.placeholder = "请输入邮箱"
        mailTF.snp.updateConstraints { (make) in
            make.width.equalTo(150)
            make.height.equalTo(40)
            make.centerY.equalTo(300)
        }
        passwordTF.placeholder = "请输入密码"
        passwordTF.isSecureTextEntry = true
        passwordTF.snp.updateConstraints { (make) in
            make.width.equalTo(150)
            make.height.equalTo(40)
            make.centerY.equalTo(350)
        }
    }
    
    func drawBtns() {
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

extension MailLogin {
    @objc func check() {
            let param1 = mailTF.text
            let param2 = passwordTF.text
    //        Alamofire.request("http://localhost:3000/login?email=\(param1)&password=\(param2)").responseJSON(completionHandler: a)
        }
}
