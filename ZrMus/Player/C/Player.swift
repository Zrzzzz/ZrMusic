//
//  Player.swift
//  ZrMus
//
//  Created by Zr埋 on 2020/1/21.
//  Copyright © 2020 Zr埋. All rights reserved.
//

import UIKit
import Alamofire
import CoreData

class Player: UIViewController {
    
    static let shared = Player()

//    组件
    var songPlayer: STKAudioPlayer!
    var songId: Int!
    var titleLabel: UILabel!
    var creatorLabel: UILabel!
    var imgView: UIImageView!
    var preBtn: UIButton!
    var nextBtn: UIButton!
//    pause&resume
    var prBtn: UIButton!
//    时间
    var timeLabel: UILabel!
//    进度条
    var slider: UISlider!
//    播放列表
    var songQueue: [Song] = []
//    当前播放索引
    var curIndex: Int = -1
//    是否循环播放
    var isLoop: Bool = false
//    当前播放状态
    var state: STKAudioPlayerState = []
//    定时器
    var timer: Timer!
//    db
    let db = DataBase.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        //判断登录状态
        isRegistered()
        drawUI()
        drawPlayer()
        deleteAll()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
//        每次到此页面刷新一下queue的数据
        refreshData()
//        如果没有播放就开始播放
        playWithQueue(queue: songQueue, index: 0)
    }
}
//MARK: - UI相关
extension Player {
    func isRegistered() {
        let userid = UserDefaults.standard.string(forKey: "uid")
        if userid == nil {
            navigationController?.pushViewController(Login(), animated: true)
        }
    }
    
    func drawUI() {
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(removeData))
        
        titleLabel = ZrLabel(y: 100, width: 200, height: 40)
        titleLabel.fontSuitToFrame()
        view.addSubview(titleLabel)
        
        creatorLabel = ZrLabel(y: 150, width: 200, height: 30)
        view.addSubview(creatorLabel)
        
        imgView = UIImageView(frame: ZrRect(y: 200, width: 150, height: 150))
        view.addSubview(imgView)
        
        preBtn = UIButton(frame: ZrRect(xOffset: -50, y: 360, width: 30, height: 30))
        preBtn.setImage(UIImage(systemName: "backward.end")?.withRenderingMode(.alwaysTemplate), for: .normal)
        preBtn.addTarget(self, action: #selector(preSong), for: .touchUpInside)
        view.addSubview(preBtn)
        
        nextBtn = UIButton(frame: ZrRect(y: 360, width: 30, height: 30))
        nextBtn.setImage(UIImage(systemName: "forward.end")?.withRenderingMode(.alwaysTemplate), for: .normal)
        nextBtn.addTarget(self, action: #selector(nextSong), for: .touchUpInside)
        view.addSubview(nextBtn)
        
        prBtn = UIButton(frame: ZrRect(xOffset: 50, y: 360, width: 30, height: 30))
        prBtn.setImage(UIImage(systemName: "play.circle")?.withRenderingMode(.alwaysTemplate), for: .normal)
        prBtn.addTarget(self, action: #selector(pasueorResume), for: .touchUpInside)
        view.addSubview(prBtn)
        
        slider = UISlider(frame: ZrRect(xOffset: -40, y: 400, width: 100, height: 30))
        view.addSubview(slider)
        
        timeLabel = UILabel(frame: ZrRect(xOffset: 70, y: 400, width: 50, height: 30))
        timeLabel.fontSuitToFrame()
        view.addSubview(timeLabel)

    }
    
    func drawPlayer() {
        
        //设置进度条相关属性
        slider!.minimumValue = 0
        slider!.isContinuous = false
        
        //重置播放器
        resetAudioPlayer()
        
        //设置一个定时器，每三秒钟滚动一次
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self,
                    selector: #selector(tick), userInfo: nil, repeats: true)
    }
}
//MARK: - 按钮方法
extension Player {
    @objc func removeData() {
        UserDefaults.standard.set(nil, forKey: "uid")
        navigationController?.pushViewController(Login(), animated: true)
    }
//    播放
//    TODO: 实现列表置顶
    func play(song: Song) {
        songPlayer.play(song.url!)
    }
    
//    下一曲
    @objc func nextSong() {
        guard songQueue.count > 0 else { return }
        curIndex = (curIndex + 1) % songQueue.count
        playWithQueue(queue: songQueue, index: curIndex)
    }
    
//    上一曲
    @objc func preSong() {
        curIndex = max(0, curIndex - 1)
        playWithQueue(queue: songQueue, index: curIndex)
    }
    
//    pr按钮
    @objc func pasueorResume() {
        if self.state == .paused {
            songPlayer.resume()
            state = .playing
        } else {
            songPlayer.pause()
            state = .paused
        }
    }
    
    @objc func sliderValueChanged() {
//        播放器定位
        songPlayer.seek(toTime: Double(slider.value))
        
    }
}
//MARK: - 数据管理
extension Player {
    func refreshData() {
        let context = db.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Music")
        do {
            if let results = try context.fetch(request) as? [NSManagedObject] {
                for result in results {
                    guard let song = translateData(obj: result) else { return }
                    songQueue.append(song)
                }
            }
        } catch {
            fatalError("获取失败")
        }
    }
    
    func deleteAll() {
        let context = db.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Music")
        do {
            if let results = try context.fetch(request) as? [NSManagedObject] {
                for result in results {
                    context.delete(result)
                }
                try context.save()
            }
        } catch {
            fatalError("获取失败")
        }
    }
    
    func translateData(obj: NSManagedObject) -> Song? {
        if let id = obj.value(forKey: "id"), let name = obj.value(forKey: "name"), let alname = obj.value(forKey: "alname"), let arname = obj.value(forKey: "arname"), let imgUrl = obj.value(forKey: "imgUrl") {
            let song = Song(id: id as! Int, name: name as! String, arName: arname as! String, alName: alname as! String, url: URL(string: "https://music.163.com/song/media/outer/url?id=\(id).mp3"), imgUrl: imgUrl as! URL)
            return song
        }
        return nil
    }
}
// MARK: - 播放器组件
extension Player {
    
//    重置播放器
    func resetAudioPlayer() {
        var options = STKAudioPlayerOptions()
        options.flushQueueOnSeek = true
        options.enableVolumeMixer = true
        songPlayer = STKAudioPlayer(options: options)
        
        songPlayer.meteringEnabled = true
        songPlayer.volume = 1
        songPlayer.delegate = self
        
        infoUpdate()
    }
    
//    开始播放
    func playWithQueue(queue: [Song], index: Int = 0) {
        guard index >= 0 && index < queue.count else { return }
        self.songQueue = queue
//        清空queue
        songPlayer.clearQueue()
        let url = queue[index].url
        songPlayer.play(url!)
        
        for i in 1..<queue.count {
            songPlayer.queue(queue[Int((index + i) % queue.count)].url!)
        }
        curIndex = index
        isLoop = false
    }
    
//    停止播放
    func stop() {
        songPlayer.stop()
        songQueue.removeAll()
        curIndex = -1
    }
    
//    定时器响应，更新进度条和时间
    @objc func tick() {
        if state == .playing {
//            更新进度条进度值
            slider.value = Float(songPlayer.progress)
            let all:Int=Int(songPlayer.progress)
            let m:Int=all % 60
            let f:Int=Int(all/60)
            var time:String=""
            if f<10{
                time="0\(f):"
            }else {
                time="\(f)"
            }
            if m<10{
                time+="0\(m)"
            }else {
                time+="\(m)"
            }
//            更新时间
            self.timeLabel.text = time
        }
    }
    
//    更新当前播放信息
    func infoUpdate() {
        if curIndex >= 0 {
            let song = songQueue[curIndex]
//            更新信息
            titleLabel.text = song.name
            creatorLabel.text = "\(song.arName) - \(song.alName)"
            imgView.sd_setImage(with: song.imgUrl, placeholderImage: UIImage(named: "default"))
//            进度条信息
            slider.maximumValue = Float(songPlayer.duration)
        } else {
            titleLabel.text = "没有歌曲"
            creatorLabel.text = " - "
            slider.value = 0
            timeLabel.text = "--:--"
            imgView.image = UIImage(named: "default")
        }
    }
}

// MARK: - Player协议
extension Player: STKAudioPlayerDelegate {
    func audioPlayer(_ audioPlayer: STKAudioPlayer, didFinishPlayingQueueItemId queueItemId: NSObject, with stopReason: STKAudioPlayerStopReason, andProgress progress: Double, andDuration duration: Double) {
        if isLoop {
            curIndex = 0
        } else {
            curIndex = -1
            infoUpdate()
            stop()
        }
    }
    
    func audioPlayer(_ audioPlayer: STKAudioPlayer, unexpectedError errorCode: STKAudioPlayerErrorCode) {
        print(errorCode)
    }
    
    
//    开始播放歌曲
    func audioPlayer(_ audioPlayer: STKAudioPlayer, didStartPlayingQueueItemId queueItemId: NSObject) {
        if let index = (songQueue.firstIndex { $0.url == queueItemId as! URL}) {
            curIndex = index
        }
        
    }
    
//    缓冲完毕
    func audioPlayer(_ audioPlayer: STKAudioPlayer, didFinishBufferingSourceWithQueueItemId queueItemId: NSObject) {
        infoUpdate()
    }
//    播放状态变化
    func audioPlayer(_ audioPlayer: STKAudioPlayer, stateChanged state: STKAudioPlayerState, previousState: STKAudioPlayerState) {
        self.state = state
        if state != .stopped && state != .error && state != .disposed {
            infoUpdate()
        }
    }
    
    
}


