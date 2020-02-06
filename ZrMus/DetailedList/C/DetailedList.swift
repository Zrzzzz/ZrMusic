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
    var check: Bool = false {
        didSet {
            for i in 0..<list.count {
                Alamofire.request(URL(string: "http://localhost:3000/check/music?id=\(list[i].id!)")!).responseJSON { (d) in
                    do {
                        let datas = try JSONDecoder().decode(IsOKGet.self, from: d.data!)
                        self.list[i].isOK = datas.success!
                        self.tableView.reloadRows(at: [[1, i]], with: .automatic)
                    } catch {
                        print(error)
                        print("可用获取失败")
                    }
                }
            }
        }
    }
//    存储数据
    var list: [Song] = []
    let db = DataBase.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData(someClosure: closure)
        
    }
}
//MARK: - UI管理 & 按钮方法
extension DetailedList {
    func closure() {
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 50))
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.reloadData()
        check = true
    }
    
    @objc func addToQueue(sender: UIButton) {
        let tableView = sender.superView(of: UITableView.self)
        let index = tableView!.indexPath(for: sender.superView(of: UITableViewCell.self)!)!.row
        addData(song: list[index])
        print("added to list: \(list[index].name)")
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
                let group = DispatchGroup()
                for track in (datas.playlist?.tracks)! {

                    var song = Song(
                        id: track.id ?? 0, name: track.name ?? "", arName: track.ar?[0].name ?? "", alName: (track.al?.name) ?? "", url: nil, imgUrl: URL(string: ((track.al?.picURL) ?? "")), isFirst: nil
                    )
                    self.list.append(song)
                }
                someClosure()
            } catch {
                print(error)
                print("详情获取失败")
            }
        }
    }
    
    func addData(song: Song, isFirst: Bool = false) {
        let context = db.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Music", in: context)
        let music = NSManagedObject(entity: entity!, insertInto: context)
        music.setValue(song.id, forKey: "id")
        music.setValue(song.alName, forKey: "alname")
        music.setValue(song.arName, forKey: "arname")
        music.setValue(song.imgUrl, forKey: "imgUrl")
        music.setValue(song.name, forKey: "name")
        music.setValue(isFirst, forKey: "isFirst")
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
            return list.count
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
            let cell: DLCell2 = tableView.dequeueReusableCell(withIdentifier: reuseid) as! DLCell2
            if !list.isEmpty {
                cell.isOK = list[indexPath.row].isOK ?? true
                if !(cell.isOK ?? true) {
                    cell.nameLabel.textColor = .gray
                    cell.creatorLabel.textColor = .gray
                }
                cell.countLabel.text = String(indexPath.row + 1)
                cell.nameLabel.text = list[indexPath.row].name
                cell.creatorLabel.text = "\(list[indexPath.row].arName) - \(list[indexPath.row].alName)"
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
        if list[indexPath.row].isOK! {
            addData(song: list[indexPath.row], isFirst: true)
            self.dismiss(animated: true, completion: nil)
            let t = UIApplication.shared.keyWindow?.rootViewController
            if (t?.isKind(of:  UITabBarController.self))! {
                (t as? UITabBarController)?.selectedIndex = 0
            }
        } else {
            let alert = UIAlertController(title: "这首歌没版权哦", message: nil, preferredStyle: .alert)
            let known = UIAlertAction(title: "我知道了", style: .default, handler: nil)
            alert.addAction(known)
            present(alert, animated: true, completion: nil)
        }
    }
}
