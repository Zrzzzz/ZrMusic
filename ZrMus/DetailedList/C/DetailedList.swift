//
//  DetailedList.swift
//  ZrMus
//
//  Created by Zr埋 on 2020/1/30.
//  Copyright © 2020 Zr埋. All rights reserved.
//

import UIKit
import Alamofire

class DetailedList: UIViewController {
    
    var listId: Int!
    var tableView: UITableView!
    var alImgUrl: URL!
    var alName: String!
//    存储数据
    var lists: [List] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData(someClosure: closure)
        
    }
}

extension DetailedList {
    func getData(someClosure: @escaping () -> Void) {
        let url = "http://localhost:3000/playlist/detail?id=\(listId)"
        Alamofire.request(url).responseJSON { (d) in
            do {
                let datas = try JSONDecoder().decode(ListDetailGet.self, from: d.data!)
                print("详情获取成功")
                
                self.alName = datas.playlist.name
                self.alImgUrl = URL(string: datas.playlist.coverImgURL)
                for track in datas.playlist.tracks {
                    let list = List(
                        id: track.id, name: track.name, arName: track.ar[0].name, alName: track.al.name, picImg: track.al.picURL
                    )
                    self.lists.append(list)
                }
            } catch {
                print(error)
                print("详情获取失败")
            }
        }
    }
    
    func closure() {
         tableView = UITableView(frame: UIScreen.main.bounds)
         view.addSubview(tableView)
    }
    
}

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
        let width = UIScreen.main.bounds.width
        switch indexPath.section {
        case 0:
            let cell = DLCell1()
            cell.imageView?.sd_setImage(with: alImgUrl, placeholderImage: UIImage(named: "default"))
            cell.selectionStyle = .none
            cell.nameLabel.text = alName
//            cell.downLoadBtn.addTarget(self, action: , for: <#T##UIControl.Event#>)
            
            return cell
        default:
            let reuseid = "dl"
            tableView.register(DLCell2.self, forCellReuseIdentifier: reuseid)
            var cell: DLCell2 = tableView.dequeueReusableCell(withIdentifier: reuseid) as! DLCell2
            if cell == nil {
                cell = DLCell2(style: .default, reuseIdentifier: reuseid)
            }
            cell.countLabel.text = String(indexPath.row + 1)
            cell.nameLabel.text = lists[indexPath.row].name
            cell.creatorLabel.text = "\(lists[indexPath.row].arName) - \(lists[indexPath.row].alName)"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}
