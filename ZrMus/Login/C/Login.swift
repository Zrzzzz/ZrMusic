//
//  Login.swift
//  ZrMus
//
//  Created by Zr埋 on 2020/1/22.
//  Copyright © 2020 Zr埋. All rights reserved.
//

import UIKit

class Login: UIViewController {
    let phoneLoginBtn = ZrBtn()
    let mailLoginBtn = ZrBtn()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(phoneLoginBtn)
        view.addSubview(mailLoginBtn)
        
        drawBtns()
        
        

    }
}
extension Login {
    
//    定制Btn
    func drawBtns() {
        phoneLoginBtn.backgroundColor = .red
        phoneLoginBtn.setTitle("手机号登录", for: .normal)
        phoneLoginBtn.addTarget(self, action: #selector(changeController), for: .touchUpInside)
        phoneLoginBtn.snp.updateConstraints { (make) in
            make.width.equalTo(150)
            make.height.equalTo(40)
            make.centerY.equalTo(300)
        }
        
        mailLoginBtn.backgroundColor = .red
        mailLoginBtn.setTitle("邮箱登录", for: .normal)
        mailLoginBtn.addTarget(self, action: #selector(changeController), for: .touchUpInside)
        mailLoginBtn.snp.updateConstraints { (make) in
            make.width.equalTo(150)
            make.height.equalTo(40)
            make.centerY.equalTo(400)
        }
    }
    
    
}
extension Login {
    @objc func changeController(btn: UIButton) {
           switch btn {
           case phoneLoginBtn:
               navigationController?.pushViewController(PhoneLogin(), animated: true)
           case mailLoginBtn:
               navigationController?.pushViewController(MailLogin(), animated: true)
           default:
               print("error")
           }
       }
}
