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
        phoneNumTF.frame = CGRect(x: 0, y: 300, width: 200, height: 40)
        phoneNumTF.placeholder = "请输入手机号"
        phoneNumTF.keyboardType = .numberPad

        passwordTF.frame = CGRect(x: 0, y: 350, width: 200, height: 40)
        passwordTF.placeholder = "请输入密码"
        passwordTF.isSecureTextEntry = true
        
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
        let ud = UserDefaults.standard
        var dataSource = [String: Any]()
//        发送并获取数据
        Alamofire.request("http://localhost:3000/login/cellphone?phone=18570743258&password=xixi1005").responseJSON { (d) in
            do {
                let datas = try JSONDecoder().decode(LoginGet.self, from:
                d.data!)
                
                print("成功登录")
                
//                判断密码是否错误
                if datas.code == 502 || datas.code == 400 {
                    self.passwordTF.text = nil
                    self.phoneNumTF.text = nil
                    self.phoneNumTF.placeholder = "请正确输入"
                    isPass = false
                }
                print("密码正确")
//                储存数据
                dataSource["uid"] = datas.profile.userID
                dataSource["nickname"] = datas.profile.nickname
                dataSource["avatarURL"] = datas.profile.avatarURL
                dataSource["bgURL"] = datas.profile.backgroundURL
                dataSource["followeds"] = datas.profile.followeds
                dataSource["follows"] = datas.profile.follows
                ud.set(datas.profile.userID, forKey: "zrzz")
                ud.set(dataSource, forKey: "dS")
//                可以通过
                isPass = true
                print("进行跳转")
            } catch {
                print("登录失败")
            }
        }
        if isPass == true {
            navigationController?.popToViewController(Homepage(), animated: true)
        }
    }
}
