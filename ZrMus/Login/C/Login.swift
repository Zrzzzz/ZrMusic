//
//  Login.swift
//  ZrMus
//
//  Created by Zr埋 on 2020/1/22.
//  Copyright © 2020 Zr埋. All rights reserved.
//

import UIKit
import Alamofire

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
    
    enum loginType {
        case mail
        case phone
    }

    static func login(from: UIViewController, accountTF: UITextField, passwordTF: UITextField, type: loginType) {
    //        获取参数
        let param1 = accountTF.text!
        let param2 = passwordTF.text!
        
        let alert = UIAlertController(title: "", message: nil, preferredStyle: .alert)
        let knownAction = UIAlertAction(title: "我知道了", style: .default, handler: nil)
        alert.addAction(knownAction)
        
        if param1 == "" || param2 == "" {
            alert.title = "请完整输入"
            from.present(alert, animated: true, completion: nil)
            return
        }

    //        储存数据
        let ud = UserDefaults.standard
    //        发送并获取数据
        var url = "http://localhost:3000"
        if type == .phone {
            url += "/login/cellphone?phone=\(param1)&password=\(param2)"
        } else {
            url += "/login?email=\(param1)&password=\(param2)"
        }
        Alamofire.request(URL(string: url)!).responseJSON { (d) in
            do {
                let datas = try JSONDecoder().decode(LoginGet.self, from: d.data!)
                
                print("成功连接")
                
    //                判断密码是否错误
                if datas.code == 400 {
                    accountTF.text = ""
                    passwordTF.text = ""
                    alert.title = "你瞎jb输啥呢"
                    from.present(alert, animated: true, completion: nil)
                    print("瞎输的")
                    return
                }
                if datas.code == 502 {
                    passwordTF.text = ""
                    alert.title = "密码错误"
                    from.present(alert, animated: true, completion: nil)
                    print("密码错误")
                    return
                }
                print("密码正确")
    //                储存数据
                ud.set(datas.profile?.userId!, forKey: "uid")
    //                可以通过
                print("进行跳转")
                from.navigationController?.popToRootViewController(animated: true)
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
