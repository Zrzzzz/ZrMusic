//
//  Comment.swift
//  ZrMus
//
//  Created by Zr埋 on 2020/2/9.
//  Copyright © 2020 Zr埋. All rights reserved.
//

import UIKit
import Alamofire

class Comment: UIViewController {
    
    var songId: Int!
    var commentList: [CComment] = []
    var commentView: UIView!
    var textView: UITextView!
    var sendBtn: UIButton!
    var tableView: UITableView!
    
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height

    override func viewDidLoad() {
        super.viewDidLoad()
        drawUI()
        getData()
    }
    
}

//MARK: - UI
extension Comment {
    func drawUI() {
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: width, height: height - 83))
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
        commentView = UIView()
        commentView.layer.cornerRadius = 20
        commentView.layer.masksToBounds = true
        commentView.layer.borderWidth = 2
        commentView.layer.borderColor = .init(srgbRed: 0, green: 0, blue: 0, alpha: 1)
        commentView.backgroundColor = .white
        view.addSubview(commentView)
        commentView.snp.updateConstraints { (make) in
            make.width.equalTo(width - 30)
            make.height.equalTo(70)
            make.top.equalTo(view.snp.bottom).offset(-83 - 90)
            make.centerX.equalTo(view.snp.centerX)
        }
        
        sendBtn = UIButton()
        commentView.addSubview(sendBtn)
        sendBtn.layer.cornerRadius = 5
        sendBtn.layer.masksToBounds = true
        sendBtn.backgroundColor = ZrColor(r: 194, g: 124, b: 136)
        sendBtn.setTitleColor(.black, for: .normal)
        sendBtn.setTitle("发送", for: .normal)
        sendBtn.addTarget(self, action: #selector(send), for: .touchUpInside)
        sendBtn.snp.updateConstraints { (make) in
            make.right.equalTo(commentView.snp.right).offset(-10)
            make.width.equalTo(50)
            make.height.equalTo(30)
            make.centerY.equalTo(commentView.snp.centerY)
        }
        
        textView = UITextView()
        commentView.addSubview(textView)
        textView.layer.borderColor = .init(srgbRed: 194 / 255, green: 124 / 255, blue: 136 / 255, alpha: 1)
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 20
        textView.delegate = self
        textView.layer.masksToBounds = true
        textView.returnKeyType = .done
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 5, right: 5)
        textView.font = .systemFont(ofSize: 18)
        textView.snp.updateConstraints { (make) in
            make.left.equalTo(commentView.snp.left).offset(10)
            make.centerY.equalTo(commentView.snp.centerY)
            make.width.equalTo(300)
            make.height.equalTo(40)
        }
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow(note:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDisappear(note:)), name: UIResponder.keyboardWillHideNotification, object: nil)
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


//MARK: - TableView协议, TextView协议
extension Comment: UITextViewDelegate, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70 + getSuitableHeight(text: commentList[indexPath.row].content!, fontSize: 14, fontWeight: .bold, setWidth: width - 90)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if let lineHeight = textView.font?.lineHeight {
            let nowSize = textView.sizeThatFits(CGSize(width: textView.bounds.width, height: lineHeight))
            let lines = floorf(Float(nowSize.height / lineHeight))
            if lines <= 5 {
                let addedHeight = lineHeight * CGFloat(lines - 1)
                commentView.snp.updateConstraints { (make) in
                    make.height.equalTo(70 + addedHeight)
                    make.top.equalTo(view.snp.bottom).offset(-83 - 90 - addedHeight)
                }
                textView.snp.updateConstraints { (make) in
                    make.height.equalTo(40 + addedHeight)
                }
            }
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text ==  "\n") {
            textView.resignFirstResponder()
            return false;
        }
        return true
    }
}

//MARK: - 一些方法
extension Comment {
    @objc func send() {
        textView.endEditing(true)
        let url = "http://localhost:3000/comment?t=1&type=0&id=\(songId!)&content=\(textView.text!)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        Alamofire.request(URL(string: url!)!)
        textView.text = ""
    }
    
    @objc func stopEditing(sender: UIGestureRecognizer) {
        let tappedPoint: CGPoint = sender.location(in: view)
        if tappedPoint.y < self.textView.frame.minY {
             self.textView.endEditing(true)
        }
    }
    
    @objc func keyboardShow(note: Notification)  {
            guard let userInfo = note.userInfo else {return}
        guard let keyboardRect = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else{return}
            UIView.animate(withDuration: 1) {
            self.commentView.transform = CGAffineTransform.init(translationX: 0, y: -keyboardRect.height + 83)
        }
    }
    @objc func keyboardDisappear(note: Notification)  {
        UIView.animate(withDuration: 1) {
            self.commentView.transform = CGAffineTransform.identity
        }
    }

    
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
            UIView.animate(withDuration: 0.5) {
                sender.imageView?.transform = CGAffineTransform.init(scaleX: 1.2, y: 1.2)
                sender.imageView?.transform = CGAffineTransform.identity
            }
        } else {
            sender.tag = 0
            sender.setImage(UIImage(named: "cmt_like")?.withTintColor(.black, renderingMode: .automatic), for: .normal)
            let cell: CommentCell = sender.superView(of: CommentCell.self)!
            cell.likedCountLabel?.textColor = .black
            let count = Int(cell.likedCountLabel.text!)! - 1
            cell.likedCountLabel.text = String(describing: count)
            let timestamp = Int(Date().timeIntervalSince1970)
            Alamofire.request(URL(string: "http://localhost:3000/comment/like?id=\(songId!)&cid=\(cell.likedCountLabel.tag)&t=\(sender.tag)&type=0&timestamp=\(timestamp)")!)
        }
    }
}
