//
//  InfoChange.swift
//  ZrMus
//
//  Created by Zr埋 on 2020/2/3.
//  Copyright © 2020 Zr埋. All rights reserved.
//

import UIKit
import Alamofire

class InfoChange: UIViewController {
    
    var user: User!
    
    var checkBtn: UIButton!
    var nameTF: ZrTF!
    var birthTF: ZrTF!
    var genderTF: ZrTF!
    var provinceTF: ZrTF!
    var cityTF: ZrTF!
    var signTF: ZrTF!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        drawUI()
    }
    
    
    
}

//MARK: - UI管理 & 按钮方法
extension InfoChange {
    func drawUI() {
        nameTF = ZrTF(frame: CGRect(x: 0, y: 100, width: 200, height: 40))
        nameTF.placeholder = user.nickname
        view.addSubview(nameTF)
        
        genderTF = ZrTF(frame: CGRect(x: 0, y: 200, width: 200, height: 40))
        genderTF.placeholder = genderIToS(i: user.gender!)
        view.addSubview(genderTF)
        
        birthTF = ZrTF(frame: CGRect(x: 0, y: 300, width: 200, height: 40))
        birthTF.placeholder = String(describing: user.birth!).timestampToDate()
        view.addSubview(birthTF)
        
        provinceTF = ZrTF(frame: CGRect(x: 0, y: 400, width: 200, height: 40))
        provinceTF.placeholder = user.province
        view.addSubview(provinceTF)
        
        cityTF = ZrTF(frame: CGRect(x: 0, y: 500, width: 200, height: 40))
        cityTF.placeholder = user.city
        view.addSubview(cityTF)
        
        signTF = ZrTF(frame: CGRect(x: 0, y: 600, width: 200, height: 40))
        signTF.placeholder = "签名"
        view.addSubview(signTF)
        
        checkBtn = ZrBtn(frame: CGRect(x: 0, y: 700, width: 100, height: 40))
        checkBtn.backgroundColor = .red
        checkBtn.setTitle("确认", for: .normal)
        checkBtn.addTarget(self, action: #selector(commit), for: .touchUpInside)
        view.addSubview(checkBtn)
    }
    
    @objc func commit() {
        var pInt: String!
        var cInt: String!
        
        Alamofire.request(URL(string: "https://apis.map.qq.com/ws/district/v1/search?&key=JQ7BZ-3ZJCX-7GV4S-7EFGP-BUKFZ-5RFC3&keyword=\((self.provinceTF.text)!)")!).responseJSON { (d) in
            do {
                let datas = try JSONDecoder().decode(LocationGet.self, from: d.data!)
                pInt = datas.result?[0][0].id ?? ""
                Alamofire.request(URL(string: "https://apis.map.qq.com/ws/district/v1/search?&key=JQ7BZ-3ZJCX-7GV4S-7EFGP-BUKFZ-5RFC3&keyword=\((self.cityTF.text)!)")!).responseJSON { (d) in
                    do {
                        let datas = try JSONDecoder().decode(LocationGet.self, from: d.data!)
                        cInt = datas.result?[0][0].id ?? ""
                        
                        var url = "http://localhost:3000/user/update?"
                        if self.genderTF.text != "" {
                            url += "&gender=\(self.genderSToI(s: (self.genderTF.text)!))"
                        }
                        if self.signTF.text != "" {
                            url += "&signature=\((self.signTF.text)!)"
                        }
                        if self.provinceTF.text != "" {
                            url += "&province=\(pInt)"
                        }
                        if self.cityTF.text != "" {
                            url += "&city=\(cInt)"
                        }
                        if self.nameTF.text != "" {
                            url += "&nickname=\((self.nameTF.text)!)"
                        }
                        if self.birthTF.text != "" {
                            url += "&birthday=\((self.birthTF.text)!.dateToTimeStamp())"
                        }
                        
                        Alamofire.request(URL(string: url)!)
                        
                        self.navigationController?.popViewController(animated: true)
                    } catch {
                        print(error)
                    }
                }

                
            } catch {
                print(error)
                print("修改个人信息失败")
            }
        }
    }
    
    func genderSToI(s: String) -> Int {
        if s == "保密" {
            return 0
        } else if s == "男" {
            return 1
        } else if s == "女" {
            return 2
        } else {
            return 0
        }
    }
    
    func genderIToS(i: Int) -> String {
        if i == 1 {
            return "男"
        } else if i == 2 {
            return "女"
        } else {
            return "保密"
        }
    }
}
