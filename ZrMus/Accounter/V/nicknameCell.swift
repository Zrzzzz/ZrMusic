
//
//  nicknameCell.swift
//  ZrMus
//
//  Created by Zr埋 on 2020/1/24.
//  Copyright © 2020 Zr埋. All rights reserved.
//

import UIKit

class nicknameCell: UITableViewCell {

    let avatar: UIImageView!
    let nickname: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        contentView.addSubview(avatar)
        avatar.layer.cornerRadius = 30
        avatar.layer.masksToBounds = true
        avatar.snp.makeConstraints { (m) in
            m.left.equalTo(5)
            m.top.equalTo(5)
            m.width.height.equalTo(40)
        }
        
        contentView.addSubview(nickname)
        nickname.textColor = .black
        nickname.snp.makeConstraints { (m) in
            m.left.equalTo(70)
            m.top.equalTo(5)
            m.width.equalTo(100)
            m.height.equalTo(20)
        }
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
