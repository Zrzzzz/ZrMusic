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
    let alert = UIAlertController(title: "", message: nil, preferredStyle: .alert)
    

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
        
        
        let knownAction = UIAlertAction(title: "我知道了", style: .default, handler: nil)
        alert.addAction(knownAction)
    }
}
//MARK: - 数据管理
extension PhoneLogin {
    @objc func check() {
        
//        获取参数
        let param1 = phoneNumTF.text
        let param2 = passwordTF.text
        
        if param1 == "" || param2 == "" {
            alert.title = "请完整输入"
            present(alert, animated: true, completion: nil)
            return
        }
        
//        储存数据
        let ud = UserDefaults.standard
//        发送并获取数据
        Alamofire.request("http://localhost:3000/login/cellphone?phone=\(param1!)&password=\(param2!)").responseJSON { (d) in
            do {
                let datas = try JSONDecoder().decode(LoginGet.self, from: d.data!)
                
                print("成功连接")
                
//                判断密码是否错误
                if datas.code == 400 {
                    self.passwordTF.text = ""
                    self.phoneNumTF.text = ""
                    self.alert.title = "你瞎jb输啥呢"
                    self.present(self.alert, animated: true, completion: nil)
                    print("瞎输的")
                    return
                }
                if datas.code == 502 {
                    self.passwordTF.text = ""
                    self.phoneNumTF.text = ""
                    self.alert.title = "密码错误"
                    self.present(self.alert, animated: true, completion: nil)
                    print("密码错误")
                    return
                }
                print("密码正确")
//                储存数据
                ud.set(datas.profile?.userID, forKey: "uid")
//                可以通过
                print("进行跳转")
                self.navigationController?.popToRootViewController(animated: true)
                let t = UIApplication.shared.keyWindow?.rootViewController
                if (t?.isKind(of:  UITabBarController.self))! {
                    (t as? UITabBarController)?.selectedIndex = 1
                }
            } catch {
                print("登录失败")
            }
        }
    }
}
