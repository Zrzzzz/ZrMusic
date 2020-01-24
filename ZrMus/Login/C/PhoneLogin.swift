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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(phoneNumTF)
        view.addSubview(passwordTF)
        view.addSubview(checkBtn)
        
        drawTFs()
        drawBtns()
        
        
        
    }
}

extension PhoneLogin {
    
    func drawTFs() {
        phoneNumTF.placeholder = "请输入手机号"
        phoneNumTF.keyboardType = .numberPad
        phoneNumTF.snp.updateConstraints { (make) in
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

extension PhoneLogin {
    @objc func check() {
//        跳转布尔
        var isPass = false
        
//        获取参数
        let param1 = phoneNumTF.text
        let param2 = passwordTF.text
        
        if param1 == nil || param2 == nil {
            phoneNumTF.text = nil
            phoneNumTF.placeholder = "请正确输入"
            isPass = false
        }
        
//        储存数据
        let uD = UserDefaults.standard
        
//        发送并获取数据
        Alamofire.request("http://localhost:3000/login/cellphone?phone=18570743258&password=xixi1005").responseJSON { (d) in
            do {
                let datas = try JSONDecoder().decode(LoginGet.self, from:
                d.data!)
                
                print("success")
                
//                判断密码是否错误
                if datas.code == 502 || datas.code == 400 {
                    self.passwordTF.text = nil
                    self.phoneNumTF.text = nil
                    self.phoneNumTF.placeholder = "请正确输入"
                    isPass = false
                }
                
//                储存数据
//                TODO: 这里应该用字典全部存，明天再弄
                uD.set("2233", forKey: "zrzz")
                uD.set(datas.profile.nickname, forKey: "nickname")
                uD.set(datas.profile.avatarURL, forKey: "avatarURL")
                uD.set(datas.profile.backgroundURL, forKey: "bgURL")
            } catch {
                print("error")
            }
        }
        if isPass {
            navigationController?.popViewController(animated: true)
        }
    }
}
