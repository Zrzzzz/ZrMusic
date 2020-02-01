//
//  DetailedList.swift
//  ZrMus
//
//  Created by Zr埋 on 2020/1/30.
//  Copyright © 2020 Zr埋. All rights reserved.
//

import UIKit
import Alamofire
import CoreData

class DetailedList: UIViewController {
    
    var listId: Int!
    var tableView: UITableView!
    var alImgUrl: URL!
    var alName: String!
//    存储数据
    var lists: [Song] = []
    let db = DataBase.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData(someClosure: closure)
        
    }
}
//MARK: - UI管理 & 按钮方法
extension DetailedList {
    func closure() {
        tableView = UITableView(frame: UIScreen.main.bounds)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.reloadData()
    }
    
    @objc func addToQueue(sender: UIButton) {
        let tableView = sender.superView(of: UITableView.self)
        let index = tableView!.indexPath(for: sender.superView(of: UITableViewCell.self)!)!.row
        addData(song: lists[index])
        print(lists[index].name)
    }
}

//MARK: - 数据管理
extension DetailedList {
    func getData(someClosure: @escaping () -> Void) {
        let url = "http://localhost:3000/playlist/detail?id=\(listId!)"
        Alamofire.request(url).responseJSON { (d) in
            do {
                let datas = try JSONDecoder().decode(ListDetailGet.self, from: d.data!)
                print("详情获取成功")
                
                self.alName = datas.playlist?.name
                self.alImgUrl = URL(string: (datas.playlist?.coverImgURL)!)
                for track in (datas.playlist?.tracks)! {
                    let list = Song(
                        id: track.id ?? 0, name: track.name ?? "", arName: track.ar?[0].name ?? "", alName: (track.al?.name) ?? "", url: nil, imgUrl: URL(string: ((track.al?.picURL) ?? ""))
                    )
                    self.lists.append(list)
                }
                
                someClosure()
            } catch {
                print(error)
                print("详情获取失败")
            }
        }
    }
    
    func addData(song: Song) {
        let context = db.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Music", in: context)
        let music = NSManagedObject(entity: entity!, insertInto: context)
        music.setValue(song.id, forKey: "id")
        music.setValue(song.alName, forKey: "alname")
        music.setValue(song.arName, forKey: "arname")
        music.setValue(song.imgUrl, forKey: "imgUrl")
        music.setValue(song.name, forKey: "name")
        
        do {
            try context.save()
        } catch {
            fatalError("无法保存")
        }
    }
}
//MARK: - Tableview协议
extension DetailedList: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return lists.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 140
        default:
            return 80
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = DLCell1()
            cell.coverImg?.sd_setImage(with: alImgUrl, placeholderImage: UIImage(named: "default"))
            cell.selectionStyle = .none
            cell.nameLabel.text = alName
//            TODO: 下载
//            cell.downLoadBtn.addTarget(self, action: , for: <#T##UIControl.Event#>)
            
            return cell
        default:
            let reuseid = "dl"
            tableView.register(DLCell2.self, forCellReuseIdentifier: reuseid)
            var cell: DLCell2 = tableView.dequeueReusableCell(withIdentifier: reuseid) as! DLCell2
            if cell == nil {
                cell = DLCell2(style: .default, reuseIdentifier: reuseid)
            }
            if !lists.isEmpty {
                cell.countLabel.text = String(indexPath.row + 1)
                cell.nameLabel.text = lists[indexPath.row].name
                cell.creatorLabel.text = "\(lists[indexPath.row].arName) - \(lists[indexPath.row].alName)"
//                调整字体，由于reloadData的原因，字体大小会被重新设置，所以不能在cell里设置，得在delegate里面重新设置
                cell.countLabel.fontSuitToFrame()
                cell.nameLabel.font = .boldSystemFont(ofSize: 20)
                cell.creatorLabel.fontSuitToFrame()
                cell.addBtn.addTarget(self, action: #selector(addToQueue(sender:)), for: .touchUpInside)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        addData(song: lists[indexPath.row])
        self.dismiss(animated: true, completion: nil)
        let t = UIApplication.shared.keyWindow?.rootViewController
        if (t?.isKind(of:  UITabBarController.self))! {
            (t as? UITabBarController)?.selectedIndex = 0
        }
    }
}
