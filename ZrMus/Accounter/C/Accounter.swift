//
//  Accounter.swift
//  ZrMus
//
//  Created by Zr埋 on 2020/1/21.
//  Copyright © 2020 Zr埋. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire
import SDWebImage

class Accounter: UIViewController, UserDelegate {
    
    
//    组件
    var tableView: UITableView!
    let ud = UserDefaults.standard
    
//    属性
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    var user: User = User(level: nil, listenSongs: nil, profile: nil) {
        didSet {
            tableView.reloadData()
        }
    }
    var province: String!
    var city: String!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        初始化tableView
        self.setupTV()
        let userid = UserDefaults.standard.value(forKey: "uid")
        if userid != nil {
            getData {
                self.tableView.reloadData()
            }
        }
        view.addSubview(self.tableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
      
    }
}
//MARK: - UI相关 & 按钮方法
extension Accounter {
    func setupTV() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "更改资料", style: .plain, target: self, action: #selector(to))
        
        tableView = UITableView(frame: CGRect(x: 0, y: 70, width: width, height: height - 70), style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
    }
    
    @objc func to() {
        let vc = InfoChange()
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
}
//MARK: - 获取数据
extension Accounter {
    func getData(someClosure: @escaping () -> Void) {
        let uid = ud.integer(forKey: "uid")
        let timestamp = Int(Date().timeIntervalSince1970)
        Alamofire.request(URL(string: "http://localhost:3000/user/detail?uid=\(uid)&timestamp=\(timestamp)")!).responseJSON { (d) in
            do {
                let group = DispatchGroup()
                let datas = try JSONDecoder().decode(User.self, from: d.data!)
                self.user = datas
                group.enter()
                Alamofire.request(URL(string: "https://apis.map.qq.com/ws/district/v1/search?&key=JQ7BZ-3ZJCX-7GV4S-7EFGP-BUKFZ-5RFC3&keyword=\((datas.profile?.province)!)")!).responseJSON { (d) in
                    do {
                        let datas = try JSONDecoder().decode(LocationGet.self, from: d.data!)
//                        会返回各个区的资料，我们只需要省市
                        self.province = datas.result![0][0].fullname
                        group.leave()
                    } catch {
                        print("省份获取失败")
                    }
                }
                group.enter()
                Alamofire.request(URL(string: "https://apis.map.qq.com/ws/district/v1/search?&key=JQ7BZ-3ZJCX-7GV4S-7EFGP-BUKFZ-5RFC3&keyword=\((datas.profile?.city)!)")!).responseJSON { (d) in
                    do {
                        let datas = try JSONDecoder().decode(LocationGet.self, from: d.data!)
//                        会返回各个区的资料，我们只需要省市
                        self.city = datas.result![0][0].fullname
                        group.leave()
                    } catch {
                        print("城市获取失败")
                    }
                }

                group.notify(queue: .main) {
                    someClosure()
                }
            } catch {
                print(error)
                print("个人信息获取失败")
            }
        }
    }
//    来计算下xx后
    func birthTrans(num: Int) -> String {
        //时间戳, 而且这个是毫秒级
        let timeStamp = num / 1000
        //转换为时间
        let timeInterval:TimeInterval = TimeInterval(timeStamp)
        let date = NSDate(timeIntervalSince1970: timeInterval)
        //格式化输出
        let dformatter = DateFormatter()
        dformatter.dateFormat = "yy"
//        这是年份的后两位
        let y = dformatter.string(from: date as Date)
        return "\(y[y.startIndex])0后"
    }
}
//MARK: - Tableview协议
extension Accounter: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView(frame: CGRect.zero)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: CGRect.zero)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 120
        case 1:
            return 80
        default:
            return 30
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = nicknameCell()
            cell.selectionStyle = .none
            cell.avatar.sd_setImage(with: URL(string: (user.profile?.avatarUrl ?? "")), placeholderImage: UIImage(named: "default"))
            cell.nickname.text = self.user.profile?.nickname ?? "没有登录哦"
            cell.level.text = "Lv.\(self.user.level ?? 0)"
            cell.listened.text = "你欣赏过\(self.user.listenSongs ?? 0)次世界的颜色"
            cell.listened.adjustsFontSizeToFitWidth = true
            cell.birth.text = birthTrans(num: self.user.profile?.birthday ?? 0)
            cell.birth.backgroundColor = self.user.profile?.gender == 2 ? ZrColor(r: 241, g: 151, b: 144) : ZrColor(r: 36, g: 134, b: 185)
            let imgName = { () -> String in
                if self.user.profile?.gender == 1 {
                    return "ac_man"
                } else if self.user.profile?.gender == 2 {
                    return "ac_woman"
                } else {
                    return "ac_nil"
                }
            }
            cell.genderView.image = UIImage(named: imgName())?.withRenderingMode(.alwaysOriginal)
            cell.location.text = "\(self.province ?? "") \(self.city ?? "")"
            if self.province != nil || self.city != nil {
                cell.location.backgroundColor = ZrColor(r: 39, g: 117, b: 182)
            }
            cell.signature.text = "签名：\(self.user.profile?.signature ?? "")"
            return cell
        case 1:
            let cell = fansCell()
            cell.selectionStyle = .none
            let c1 = self.user.profile?.followeds ?? 0
            cell.followeds.text = "粉丝\n\(c1)"
            let c2 = self.user.profile?.follows ?? 0
            cell.follows.text = "关注\n\(c2)"
            let c3 = self.user.profile?.playlistBeSubscribedCount ?? 0
            cell.subed.text = "有\(c3)人\n订阅了\n你的歌单"
            return cell
        default:
            let cell = UITableViewCell()
            cell.textLabel?.text = "退出登录"
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.textColor = .red
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
//            数据放空
            ud.set(nil, forKey: "uid")
//            退出登录，刷新数据
            Alamofire.request("http://localhost:3000/logout")
            user = User(level: nil, listenSongs: nil, profile: nil)
            tableView.reloadData()
        }
    }
}

