//
//  Comment.swift
//  ZrMus
//
//  Created by Zr埋 on 2020/2/9.
//  Copyright © 2020 Zr埋. All rights reserved.
//

import UIKit
import Alamofire

class Comment: UITableViewController {
    
    var songId: Int!
    var commentList: [CComment] = []
    
    let width = UIScreen.main.bounds.width

    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
    }
}

//MARK: - 数据管理
extension Comment {
    func getData() {
        let timestamp = Int(Date().timeIntervalSince1970)
        Alamofire.request(URL(string: "http://localhost:3000/comment/music?id=\(songId!)&limit=1&timestamp=\(timestamp)")!).responseJSON { (d) in
            do {
                let datas = try JSONDecoder().decode(CommentGet.self, from: d.data!)
                self.commentList = datas.hotComments!
                self.tableView.reloadData()
            } catch {
                print(error)
                print("评论获取失败")
            }
        }
    }
}

//MARK: - TableView协议
extension Comment {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentList.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70 + getSuitableHeight(text: commentList[indexPath.row].content!, fontSize: 14, fontWeight: .bold, setWidth: width - 90)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellid = "commentid"
        let comment = commentList[indexPath.row]
        tableView.register(CommentCell.self, forCellReuseIdentifier: cellid)
        let cell: CommentCell = tableView.dequeueReusableCell(withIdentifier: cellid) as! CommentCell
        cell.avatarImg.sd_setImage(with: URL(string: (comment.user?.avatarUrl)!), completed: nil)
        cell.nicknameLabel.text = comment.user?.nickname!
        cell.timeLabel.text = timeTrans(num: comment.time!)
        cell.contentLabel.frame.size = CGSize(width: width - 90, height: getSuitableHeight(text: comment.content!, fontSize: 14, fontWeight: .bold, setWidth: width - 90))
        cell.contentLabel.text = comment.content!
        cell.likedCountLabel.text = String(describing: comment.likedCount!)
        cell.likedCountLabel.textColor = comment.liked! ? .red : .black
        //这里为了方便传数据,就把tag变了一下
        cell.likedCountLabel.tag = comment.commentId!
        let color: UIColor = comment.liked! ? .red : .black
        cell.likeBtn.setImage(UIImage(named: "cmt_like")?.withTintColor(color, renderingMode: .automatic), for: .normal)
        cell.likeBtn.addTarget(self, action: #selector(zan(sender:)), for: .touchUpInside)
        cell.likeBtn.tag = comment.liked! ? 1 : 0
        
        return cell
    }
}

extension Comment {
    func getSuitableHeight(text: String, fontSize: CGFloat, fontWeight: UIFont.Weight, setWidth: CGFloat) -> CGFloat {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: setWidth, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
        label.text = text

        label.sizeToFit()
        return label.bounds.height
    }
    
    func timeTrans(num: Int) -> String {
        //时间戳, 而且这个是毫秒级
        let timeStamp = num / 1000
        //转换为时间
        let timeInterval:TimeInterval = TimeInterval(timeStamp)
        let date = NSDate(timeIntervalSince1970: timeInterval)
        //格式化输出
        let dformatter = DateFormatter()
        dformatter.dateFormat = "yyyy年MM月dd日"
//        这是年份的后两位
        let y = dformatter.string(from: date as Date)
        return y
    }
    
    @objc func zan(sender: UIButton) {
        if sender.tag == 0 {
            sender.tag = 1
            sender.setImage(UIImage(named: "cmt_like")?.withTintColor(.red, renderingMode: .automatic), for: .normal)
            let cell: CommentCell = sender.superView(of: CommentCell.self)!
            cell.likedCountLabel?.textColor = .red
            let count = Int(cell.likedCountLabel.text!)! + 1
            cell.likedCountLabel.text = String(describing: count)
            let timestamp = Int(Date().timeIntervalSince1970)
            Alamofire.request(URL(string: "http://localhost:3000/comment/like?id=\(songId!)&cid=\(cell.likedCountLabel.tag)&t=\(sender.tag)&type=0&timestamp=\(timestamp)")!)
            cell.likedCountLabel.reloadInputViews()
        } else {
            sender.tag = 0
            sender.setImage(UIImage(named: "cmt_like")?.withTintColor(.black, renderingMode: .automatic), for: .normal)
            let cell: CommentCell = sender.superView(of: CommentCell.self)!
            cell.likedCountLabel?.textColor = .black
            let count = Int(cell.likedCountLabel.text!)! - 1
            cell.likedCountLabel.text = String(describing: count)
            let timestamp = Int(Date().timeIntervalSince1970)
            Alamofire.request(URL(string: "http://localhost:3000/comment/like?id=\(songId!)&cid=\(cell.likedCountLabel.tag)&t=\(sender.tag)&type=0&timestamp=\(timestamp)")!)
            cell.likedCountLabel.reloadInputViews()
        }
    }
}
