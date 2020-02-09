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
    
    weak var delegate: UserDelegate?
    
    var checkBtn: UIButton!
    var nameTF: ZrTF!
    var birthTF: ZrTF!
    var birthBtn: UIButton!
    var genderTF: ZrTF!
    var genderBtn: UIButton!
    var provinceTF: ZrTF!
    var cityTF: ZrTF!
    var signTF: ZrTF!
    
    var genderPickerView: UIPickerView!
    var genderPickerCheck: UIButton!
    
    var birthPickerView: UIPickerView!
    var birthPickerCheck: UIButton!
    
    var blurEffect: UIBlurEffect!
    var blurView: UIVisualEffectView!
    
    var cancelBtn: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(back))
        drawUI()
    }
    
    
    
}

//MARK: - UI管理 & 按钮方法
extension InfoChange {
    func drawUI() {
        nameTF = ZrTF(frame: CGRect(x: 0, y: 100, width: 200, height: 40))
        nameTF.placeholder = delegate!.user.nickname
        view.addSubview(nameTF)
        
        genderTF = ZrTF(frame: CGRect(x: 0, y: 200, width: 200, height: 40))
        genderTF.placeholder = genderIToS(i: delegate!.user.gender!)
        view.addSubview(genderTF)
        
        genderBtn = UIButton()
        genderBtn.setImage(UIImage(systemName: "text.justify")?.withRenderingMode(.alwaysOriginal), for: .normal)
        genderBtn.addTarget(self, action: #selector(showGenderSelector), for: .touchUpInside)
        view.addSubview(genderBtn)
        genderBtn.snp.updateConstraints { (ConstraintMaker) in
            ConstraintMaker.width.height.equalTo(50)
            ConstraintMaker.left.equalTo(genderTF.snp.right).offset(10)
            ConstraintMaker.centerY.equalTo(genderTF.snp.centerY)
        }
        
        birthTF = ZrTF(frame: CGRect(x: 0, y: 300, width: 200, height: 40))
        birthTF.placeholder = String(describing: delegate!.user.birth!).timestampToDate()
        view.addSubview(birthTF)
        
        birthBtn = UIButton()
        birthBtn.setImage(UIImage(systemName: "text.justify")?.withRenderingMode(.alwaysOriginal), for: .normal)
        birthBtn.addTarget(self, action: #selector(showBirthSelector), for: .touchUpInside)
        view.addSubview(birthBtn)
        birthBtn.snp.updateConstraints { (ConstraintMaker) in
            ConstraintMaker.width.height.equalTo(50)
            ConstraintMaker.left.equalTo(birthTF.snp.right).offset(10)
            ConstraintMaker.centerY.equalTo(birthTF.snp.centerY)
        }
        
        provinceTF = ZrTF(frame: CGRect(x: 0, y: 400, width: 200, height: 40))
        provinceTF.placeholder = delegate!.user.province
        view.addSubview(provinceTF)
        
        cityTF = ZrTF(frame: CGRect(x: 0, y: 500, width: 200, height: 40))
        cityTF.placeholder = delegate!.user.city
        view.addSubview(cityTF)
        
        signTF = ZrTF(frame: CGRect(x: 0, y: 600, width: 200, height: 40))
        signTF.placeholder = "签名"
        view.addSubview(signTF)
        
        checkBtn = ZrBtn(frame: CGRect(x: 0, y: 700, width: 100, height: 40))
        checkBtn.backgroundColor = .red
        checkBtn.setTitle("确认", for: .normal)
        checkBtn.addTarget(self, action: #selector(commit), for: .touchUpInside)
        view.addSubview(checkBtn)
        
        cancelBtn = UIButton(frame: ZrRect(xOffset: -100, y: 550, width: 100, height: 50))
        cancelBtn.backgroundColor = .red
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        
        blurEffect = UIBlurEffect(style: .light)
        blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame.size = CGSize(width: view.frame.width, height: view.frame.height)

        
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
                            url += "&birthday=\((self.birthTF.text)!.dateToTimeStamp())000"
                        }
                        
                        Alamofire.request(URL(string: url)!)
                        if self.delegate != nil {
                            if self.genderTF.text != "" {
                                self.delegate?.user.gender = self.genderSToI(s: (self.genderTF.text)!)
                            }
                            if self.signTF.text != "" {
                                self.delegate?.user.signature = (self.signTF.text)!
                            }
                            if self.provinceTF.text != "" {
                                self.delegate?.user.province = pInt
                            }
                            if self.cityTF.text != "" {
                                self.delegate?.user.city = cInt
                            }
                            if self.nameTF.text != "" {
                                self.delegate?.user.nickname = (self.nameTF.text)!
                            }
                            if self.birthTF.text != "" {
                                self.delegate?.user.birth = Int(String(describing: self.birthTF.text!).dateToTimeStamp())! * 1000
                            }
                        }
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
    
    @objc func showGenderSelector() {
        self.view.addSubview(blurView)
        
        genderPickerView = UIPickerView(frame: ZrRect(y: 200, width: 400, height: 300))
        genderPickerView.delegate = self
        genderPickerView.dataSource = self
        blurView.contentView.addSubview(genderPickerView)
        genderPickerView.selectRow(self.genderSToI(s:
            self.genderTF.text! == "" ? self.genderTF.placeholder! : self.genderTF.text!
            ), inComponent:0, animated:true)
        
        genderPickerCheck = UIButton(frame: ZrRect(xOffset: 100, y: 550, width: 100, height: 50))
        genderPickerCheck.setTitle("确认", for: .normal)
        genderPickerCheck.backgroundColor = .red
        blurView.contentView.addSubview(genderPickerCheck)
        genderPickerCheck.addTarget(self, action: #selector(genderCheck), for: .touchUpInside)
        
        blurView.contentView.addSubview(cancelBtn)
    }
    
    @objc func genderCheck() {
        blurView.removeFromSuperview()
        genderPickerView.removeFromSuperview()
        genderPickerCheck.removeFromSuperview()
        cancelBtn.removeFromSuperview()
        genderTF.text = genderIToS(i: genderPickerView.selectedRow(inComponent: 0))
    }
    
    @objc func showBirthSelector() {
        self.view.addSubview(blurView)
        
        birthPickerView = UIPickerView(frame: ZrRect(y: 200, width: 400, height: 300))
        birthPickerView.delegate = self
        birthPickerView.dataSource = self
        blurView.contentView.addSubview(birthPickerView)
        let time = self.birthTF.text! == "" ? self.birthTF.placeholder! : self.birthTF.text!
        let timeArray = time.components(separatedBy: "-")
        birthPickerView.selectRow(Int(timeArray[0])! - 1970, inComponent: 0, animated: true)
        birthPickerView.selectRow(Int(timeArray[1])! - 1, inComponent: 1, animated: true)
        birthPickerView.selectRow(Int(timeArray[2])! - 1, inComponent: 2, animated: true)
        
        birthPickerCheck = UIButton(frame: ZrRect(xOffset: 100, y: 550, width: 100, height: 50))
        birthPickerCheck.setTitle("确认", for: .normal)
        birthPickerCheck.backgroundColor = .red
        blurView.contentView.addSubview(birthPickerCheck)
        birthPickerCheck.addTarget(self, action: #selector(birthCheck), for: .touchUpInside)
        
        blurView.contentView.addSubview(cancelBtn)
    }
    
    @objc func birthCheck() {
        blurView.removeFromSuperview()
        birthPickerView.removeFromSuperview()
        birthPickerCheck.removeFromSuperview()
        cancelBtn.removeFromSuperview()
        birthTF.text = "\(birthPickerView.selectedRow(inComponent: 0) + 1970)-\(birthPickerView.selectedRow(inComponent: 1) + 1)-\(birthPickerView.selectedRow(inComponent: 2) + 1)"
    }
    
    @objc func back() {
        let alert = UIAlertController(title: "警告⚠️", message: "你的信息还没有保存\n确定要退出吗", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "不退了", style: .cancel, handler: nil)
        let action2 = UIAlertAction(title: "我就要退", style: .default) { action in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(action1)
        alert.addAction(action2)
        present(alert, animated: true, completion: nil)
    }
    
    @objc func cancel() {
        blurView.removeFromSuperview()
        if (birthPickerView != nil) && (birthPickerCheck != nil) {
            birthPickerView.removeFromSuperview()
            birthPickerCheck.removeFromSuperview()
        }
        if (genderPickerView != nil) && (genderPickerView != nil) {
            genderPickerView.removeFromSuperview()
            genderPickerCheck.removeFromSuperview()
        }
        cancelBtn.removeFromSuperview()
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

//MARK: - PickView协议
extension InfoChange: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView == birthPickerView {
            return 3
        } else {
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == birthPickerView {
            switch component {
            case 0:
                return 100
            case 1:
                return 12
            default:
                return 31
            }
        } else {
            return 3
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == birthPickerView {
            switch component {
            case 0:
                return String(row + 1970)
            case 1:
                return String(row + 1)
            default:
                return String(row + 1)
            }
        } else {
            switch row {
            case 0:
                return "保密"
            case 1:
                return "男"
            default:
                return "女"
            }
        }
    }
}
