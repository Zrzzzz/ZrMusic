//
//  listCell.swift
//  ZrMus
//
//  Created by Zr埋 on 2020/1/25.
//  Copyright © 2020 Zr埋. All rights reserved.
//

import UIKit

class listCell: UITableViewCell {
//    header
    var arrowImg: UIImageView!
    var titleLabel: UILabel!
    var addBtn: UIButton!//这个之后再完善
//    content
    var imgView: UIImageView!
    var nameLabel: UILabel!
    var countLabel: UILabel!
//    伸缩布尔
    var isExpand = false
    let width = UIScreen.main.bounds.width
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        drawUI()
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

extension listCell {
    func drawUI() {
//        需要启用来遮住下方
        self.layer.masksToBounds = true
//        这个是不用更改的
        arrowImg = UIImageView(frame: CGRect(x: 5, y: 5, width: 50, height: 50))
        contentView.addSubview(arrowImg)
//        判断是否是打开的
        if isExpand {
            arrowImg.image = UIImage(named: "lC_arrow_down")?.withRenderingMode(.alwaysOriginal)
        } else {
            arrowImg.image = UIImage(named: "lC_arrow_right")?.withRenderingMode(.alwaysOriginal)
        }
        
        titleLabel = UILabel(frame: CGRect(x: 60, y: 5, width: 150, height: 50))
        contentView.addSubview(titleLabel)
        titleLabel.font = .boldSystemFont(ofSize: 20)
        titleLabel.textAlignment = .center
        titleLabel.adjustsFontSizeToFitWidth = true
        
        addBtn = UIButton(frame: CGRect(x: width - 55, y: 5, width: 50, height: 50))
        contentView.addSubview(addBtn)
        addBtn.addTarget(self, action: #selector(addList), for: .touchUpInside)
        addBtn.setImage(UIImage(systemName: "plus"), for: .normal)
        
        imgView = UIImageView(frame: CGRect(x: 5, y: 5, width: 70, height: 70))
        contentView.addSubview(imgView)
        
        nameLabel = UILabel(frame: CGRect(x: 75, y: 5, width: 150, height: 40))
        contentView.addSubview(nameLabel)
        nameLabel.font = .boldSystemFont(ofSize: 14)
        nameLabel.adjustsFontSizeToFitWidth = true
        
        countLabel = UILabel(frame: CGRect(x: 75, y: 50, width: 40, height: 20))
        contentView.addSubview(countLabel)
        countLabel.font = .systemFont(ofSize: 10)
    }
}

extension listCell {
    @objc func addList() {
        
    }
}
