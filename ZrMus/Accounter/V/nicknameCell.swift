
//
//  nicknameCell.swift
//  ZrMus
//
//  Created by Zr埋 on 2020/1/24.
//  Copyright © 2020 Zr埋. All rights reserved.
//

import UIKit

class nicknameCell: UITableViewCell {

    var avatar: UIImageView!
    var nickname: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        avatar = UIImageView(frame: CGRect(x: 5, y: 5, width:90, height: 90))
        contentView.addSubview(avatar)
        avatar.layer.cornerRadius = avatar.frame.width / 2
        avatar.clipsToBounds = true
        
        nickname = UILabel()
        contentView.addSubview(nickname)
        nickname.textColor = .black
        nickname.font = .systemFont(ofSize: 26)
        nickname.snp.makeConstraints { (m) in
            m.left.equalTo(100)
            m.top.equalTo(5)
            m.width.equalTo(200)
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
