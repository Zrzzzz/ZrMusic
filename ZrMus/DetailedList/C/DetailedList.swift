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
            for i in 0..<songList.count {
                Alamofire.request(URL(string: "http://localhost:3000/check/music?id=\(songList[i].id!)")!).responseJSON { (d) in
                    do {
                        let datas = try JSONDecoder().decode(IsOKGet.self, from: d.data!)
                        self.songList[i].isOK = datas.success!
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
    var songList: [Song] = []
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
        addData(song: songList[index])
        print("added to list: \(songList[index].name)")
    }
    
    @objc func download() {
        let alert = UIAlertController(title: "下载", message: "下载此歌单所有的歌?", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let action2 = UIAlertAction(title: "确认", style: .default) { (_) in
            for song in self.songList {
                let destination: DownloadRequest.DownloadFileDestination = { _, response in
                let documentsURL = FileManager.default.urls(for: .musicDirectory, in: .userDomainMask) [0]
                    let fileURL = documentsURL.appendingPathComponent("zrmusic/\(song.name)-\(song.arName)-\(song.alName)-\(song.id!).mp3")
                return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
                }
                Alamofire.download(URL(string: "https://music.163.com/song/media/outer/url?id=\(song.id!).mp3")!, to: destination).response { response in
                    print(" - 已下载 - \(song.name) -\(song.arName)")
                }
            }
        }
        alert.addAction(action1)
        alert.addAction(action2)
        
        self.present(alert, animated: true)
    }
    
    @objc func deleteList() {
        let alert = UIAlertController(title: "警告⚠️", message: "你真的要删除此歌单吗", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let action2 = UIAlertAction(title: "确定", style: .default) { (_) in
            Alamofire.request(URL(string: "http://localhost:3000/playlist/delete?id=\(self.listId!)")!).response { _ in
                self.presentingViewController?.dismiss(animated: true, completion: nil)
            }
        }
        alert.addAction(action1)
        alert.addAction(action2)
        
        self.present(alert, animated: true)
    }
}

//MARK: - 数据管理
extension DetailedList {
    func getData(someClosure: @escaping () -> Void) {
        let timestamp = Int(Date().timeIntervalSince1970)
        let url = "http://localhost:3000/playlist/detail?id=\(listId!)&timestamp=\(timestamp)"
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
                    self.songList.append(song)
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
            return songList.count
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
            cell.downLoadBtn.addTarget(self, action: #selector(download), for: .touchUpInside)
            cell.deleteBtn.addTarget(self, action: #selector(deleteList), for: .touchUpInside)
            return cell
        default:
            let reuseid = "dl"
            tableView.register(DLCell2.self, forCellReuseIdentifier: reuseid)
            let cell: DLCell2 = tableView.dequeueReusableCell(withIdentifier: reuseid) as! DLCell2
            if !songList.isEmpty {
                cell.isOK = songList[indexPath.row].isOK ?? true
                if !(cell.isOK ?? true) {
                    cell.nameLabel.textColor = .gray
                    cell.creatorLabel.textColor = .gray
                }
                cell.countLabel.text = String(indexPath.row + 1)
                cell.nameLabel.text = songList[indexPath.row].name
                cell.creatorLabel.text = "\(songList[indexPath.row].arName) - \(songList[indexPath.row].alName)"
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
        switch indexPath.section {
        case 0:
            return
        default:
            tableView.deselectRow(at: indexPath, animated: true)
            if songList[indexPath.row].isOK! {
                addData(song: songList[indexPath.row], isFirst: true)
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
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        switch indexPath.section {
        case 0:
            return false
        default:
            return true
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            Alamofire.request(URL(string: "http://localhost:3000/playlist/tracks?op=del&pid=\(listId!)&tracks=\(songList[indexPath.row].id!)")!)
            songList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
        }
    }
}
