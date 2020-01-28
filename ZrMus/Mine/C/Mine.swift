//
//  Mine.swift
//  ZrMus
//
//  Created by Zr埋 on 2020/1/21.
//  Copyright © 2020 Zr埋. All rights reserved.
//

import UIKit
import Alamofire
import CoreData

class Mine: UIViewController {
    
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    var tableView: UITableView!
    let ud = UserDefaults.standard
    let db = DataBase.shared
    let reuseID = "id"
    
//    两种歌单类型
    var myLists: [SongList] = []
    var subscribedLists: [SongList] = []
    
//    这个用来判断列表是不是打开的
    var selectedCellIndexPaths: [IndexPath] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        getData(someCloure: clousure)
        
    }
    
}

extension Mine {
    
    func drawUI() {
        tableView = UITableView(frame: CGRect(x: 0, y: 70, width: width, height: height - 70))
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func clousure() {
        getDbData()
        drawUI()
        tableView.reloadData()
    }
}

extension Mine {
    
    func getData(someCloure: @escaping() -> Void) {
        let url = "http://localhost:3000/user/playlist?uid=\(ud.string(forKey: "uid")!)"
        Alamofire.request(url).responseJSON { (d) in
            do {
                let datas = try JSONDecoder().decode(SongListGet.self, from: d.data!)
                print("获取歌单成功")
                let playLists = datas.playlist
                
                
                for playList in playLists {
                    let list = SongList(
                        name: playList.name, id: playList.id, imgUrl: URL(string: playList.coverImgURL)!, count: playList.trackCount, subscribed: playList.subscribed
                    )
//                    db保存
                    self.saveList(list)
                }
    
                someCloure()
            } catch {
                print("获取歌单失败")
                print(error)
            }
        }
    }
    
    func getDbData() {
//        Step1: 获取托管对象总管
        let managedObjectContext = db.persistentContainer.viewContext
//        Step2: 建立一个获取的请求
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SongLists")
//        Step3: 执行请求
        do {
            let fetchedResults = try managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResults {
                for result in results {
                    guard let list: SongList = result.value(forKey: "songlist") as! SongList else { return }
                    if list.subscribed == false {
                        myLists.append(list)
                    } else {
                        subscribedLists.append(list)
                    }
                }
            }
        } catch {
            fatalError("获取失败")
        }
    }
    
    func saveList(_ sth: SongList) {
//        Step1: 获取托管对象总管
        let managedObjectContext = db.persistentContainer.viewContext
//        Step2: 建立一个entity
        let entity = NSEntityDescription.entity(forEntityName: "SongLists", in: managedObjectContext)
        let songlists = NSManagedObject(entity: entity!, insertInto: managedObjectContext)
//        Step3: 保存Dic到songlists
        songlists.setValue(sth, forKey: "songlist")
//        Step4: 保存entity到托管对象中；如果保存失败抛出异常
        do {
            try managedObjectContext.save()
        } catch {
            fatalError("无法保存")
        }
    }
}

extension Mine: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 80
        default:
//            看indexPath是否是展开的，返回不同的高度
            if selectedCellIndexPaths.contains(indexPath) {
//                获取歌单的个数
                let count1 = myLists.count
                let count2 = subscribedLists.count
                switch indexPath.row {
                case 0:
                    return CGFloat(80 + (count1 ?? 0) * 80)
                default:
                    return CGFloat(80 + (count2 ?? 0) * 80)
                }
            }
            return 80
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = ncCell()
            cell.leftView.image = UIImage(named: "mine_music")
            cell.titilLabel.text = "本地音乐"
            cell.countLabel.text = "(0)"
            return cell
        default:
            let index = indexPath.row
            tableView.register(listCell.self, forCellReuseIdentifier: reuseID)
            var cell: listCell = tableView.dequeueReusableCell(withIdentifier: reuseID) as! listCell
            if cell == nil {
                cell = listCell(style: .default, reuseIdentifier: reuseID)
        }
//            分类解析
            switch index {
            case 0:
//                设定分类
                cell.titleLabel.text = "创建歌单"
//                描绘cell
                cell.countLabel.text = "(\(myLists[index].count))"
                cell.imgView.sd_setImage(with: myLists[index].imgUrl, placeholderImage: UIImage(named: "default"))
                cell.nameLabel.text = myLists[index].name
            default:
//                设定分类
                cell.titleLabel.text = "收藏歌单"
//                描绘cell
                cell.countLabel.text = "(\(subscribedLists[index].count))"
                cell.imgView.sd_setImage(with: subscribedLists[index].imgUrl, placeholderImage: UIImage(named: "default"))
                cell.nameLabel.text = subscribedLists[index].name
            }
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            tableView.deselectRow(at: indexPath, animated: true)
//            这里要到本地音乐的NC去
//            navigationController?.pushViewController(<#T##viewController: UIViewController##UIViewController#>, animated: <#T##Bool#>)
        default:
            tableView.deselectRow(at: indexPath, animated: true)
            if let index = selectedCellIndexPaths.firstIndex(of: indexPath) {
                selectedCellIndexPaths.remove(at: index)
            }else{
                selectedCellIndexPaths.append(indexPath)
            }
        }
    }
}
