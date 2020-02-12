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
import CryptoSwift

class Mine: UIViewController {
    
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    var tableView: UITableView!
    let ud = UserDefaults.standard
    let db = DataBase.shared
    let cellid = "cellid"
    var localMusics: Int = 0
    
//    两种歌单类型
    var myLists: [SongList] = []
    var subscribedLists: [SongList] = []
    
//    这个用来判断列表是不是打开的, 默认打开
    var selectedCellIndexPaths: [Int] = [1, 2]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        drawUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        deleteData()
        let userid = UserDefaults.standard.value(forKey: "uid")
        if userid != nil {
            getData {
                self.getDbData()
                self.getLocalMusic()
                self.tableView.reloadData()
            }
        } else {
            self.tableView.reloadData()
        }
    }
}
//MARK: - UI相关 & 按钮方法
extension Mine {
    
    func drawUI() {
        tableView = UITableView(frame: UIScreen.main.bounds)
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.register(ListCell.self, forCellReuseIdentifier: cellid)
    }
    
    @objc func newList() {
        let alert = UIAlertController(title: "新建歌单", message: "请输入歌单名称", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "保存", style: .default) { (action :UIAlertAction!) in
            let textFieldText = (alert.textFields![0] as UITextField).text!
            let url = "http://localhost:3000/playlist/create?name=\(textFieldText)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            Alamofire.request(URL(string: url!)!).response { _ in
                self.deleteData()
                self.getData {
                    self.getDbData()
                    self.tableView.reloadData()
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        alert.addTextField { (textField: UITextField) in
            
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func fold(sender: UIButton) {
        let section = sender.tag
        if selectedCellIndexPaths.contains(section) {
            selectedCellIndexPaths.removeAll { (int) -> Bool in
                int == section
            }
        }else{
            selectedCellIndexPaths.append(section)
        }
        tableView.reloadSections(IndexSet(integer: section), with: .fade)
    }
}
//MARK: - 数据管理
extension Mine {
    
    func getLocalMusic() {
        let manager = FileManager.default
        var url = manager.urls(for: .musicDirectory, in: .userDomainMask)[0] as URL
        url = url.appendingPathComponent("zrmusic")
        let contentOfPath = try? manager.contentsOfDirectory(atPath: url.path)
        localMusics = contentOfPath?.count ?? 0
    }
    
    func getData(someCloure: @escaping() -> Void) {
//        清空数据
        deleteData()
        guard let id = ud.string(forKey: "uid") else {
            return
        }
        let timestamp = Int(Date().timeIntervalSince1970)
        Alamofire.request("http://localhost:3000/user/playlist?uid=\(id)&timestamp=\(timestamp)").responseJSON { (d) in
            do {
                let datas = try JSONDecoder().decode(SongListGet.self, from: d.data!)
                print("获取歌单成功")
                let playLists = datas.playlist
                
                
                for playList in playLists {
                    let list = SongList(name: playList.name, id: playList.id, imgUrl: URL(string: playList.coverImgURL)!, count: playList.trackCount, subscribed: playList.subscribed, creator: playList.creator.nickname)
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
    
    func deleteData() {
//        Step1: 获取托管对象总管
        let managedObjectContext = db.persistentContainer.viewContext
//        Step2: 建立一个获取的请求
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SongLists")
//        Step3: 执行请求
        do {
            if let fetchedResults = try managedObjectContext.fetch(fetchRequest) as? [NSManagedObject] {
//                Step4: 删除数据
                for fetchedResult in fetchedResults {
                    managedObjectContext.delete(fetchedResult)
                }
                try managedObjectContext.save()
//                Step5: 更新数据
                myLists.removeAll()
                subscribedLists.removeAll()
            }
        } catch {
            fatalError("删除失败")
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
                    guard let songlist = translateData(obj: result) else { return }
                    if songlist.subscribed == false {
                        myLists.append(songlist)
                    } else {
                        subscribedLists.append(songlist)
                    }
                }
            }
        } catch {
            fatalError("获取失败")
        }
    }
    
    func saveList(_ songlist: SongList) {
//        Step1: 获取托管对象总管
        let managedObjectContext = db.persistentContainer.viewContext
//        Step2: 建立一个entity
        let entity = NSEntityDescription.entity(forEntityName: "SongLists", in: managedObjectContext)
        let newList = NSManagedObject(entity: entity! , insertInto: managedObjectContext)
//        Step3: 保存songlist到newList
        newList.setValue(songlist.name, forKey: "name")
        newList.setValue(songlist.id, forKey: "id")
        newList.setValue(songlist.imgUrl, forKey: "imgUrl")
        newList.setValue(songlist.count, forKey: "count")
        newList.setValue(songlist.subscribed, forKey: "subscribed")
        newList.setValue(songlist.creator, forKey: "creator")
//        Step4: 保存entity到托管对象中；如果保存失败抛出异常
        do {
            try managedObjectContext.save()
        } catch {
            fatalError("无法保存")
        }
    }
    
    func translateData(obj: NSManagedObject) -> (SongList?) {
        if let name = obj.value(forKey: "name"), let id = obj.value(forKey: "id"), let count = obj.value(forKey: "count"), let imgUrl = obj.value(forKey: "imgUrl"), let subscribed = obj.value(forKey: "subscribed"), let creator = obj.value(forKey: "creator") {
            let songlist = SongList(name: name as! String, id: id as! Int, imgUrl: imgUrl as! URL, count: count as! Int, subscribed: subscribed as! Bool, creator: creator as! String)
            return songlist
        }
        return nil
    }
}
//MARK: - TableView协议
extension Mine: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return selectedCellIndexPaths.contains(section) ? myLists.count : 0
        default:
            return selectedCellIndexPaths.contains(section) ? subscribedLists.count : 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        } else {
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return nil
        } else {
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 50))
            headerView.backgroundColor = .white
            
            let newListBtn = UIButton()
            newListBtn.setImage(UIImage(named: "mine_new_list"), for: .normal)
            newListBtn.addTarget(self, action: #selector(newList), for: .touchUpInside)
            headerView.addSubview(newListBtn)
            newListBtn.snp.makeConstraints { (make) in
                make.width.height.equalTo(30)
                make.centerY.equalTo(headerView.snp.centerY)
                make.right.equalTo(headerView.snp.right).offset(-10)
            }
            if section == 2 {
                newListBtn.removeFromSuperview()
            }
            
            let foldBtn = UIButton()
            let imgName = selectedCellIndexPaths.contains(section) ? "list_arrow_down" : "list_arrow_right"
            foldBtn.setImage(UIImage(named: imgName), for: .normal)
            foldBtn.tag = section
            headerView.addSubview(foldBtn)
            foldBtn.addTarget(self, action: #selector(fold(sender:)), for: .touchUpInside)
            foldBtn.snp.makeConstraints { (make) in
                make.left.equalTo(headerView.snp.left).offset(5)
                make.width.height.equalTo(30)
                make.centerY.equalTo(headerView.snp.centerY)
            }
            
            let label = UILabel()
            label.text = section == 1 ? "我的歌单  (\(myLists.count))" : "收藏歌单  (\(subscribedLists.count))"
            headerView.addSubview(label)
            label.snp.makeConstraints { (make) in
                make.centerY.equalTo(headerView.snp.centerY)
                make.left.equalTo(foldBtn.snp.right).offset(5)
                make.height.equalTo(30)
            }
            return headerView
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell: ListCell = tableView.dequeueReusableCell(withIdentifier: cellid) as! ListCell
            cell.imgView.image = UIImage(named: "mine_music")
            cell.nameLabel.text = "本地音乐"
            cell.creatorLabel.text = "\(localMusics)首歌"
            return cell
        default:
            let lists = indexPath.section == 1 ? myLists : subscribedLists
            let list = lists[indexPath.row]
            let cell: ListCell = tableView.dequeueReusableCell(withIdentifier: cellid) as! ListCell
            if !lists.isEmpty {
                cell.creatorLabel.text = indexPath.section == 1 ? "\(lists[indexPath.row].count)首歌" : "\(lists[indexPath.row].count)首歌, by \(list.creator)"
                cell.imgView.sd_setImage(with: lists[indexPath.row].imgUrl, placeholderImage: UIImage(named: "default"))
                cell.nameLabel.text = lists[indexPath.row].name
            }
            return cell
        }
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 0:
            tableView.deselectRow(at: indexPath, animated: true)
            navigationController?.pushViewController(LocalMusic(), animated: true)
        default:
            let vc = DetailedList()
            let lists = indexPath.section == 1 ? myLists : subscribedLists
            vc.listId = lists[indexPath.row].id
            self.navigationController?.present(vc, animated: true)
        }
    }
        
}
