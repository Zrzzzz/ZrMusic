//
//  ResultCell.swift
//  ZrMus
//
//  Created by Zr埋 on 2020/2/5.
//  Copyright © 2020 Zr埋. All rights reserved.
//

import UIKit

class ResultCell: UITableViewCell {
    
//    控件
    var nameLabel: UILabel!
    var creatorLabel: UILabel!
    var addBtn: UIButton!
//    属性
    let width = UIScreen.main.bounds.width

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        nameLabel = UILabel(frame: CGRect(x: 5, y: 0, width: 200, height: 55))
        contentView.addSubview(nameLabel)
        
        creatorLabel = UILabel(frame: CGRect(x: 5, y: 55, width: width - 70, height: 15))
        contentView.addSubview(creatorLabel)
        
        addBtn = UIButton(frame: CGRect(x: width - 40, y: 30, width: 20, height: 22))
        addBtn.setImage(UIImage(named: "player_menu")?.withRenderingMode(.alwaysOriginal), for: .normal)
        contentView.addSubview(addBtn)
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
