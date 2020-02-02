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

class Accounter: UIViewController {
//    组件
    var tableView: UITableView!
    let ud = UserDefaults.standard
    
//    属性
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    var user = User()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        初始化tableView
        getData {
            self.setupTV()
            self.view.addSubview(self.tableView)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
//        tableView.reloadData()
    }
}
//MARK: - UI相关
extension Accounter {
    func setupTV() {
        tableView = UITableView(frame: CGRect(x: 0, y: 70, width: width, height: height - 70), style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
    }
}
//MARK: - 获取数据
extension Accounter {
    func getData(someClosure: @escaping () -> Void) {
        let uid = ud.integer(forKey: "uid")
        Alamofire.request(URL(string: "http://localhost:3000/user/detail?uid=\(uid)")!).responseJSON { (d) in
            do {
                let datas = try JSONDecoder().decode(UserDetailGet.self, from: d.data!)
                self.user.nickname = datas.profile?.nickname
                self.user.gender = datas.profile?.gender
                self.user.level = datas.level
                self.user.listenSongs = datas.listenSongs
                self.user.birth = datas.profile?.birthday
                self.user.signature = datas.profile?.signature
                self.user.avatarImg = URL(string: (datas.profile?.avatarURL) ?? "")
                self.user.backImg = URL(string: (datas.profile?.backgroundURL) ?? "")
                self.user.follows = datas.profile?.follows
                self.user.followeds = datas.profile?.followeds
                self.user.beSubed = datas.profile?.playlistBeSubscribedCount
//                //        TODO: 用来返回城市信息
//                Alamofire.request(URL(string: "https://restapi.amap.com/v3/config/district?keywords=\((datas.profile?.province)!)&subdistrict=0&key=7ad4fb0fd2a9685ee0211aa036c4a177")!).responseJSON { (d) in
//                    do {
//                        let datas = try JSONDecoder().decode(CityGet.self, from: d.data!)
////                        会返回各个区的资料，我们只需要省市
//                        self.province = datas.districts![0].name
//
//                    } catch {
//                        print("省份获取失败")
//                    }
//                }
//                Alamofire.request(URL(string: "https://restapi.amap.com/v3/config/district?keywords=\((datas.profile?.city)!)&subdistrict=0&key=7ad4fb0fd2a9685ee0211aa036c4a177")!).responseJSON { (d) in
//                    do {
//                        let datas = try JSONDecoder().decode(CityGet.self, from: d.data!)
////                        会返回各个区的资料，我们只需要省市
//                        self.city = datas.districts![0].name
//
//                    } catch {
//                        print("城市获取失败")
//                    }
//                }
//
                someClosure()
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
        //格式话输出
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
            cell.avatar.sd_setImage(with: self.user.avatarImg , placeholderImage: UIImage(named: "default"))
            cell.nickname.text = self.user.nickname ?? "没有登录哦"
            cell.level.text = "Lv.\(self.user.level ?? 0)"
            cell.listened.text = "你欣赏过\(self.user.listenSongs ?? 0)次世界的颜色"
            cell.listened.adjustsFontSizeToFitWidth = true
            cell.birth.text = birthTrans(num: self.user.birth ?? 0)
            cell.gender = self.user.gender
            cell.city.text = self.user.city
            cell.signature.text = "签名：\(self.user.signature ?? "")"
            return cell
        case 1:
            let cell = fansCell()
            cell.selectionStyle = .none
            let c1 = self.user.followeds ?? 0
            cell.followeds.text = "粉丝\n\(c1)"
            let c2 = self.user.follows ?? 0
            cell.follows.text = "关注\n\(c2)"
            let c3 = self.user.beSubed ?? 0
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
            user = User()
            tableView.reloadData()
        }
    }
}

