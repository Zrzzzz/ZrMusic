//
//  MailLogin.swift
//  ZrMus
//
//  Created by Zr埋 on 2020/1/22.
//  Copyright © 2020 Zr埋. All rights reserved.
//

import UIKit

class MailLogin: UIViewController {
    
    let mailTF = TF.nameTF
    let passwordTF = TF.passwordTF
    let checkBtn = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(mailTF)
        view.addSubview(passwordTF)
        view.addSubview(checkBtn)
        
        mailTF.placeholder = "请输入邮箱"
        mailTF.snp.updateConstraints { (make) in
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
        let param1 = mailTF.text
        let param2 = passwordTF.text
//        Alamofire.request("/login?email=\(param1)&password=\(param2)").responseJSON(completionHandler: a)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
