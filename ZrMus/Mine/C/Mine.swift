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
    let reuseID = "id"
    var localMusics: Int = 0
    
//    两种歌单类型
    var myLists: [SongList] = []
    var subscribedLists: [SongList] = []
    
//    这个用来判断列表是不是打开的
    var selectedCellIndexPaths: [IndexPath] = []
    
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
}
//MARK: - 数据管理
extension Mine {
    
    func getLocalMusic() {
        let manager = FileManager.default
        var url = manager.urls(for: .musicDirectory, in: .userDomainMask)[0] as URL
        url = url.appendingPathComponent("zrmusic")
        let contentOfPath = try? manager.contentsOfDirectory(atPath: url.path)
        localMusics = contentOfPath!.count
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
                    let list = SongList(name: playList.name, id: playList.id, imgUrl: URL(string: playList.coverImgURL)!, count: playList.trackCount, subscribed: playList.subscribed)
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
        let songlists = NSManagedObject(entity: entity! , insertInto: managedObjectContext)
//        Step3: 保存songlist到songlists
        songlists.setValue(songlist.name, forKey: "name")
        songlists.setValue(songlist.id, forKey: "id")
        songlists.setValue(songlist.imgUrl, forKey: "imgUrl")
        songlists.setValue(songlist.count, forKey: "count")
        songlists.setValue(songlist.subscribed, forKey: "subscribed")
//        Step4: 保存entity到托管对象中；如果保存失败抛出异常
        do {
            try managedObjectContext.save()
        } catch {
            fatalError("无法保存")
        }
    }
    
    func translateData(obj: NSManagedObject) -> (SongList?) {
        if let name = obj.value(forKey: "name"), let id = obj.value(forKey: "id"), let count = obj.value(forKey: "count"), let imgUrl = obj.value(forKey: "imgUrl"), let subscribed = obj.value(forKey: "subscribed") {
            let songlist = SongList(name: name as! String, id: id as! Int, imgUrl: imgUrl as! URL, count: count as! Int, subscribed: subscribed as! Bool)
            return songlist
        }
        return nil
    }
}
//MARK: - TableView协议
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
                    return CGFloat(80 + count1 * 80)
                default:
                    return CGFloat(80 + count2 * 80)
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
            cell.countLabel.text = "(\(localMusics))"
            return cell
        default:
//            分类解析
            switch indexPath {
//                IndexPath为[, ]形式，前面是section，后面是row
            case [1, 0]:
//                设定分类
                let cell = listsCell(count: myLists.count, style: .default, reuseIdentifier: "cell1")
//                弄一个添加歌单的按钮
                let newListBtn = UIButton()
                newListBtn.setImage(UIImage(named: "mine_new_list"), for: .normal)
                newListBtn.addTarget(self, action: #selector(newList), for: .touchUpInside)
                cell.contentView.addSubview(newListBtn)
                newListBtn.snp.makeConstraints { (make) in
                    make.width.height.equalTo(30)
                    make.right.equalTo(cell.listsCountLabel.snp.left).offset(-5)
                    make.centerY.equalTo(cell.listsCountLabel.snp.centerY)
                }
                cell.titleLabel.text = "创建歌单"
//                箭头方向
                if selectedCellIndexPaths.contains(indexPath) {
                    cell.arrowImg.image = UIImage(named: "lC_arrow_down")?.withRenderingMode(.alwaysOriginal)
                } else {
                    cell.arrowImg.image = UIImage(named: "lC_arrow_right")?.withRenderingMode(.alwaysOriginal)
                }
//                描绘cell
                cell.listsCountLabel.text = "(\(myLists.count))"
                cell.reloadData(lists: myLists)
                
                
                return cell

            default:
//                设定分类
                let cell = listsCell(count: subscribedLists.count, style: .default, reuseIdentifier: "cell2")
                cell.titleLabel.text = "收藏歌单"
//                箭头方向
                if selectedCellIndexPaths.contains(indexPath) {
                    cell.arrowImg.image = UIImage(named: "lC_arrow_down")?.withRenderingMode(.alwaysOriginal)
                } else {
                    cell.arrowImg.image = UIImage(named: "lC_arrow_right")?.withRenderingMode(.alwaysOriginal)
                }
//                描绘cell
                cell.listsCountLabel.text = "(\(subscribedLists.count))"
                cell.reloadData(lists: subscribedLists)
                
                
                return cell
            }
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 0:
            tableView.deselectRow(at: indexPath, animated: true)
            navigationController?.pushViewController(LocalMusic(), animated: true)
        default:
            tableView.deselectRow(at: indexPath, animated: true)
            if let index = selectedCellIndexPaths.firstIndex(of: indexPath) {
                selectedCellIndexPaths.remove(at: index)
            }else{
                selectedCellIndexPaths.append(indexPath)
            }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
}
