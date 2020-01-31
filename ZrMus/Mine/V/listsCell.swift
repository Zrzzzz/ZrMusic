//
//  listsCell.swift
//  ZrMus
//
//  Created by Zr埋 on 2020/1/25.
//  Copyright © 2020 Zr埋. All rights reserved.
//

import UIKit

class listsCell: UITableViewCell {
//    header
    var arrowImg: UIImageView!
    var titleLabel: UILabel!
    var listsCountLabel: UILabel!
    var addBtn: UIButton!//TODO: 这个之后再完善
    
    var listView: UITableView!
    var lists: [SongList] = []
    var listsCount: Int?
    let width = UIScreen.main.bounds.width
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        drawUI()
    }
    
    init(count: Int, style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.listsCount = count
        drawUI()
        self.contentView.addSubview(listView)
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension listsCell {
    func drawUI() {
//        需要启用来实现展开功能，这里卡了一会
//        应该使用clips剪裁超出frame的部分而不是使用layer的mask
//        self.layer.masksToBounds = true
        self.clipsToBounds = true

        arrowImg = UIImageView(frame: CGRect(x: 5, y: 5, width: 70, height: 70))
        contentView.addSubview(arrowImg)
        
        titleLabel = UILabel(frame: CGRect(x: 60, y: 5, width: 150, height: 70))
        contentView.addSubview(titleLabel)
        titleLabel.font = .boldSystemFont(ofSize: 20)
        titleLabel.textAlignment = .center
        titleLabel.adjustsFontSizeToFitWidth = true
        
        listsCountLabel = UILabel(frame: CGRect(x: width - 100, y: 5, width: 70, height: 70))
        contentView.addSubview(listsCountLabel)
        listsCountLabel.font = .systemFont(ofSize: 14)
        listsCountLabel.adjustsFontSizeToFitWidth = true
        
        addBtn = UIButton(frame: CGRect(x: width - 55, y: 5, width: 70, height: 70))
        contentView.addSubview(addBtn)
        addBtn.addTarget(self, action: #selector(addList), for: .touchUpInside)
        addBtn.setImage(UIImage(systemName: "plus"), for: .normal)
        
        listView = UITableView(frame: CGRect(x: 0, y: 80, width: width, height: CGFloat((listsCount ?? 0) * 80)))
        contentView.addSubview(listView)
        listView.dataSource = self
        listView.delegate = self
        
    }
    
    func reloadData(lists: [SongList]) {
        self.lists = lists
        self.listView.reloadData()
    }

}

extension listsCell: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellid = "id"
        listView.register(listCell.self, forCellReuseIdentifier: cellid)
        var cell: listCell = tableView.dequeueReusableCell(withIdentifier: cellid) as! listCell
        if cell == nil {
            cell = listCell(style: .default, reuseIdentifier: cellid)
        }
        if !lists.isEmpty {
            cell.countLabel.text = "(\(lists[indexPath.row].count))"
            cell.imgView.sd_setImage(with: lists[indexPath.row].imgUrl, placeholderImage: UIImage(named: "default"))
            cell.nameLabel.text = lists[indexPath.row].name
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = DetailedList()
        vc.listId = lists[indexPath.row].id
        UIApplication.shared.keyWindow?.rootViewController?.present(vc, animated: true)
    }
}
extension listsCell {
    @objc func addList() {
        
    }
}

