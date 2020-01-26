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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        
        
        
        
    }
    
    
}

extension Mine {
    
    func drawUI() {
        tableView = UITableView(frame: CGRect(x: 0, y: 70, width: width, height: height - 70))
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func getData() {
        Alamofire.request("http://localhost:3000/user/playlist?uid=\(String(describing: ud.string(forKey: "zrzz")))").responseJSON { (d) in
            do {
                let datas = try JSONDecoder().decode(SongListGet.self, from: d.data!)
                print("获取歌单成功")
                let playLists = datas.playlist
                var listCountArr: [Int] = []
                var imgArr: [URL] = []
                var nameArr: [String] = []
                var idArr: [String] = []
                for playList in playLists {
                    listCountArr.append(playList.playCount)
                    imgArr.append(URL(string: playList.coverImgURL)!)
                    nameArr.append(playList.name)
                    idArr.append(playList.id)
                }
                var listArr: [Array<Any>] = [listCountArr, imgArr, nameArr, idArr]
                
            } catch {
                print("获取歌单失败")
            }
        }
    }
    
    func save(_ sth: Any) {
//        Step1: 获取托管对象总管
        let managedObjectContext = db.persistentContainer.viewContext
//        Step2: 建立一个entity
        let entity = NSEntityDescription.entity(forEntityName: <#T##String#>, in: <#T##NSManagedObjectContext#>)
    }
    
    func getAll() ->
}

extension Mine: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 1:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 1:
            return 80
        default:
            return 80
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 1:
            let cell = ncCell()
            cell.leftView.image = UIImage(named: "mine_music")
            cell.titilLabel.text = "本地音乐"
            cell.countLabel.text = "(0)"
            return cell
        default:
            tableView.register(listCell.self, forCellReuseIdentifier: reuseID)
            var cell = tableView.dequeueReusableCell(withIdentifier: reuseID)
            if cell == nil {
                cell = listCell(style: .default, reuseIdentifier: reuseID)
                
        }
            return cell!
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        <#code#>
    }
}
