//
//  SearchResults.swift
//  ZrMus
//
//  Created by Zr埋 on 2020/2/5.
//  Copyright © 2020 Zr埋. All rights reserved.
//

import UIKit
import Alamofire
import CoreData

class SearchResults: UITableViewController, UISearchBarDelegate{
    
//    组件
    let db = DataBase.shared
    
    var songList: [Song] = [Song]() {
        didSet {
            tableView.reloadData()
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

//MARK: - 刷新搜索栏数据
extension SearchResults: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        var url = "http://localhost:3000/search?keywords=\(searchController.searchBar.text ?? "")&limit=20"
        url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        if searchController.searchBar.text! != "" {
            Alamofire.request(url).responseJSON { (d) in
                do {
                    self.songList.removeAll()
                    let datas = try JSONDecoder().decode(SearchGet.self, from: d.data!)
                    if let songs = datas.result?.songs {
                        for song in songs {
                            var s = Song(id: song.id ?? 0, name: song.name ?? "", arName: song.artists?[0].name ?? "", alName: song.album?.name ?? "", url: URL(string: "https://music.163.com/song/media/outer/url?id=\(song.id ?? 0).mp3"), imgUrl: nil, isFirst: true)
//                            获取一下imgUrl, 实际上用的album的api
                            Alamofire.request(URL(string: "http://localhost:3000/album?id=\((song.album?.id)!)")!).responseJSON { (d) in
                                do {
                                    let datas = try JSONDecoder().decode(CoverImgGet.self, from: d.data!)
                                    
                                    s.imgUrl = URL(string: (datas.album?.picUrl!)!)
                                    self.songList.append(s)
                                } catch {
                                    print(error)
                                    print("个人信息获取失败")
                                }
                            }
                        }
                    }
                } catch {
                    print(error)
                    print("个人信息获取失败")
                }
            }
        }
    }
}

//MARK: - TableView协议
extension SearchResults {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songList.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellid = "hhwdwa"
        tableView.register(ResultCell.self, forCellReuseIdentifier: cellid)
        let cell: ResultCell = tableView.dequeueReusableCell(withIdentifier: cellid) as! ResultCell
        cell.nameLabel.text = songList[indexPath.row].name
        cell.creatorLabel.text = "\(songList[indexPath.row].arName)-\(songList[indexPath.row].alName)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        addData(song: songList[indexPath.row], isFirst: true)
    }
    
    
}

//MARK: - 数据保存
extension SearchResults {
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
