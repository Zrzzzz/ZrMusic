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
    
    let level: Int!
    let 
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        初始化tableView
        setupTV()
        view.addSubview(tableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
    }
}
//MARK: - UI相关
extension Accounter {
    func setupTV() {
        tableView = UITableView(frame: CGRect(x: 0, y: 70, width: width, height: height - 70), style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
    }
}
//MARK: - 获取数据
extension Accounter {
    func getData() {
        let uid = ud.integer(forKey: "uid")
        Alamofire.request(URL(string: "http://localhost:3000/user/detail?uid=\(uid)")!).responseJSON { (d) in
            do {
                let datas = try JSONDecoder().decode(UserDetailGet.self, from: d.data!)
                
            } catch {
                print(error)
            }
        }
        
        
    }
}
//MARK: - Tableview协议
extension Accounter: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 100
        case 1:
            return 80
        default:
            return 30
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let udDic = ud.dictionary(forKey: "dS")
        
        switch indexPath.section {
        case 0:
            let cell = nicknameCell()
            let imgUrl = udDic?["avatarURL"] == nil ? "https://tva1.sinaimg.cn/large/006tNbRwgy1gbbgcnsc6zj30hm0fqngx.jpg" : udDic?["avatarURL"]
            cell.avatar.sd_setImage(with: URL(string: imgUrl as! String)
                , placeholderImage: UIImage(named: "default"))
            cell.nickname.text = udDic?["nickname"] as? String ?? "没有登录哦"
            return cell
        case 1:
            let cell = fansCell()
            let c1 = udDic?["followeds"] as? Int ?? 0
            cell.followeds.text = "粉丝\n\(c1)"
            let c2 = udDic?["follows"] as? Int ?? 0
            cell.follows.text = "关注\n\(c2)"
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
            ud.set(nil, forKey: "dS")
//            退出登录，刷新数据
            Alamofire.request("http://localhost:3000/logout")
            tableView.reloadData()
        }
    }
}
