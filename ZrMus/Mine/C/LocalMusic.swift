//
//  LocalMusic.swift
//  ZrMus
//
//  Created by Zr埋 on 2020/2/8.
//  Copyright © 2020 Zr埋. All rights reserved.
//

import UIKit
import CoreData

class LocalMusic: UITableViewController {
    
    var songList: [Song] = []
    
    let db = DataBase.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        getMusic()
    }
}

extension LocalMusic {
    func getMusic() {
        let manager = FileManager.default
        var url = manager.urls(for: .musicDirectory, in: .userDomainMask)[0] as URL
        url = url.appendingPathComponent("zrmusic")
        let contentOfPath = try? manager.contentsOfDirectory(atPath: url.path)
        if let array = contentOfPath {
            print(" - LocalSongsCount: \(array.count)")
            for i in array {
                let arr = i.components(separatedBy: "-")
                let id = Int(arr[3].components(separatedBy: ".")[0])
                let name = arr[0]
                let arname = arr[1]
                let alname = arr[2]
                let url = URL(string: "https://music.163.com/song/media/outer/url?id=\(id).mp3")
                let song = Song(id: id, name: name, arName: arname, alName: alname, url: url, imgUrl: nil, isFirst: nil, isOK: nil)
                songList.append(song)
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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songList.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellid = "hhh"
        tableView.register(ResultCell.self, forCellReuseIdentifier: cellid)
        let cell: ResultCell = tableView.dequeueReusableCell(withIdentifier: cellid) as! ResultCell
        cell.nameLabel.text = songList[indexPath.row].name
        cell.creatorLabel.text = "\(songList[indexPath.row].arName)-\(songList[indexPath.row].alName)"
        cell.addBtn.removeFromSuperview()
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        addData(song: songList[indexPath.row], isFirst: true)
    }
}

