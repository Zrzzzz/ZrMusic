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

//    组件
    
    var searchController: UISearchController!
    
    var songPlayer: STKAudioPlayer!
    var songId: Int!
    var titleLabel: UILabel!
    var creatorLabel: UILabel!
    var imgView: UIImageView!
    var preBtn: UIButton!
    var nextBtn: UIButton!
    var loopBtn: UIButton!
    var commentBtn: UIButton!
//    pause&resume
    var prBtn: UIButton!
//    时间
    var ltimeLabel: UILabel!
    var rtimeLabel: UILabel!
//    进度条
    var slider: UISlider!
//    播放列表
    var songQueue: [Song] = [] {
        didSet {
            tableView?.reloadData()
        }
    }
    var tableView: UITableView?
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
//MARK: - didLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        drawUI()
        drawPlayer()
        dbDeleteAll()
    }
    //MARK: - willAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
//        判断登录状态
        isRegistered()
    }
}
//MARK: - UI相关
extension Player: UISearchControllerDelegate {
    func isRegistered() {
        let userid = UserDefaults.standard.value(forKey: "uid")
        if userid == nil {
            navigationController?.pushViewController(Login(), animated: true)
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: .plain, target: self, action: #selector(removeData))
        } else {
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    func drawUI() {
        view.backgroundColor = .white
        
        let resultsTableViewController = SearchResults()
        
        searchController = UISearchController(searchResultsController: resultsTableViewController)
        searchController.delegate = self
        searchController.searchResultsUpdater = resultsTableViewController
        definesPresentationContext = true
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = "不搜了"
        searchController.searchBar.delegate = resultsTableViewController
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "搜索想听的音乐"
        searchController.searchBar.sizeToFit()
        
        navigationItem.titleView = searchController.searchBar

        
        titleLabel = ZrLabel(y: 100, width: 200, height: 40)
        titleLabel.fontSuitToFrame()
        view.addSubview(titleLabel)
        
        creatorLabel = ZrLabel(y: 150, width: 200, height: 25)
        creatorLabel.fontSuitToFrame()
        view.addSubview(creatorLabel)
        
        imgView = UIImageView(frame: ZrRect(y: 200, width: 150, height: 150))
        view.addSubview(imgView)
        
        prBtn = UIButton()
        prBtn.setImage(UIImage(systemName: "play.circle")?.withRenderingMode(.alwaysTemplate), for: .normal)
        prBtn.addTarget(self, action: #selector(pasueorResume), for:  .touchUpInside)
        view.addSubview(prBtn)
        prBtn.snp.makeConstraints { (make) in
            make.top.equalTo(imgView.snp.bottom).offset(5)
            make.width.height.equalTo(30)
            make.centerX.equalTo(view.snp.centerX)
        }
        
        nextBtn = UIButton()
        nextBtn.setImage(UIImage(systemName: "forward.end")?.withRenderingMode(.alwaysTemplate), for: .normal)
        nextBtn.addTarget(self, action: #selector(nextSong), for: .touchUpInside)
        view.addSubview(nextBtn)
        nextBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(30)
            make.right.equalTo(prBtn.snp.left).offset(-10)
            make.centerY.equalTo(prBtn.snp.centerY)
        }
        
        preBtn = UIButton()
        preBtn.setImage(UIImage(systemName: "backward.end")?.withRenderingMode(.alwaysTemplate), for: .normal)
        preBtn.addTarget(self, action: #selector(preSong), for: .touchUpInside)
        view.addSubview(preBtn)
        preBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(30)
            make.right.equalTo(nextBtn.snp.left).offset(-10)
            make.centerY.equalTo(prBtn.snp.centerY)
        }
        
        loopBtn = UIButton()
        loopBtn.setImage(UIImage(systemName: "repeat.1")?.withRenderingMode(.alwaysTemplate), for: .normal)
        loopBtn.addTarget(self, action: #selector(loopSwitch), for: .touchUpInside)
        view.addSubview(loopBtn)
        loopBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(30)
            make.left.equalTo(prBtn.snp.right).offset(10)
            make.centerY.equalTo(prBtn.snp.centerY)
        }

        commentBtn = UIButton()
        commentBtn.setImage(UIImage(systemName: "text.bubble")?.withRenderingMode(.alwaysTemplate), for: .normal)
        commentBtn.addTarget(self, action: #selector(showComment), for: .touchUpInside)
        view.addSubview(commentBtn)
        commentBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(30)
            make.left.equalTo(loopBtn.snp.right).offset(10)
            make.centerY.equalTo(prBtn.snp.centerY)
        }
        
        slider = UISlider(frame: ZrRect(y: 400, width: 250, height: 30))
        view.addSubview(slider)
        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        slider.addTarget(self, action: #selector(sliderTouchin), for: .touchDown)
        slider.addTarget(self, action: #selector(sliderTouchout), for: .touchUpInside)
        slider.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(sliderTapped(gR:))))
//        这里使用NiceGesture实现了简单的手势方法
        slider.newPanGesture().whenChanged { (pan) in
            let pointTapped: CGPoint = pan.location(in: self.view)
            let positionOfSlider: CGPoint = self.slider.frame.origin
            let widthOfSlider: CGFloat = self.slider.frame.size.width
            let newValue = ((pointTapped.x - positionOfSlider.x) * CGFloat(self.slider.maximumValue) / widthOfSlider)
            self.slider.setValue(Float(newValue), animated: true)
            self.ltimeLabel.text = self.timeVert(self.songPlayer.progress)
            self.songPlayer.seek(toTime: Double(self.slider.value))
        }
        
        ltimeLabel = UILabel(frame: ZrRect(xOffset: -155, y: 400, width: 50, height: 30))
        ltimeLabel.fontSuitToFrame()
        view.addSubview(ltimeLabel)

        rtimeLabel = UILabel(frame: ZrRect(xOffset: 155, y: 400, width: 50, height: 30))
        rtimeLabel.fontSuitToFrame()
        view.addSubview(rtimeLabel)
        
        tableView = UITableView(frame: ZrRect(y: view.bounds.height / 2, width: view.bounds.width - 30, height: view.bounds.height / 2 - 100))
        tableView?.delegate = self
        tableView?.dataSource = self
        view.addSubview(tableView!)
    }
    
    func drawPlayer() {
        
        //设置进度条相关属性
        slider!.minimumValue = 0
        slider!.isContinuous = true
        
        //重置播放器
        resetAudioPlayer()
        
        //设置一个定时器，每0.1秒钟滚动一次
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
        if isLoop {
            curIndex = (curIndex + 1) % songQueue.count
        } else {
            curIndex = curIndex + 1
        }
        playWithQueue(queue: songQueue, index: curIndex)
    }
    
//    上一曲
    @objc func preSong() {
        if isLoop {
            curIndex = max(0, curIndex - 1)
        } else {
            curIndex = curIndex - 1
        }
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
    
    @objc func sliderTouchin() {
        songPlayer.pause()
    }
    
    @objc func sliderValueChanged() {
//        播放器定位
        ltimeLabel.text = timeVert(songPlayer.progress)
        songPlayer.seek(toTime: Double(slider.value))
    }
    
    @objc func sliderTouchout() {
        songPlayer.resume()
    }
    
    @objc func sliderTapped(gR: UIGestureRecognizer) {
        let pointTapped: CGPoint = gR.location(in: self.view)
        let positionOfSlider: CGPoint = slider.frame.origin
        let widthOfSlider: CGFloat = slider.frame.size.width
        let newValue = ((pointTapped.x - positionOfSlider.x) * CGFloat(slider.maximumValue) / widthOfSlider)
        slider.setValue(Float(newValue), animated: true)
        ltimeLabel.text = timeVert(songPlayer.progress)
        songPlayer.seek(toTime: Double(slider.value))
    }
    
//    定时器响应，更新进度条和时间
    @objc func tick() {
//        刷新一下queue的数据
        dbRefreshData()
//        不然歌都没法删了
//        tableView?.reloadData()
//        如果是停止播放就开始播放
        if state == .stopped {
            playWithQueue(queue: songQueue, index: 0)
        }
        if state == .playing {
//            更新进度条进度值
            slider.value = Float(songPlayer.progress)
            let curTime = timeVert(songPlayer.progress)
            let totolTime = timeVert(songPlayer.duration)
//            更新时间
            self.ltimeLabel.text = curTime
            self.rtimeLabel.text = totolTime
        }
    }
    
    @objc func loopSwitch() {
        isLoop = isLoop ? false : true
        loopBtn.setImage(UIImage(systemName: isLoop ? "repeat" : "repeat.1"), for: .normal)
    }
    
    @objc func showComment() {
        if !songQueue.isEmpty {
            let vc = Comment()
            vc.songId = songQueue[curIndex].id
            navigationController?.pushViewController(vc, animated: true)
        } else {
            let alert = UIAlertController(title: "警告⚠️", message: "没有正在播放的歌曲", preferredStyle: .alert)
            let known = UIAlertAction(title: "知道了", style: .default, handler: nil)
            alert.addAction(known)
            
            self.present(alert, animated: true)
        }
    }
}
//MARK: - 数据管理
extension Player {
    func dbRefreshData() {
        let context = db.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Music")
        do {
            if let results = try context.fetch(request) as? [NSManagedObject] {
                guard !results.isEmpty else {
                    return
                }
//              判断是否要优先播放
                if let song = translateData(obj: results[results.count - 1]) {
                    if !songQueue.isEmpty && !songQueue.contains(where: {
                        $0.id == song.id
                    })
                    {
                        if song.id != songQueue[0].id && song.isFirst == true {
                            songQueue.insert(song, at: 0)
                            curIndex = 0
                            playWithQueue(queue: songQueue, index: curIndex)
                        }
                    }
                }
                for result in results {
                    guard let song = translateData(obj: result) else { return }
//                    判断歌曲是否已经添加
                    if !songQueue.contains(where: {
                        $0.id == song.id
                    }) {
                        songQueue.append(song)
                    }
                }
            }
        } catch {
            fatalError("获取失败")
        }
    }
    
    func dbDeleteAll() {
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
    
    func dbDeleteSong(songId: Int) {
        let context = db.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Music")
        do {
            if let results = try context.fetch(request) as? [NSManagedObject] {
                for result in results {
                    guard let song = translateData(obj: result) else {
                        return
                    }
                    if song.id == songId {
                        context.delete(result)
                    }
                }
                try context.save()
            }
        } catch {
            fatalError("获取失败")
        }
    }
    
    func translateData(obj: NSManagedObject) -> Song? {
        let name = obj.value(forKey: "name") ?? ""
        let alname = obj.value(forKey: "alname") ?? ""
        let arname = obj.value(forKey: "arname") ?? ""
        let imgUrl = obj.value(forKey: "imgUrl") ?? URL(string: "nil")
        let isFirst = obj.value(forKey: "isFirst") ?? false
        if let id = obj.value(forKey: "id") {
            let song = Song(id: (id as! Int), name: name as! String, arName: arname as! String, alName: alname as! String, url: URL(string: "https://music.163.com/song/media/outer/url?id=\(id).mp3"), imgUrl: (imgUrl as! URL), isFirst: isFirst as? Bool)
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
    func playWithQueue(queue: [Song], index: Int = 0, insertedList: Bool = false) {
        guard index >= 0 && index < queue.count else {
            stop()
            dbDeleteAll()
            return
        }
        
        let url = queue[index].url
        songPlayer.play(url!)
        if insertedList {
            self.songQueue = queue
            //        清空queue
            songPlayer.clearQueue()
            for i in 1..<queue.count {
                songPlayer.queue(queue[Int((index + i) % queue.count)].url!)
            }
            curIndex = index
            isLoop = false
        }
        
    }
    
//    停止播放
    func stop() {
        songPlayer.stop()
        state = .stopped
        songQueue.removeAll()
        curIndex = -1
        infoUpdate()
        tableView?.reloadData()
    }
    
//    计算时间
    func timeVert(_ time: Double) -> String {
        let all:Int=Int(time)
        let m:Int=all % 60
        let f:Int=Int(all/60)
        var time:String=""
        if f<10{
            time="0\(f):"
        }else {
            time="\(f):"
        }
        if m<10{
            time+="0\(m)"
        }else {
            time+="\(m)"
        }
        return time
    }
//    更新当前播放信息
    func infoUpdate() {
        if curIndex >= 0 {
            let song = songQueue[curIndex]
//            更新信息
            titleLabel.text = song.name
            titleLabel.fontSuitToFrame()
            creatorLabel.text = "\(song.arName) - \(song.alName)"
            creatorLabel.fontSuitToFrame()
            imgView.sd_setImage(with: song.imgUrl, placeholderImage: UIImage(named: "default"))
//            进度条信息
            slider.maximumValue = Float(songPlayer.duration)
        } else {
            titleLabel.text = "没有歌曲"
            titleLabel.fontSuitToFrame()
            creatorLabel.text = " - "
            creatorLabel.fontSuitToFrame()
            slider.value = 0
            ltimeLabel.text = "00:00"
            rtimeLabel.text = "--:--"
            imgView.image = UIImage(named: "default")
            isLoop = false
            loopBtn.setImage(UIImage(systemName: "repeat.1")?.withRenderingMode(.alwaysTemplate), for: .normal)
        }
    }
}

// MARK: - Player协议
extension Player: STKAudioPlayerDelegate {
    
//    开始播放歌曲
    func audioPlayer(_ audioPlayer: STKAudioPlayer, didStartPlayingQueueItemId queueItemId: NSObject) {
        if let index = (songQueue.firstIndex { $0.url == (queueItemId as! URL)}) {
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
            tableView?.reloadData()
            infoUpdate()
        }
    }
//    播放结束
    func audioPlayer(_ audioPlayer: STKAudioPlayer, didFinishPlayingQueueItemId queueItemId: NSObject, with stopReason: STKAudioPlayerStopReason, andProgress progress: Double, andDuration duration: Double) {
//        if let index = (songQueue.firstIndex {
//            $0.url == audioPlayer.currentlyPlayingQueueItemId() as? URL
//        }) {
//            curIndex = index
//        }
        
        
        if stopReason == .eof {
            nextSong()
        } else if stopReason == .error {
            stop()
            resetAudioPlayer()
        }
        
        
    }
    
    func audioPlayer(_ audioPlayer: STKAudioPlayer, unexpectedError errorCode: STKAudioPlayerErrorCode) {
        print(errorCode)
        let alert = UIAlertController(title: "该歌曲无法播放！", message: "放弃吧", preferredStyle: .alert)
        let known = UIAlertAction(title: "我知道了", style: .default, handler: nil)
        alert.addAction(known)
        self.present(alert, animated: true)
        self.nextSong()
        guard state != .stopped else { return }
        let index = curIndex == 0 ? songQueue.count - 1 : curIndex - 1
        self.dbDeleteSong(songId: self.songQueue[index].id!)
        self.songQueue.remove(at: index)
        self.tableView?.deleteRows(at: [[0, index]], with: .fade)
    }
}

extension Player: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songQueue.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellid = "ZrMusic.Player.list"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellid)
        let cell = tableView.dequeueReusableCell(withIdentifier: cellid)
        if curIndex == indexPath.row {
            cell?.backgroundColor = ZrColor(r: 251, g: 185, b: 87)
        } else {
            cell?.backgroundColor = .clear
        }
        cell?.textLabel?.text = songQueue[indexPath.row].name
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row != curIndex {
            curIndex = indexPath.row
            playWithQueue(queue: songQueue, index: curIndex)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            dbDeleteSong(songId: songQueue[indexPath.row].id!)
            songQueue.remove(at: indexPath.row)
//            因为songQueue在改变时reload了,这时就不用delete了
//            tableView.deleteRows(at: [indexPath], with: .fade)
            if curIndex == indexPath.row && curIndex != songQueue.count {
                playWithQueue(queue: songQueue, index: curIndex)
            } else if curIndex == indexPath.row && curIndex == songQueue.count {
                curIndex -= 1
                playWithQueue(queue: songQueue, index: curIndex)
            }

        }
    }
}
