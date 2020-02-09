
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
    var level: UILabel!
    var listened: UILabel!
    var birth: UILabel!
    var gender: Int!
    var genderView: UIImageView!
    var location: UILabel!
    var signature: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        avatar = UIImageView(frame: CGRect(x: 5, y: 5, width: 90, height: 90))
        contentView.addSubview(avatar)
        avatar.layer.cornerRadius = avatar.frame.width / 2
        avatar.clipsToBounds = true
        
        nickname = UILabel(frame: CGRect(x: 100, y: 5, width: 150, height: 30))
        contentView.addSubview(nickname)
        nickname.font = .boldSystemFont(ofSize: 20)
                
        level = UILabel(frame: CGRect(x: 100, y: 35, width: 30, height: 15))
        contentView.addSubview(level)
        level.layer.cornerRadius = 5
        level.clipsToBounds = true
        level.backgroundColor = ZrColor(r: 255, g: 201, b: 12)
        level.font = .italicSystemFont(ofSize: 14)
        
        birth = UILabel(frame: CGRect(x: 130, y: 35, width: 50, height: 15))
        contentView.addSubview(birth)
        birth.layer.cornerRadius = 5
        birth.clipsToBounds = true
        birth.textAlignment = .right
        birth.font = .systemFont(ofSize: 15)
        
        genderView = UIImageView(frame: CGRect(x: 132, y: 37.5, width: 10, height: 10))
        contentView.addSubview(genderView)
        genderView.backgroundColor = .clear
        
        
        location = UILabel(frame: CGRect(x: 250, y: 15, width: 80, height: 18))
        contentView.addSubview(location)
        location.layer.cornerRadius = 5
        location.clipsToBounds = true
        location.textAlignment = .center
        location.font = .systemFont(ofSize: 12)
        
        
        listened = UILabel(frame: CGRect(x: 180, y: 35, width: 180, height: 15))
        contentView.addSubview(listened)
        listened.font = .systemFont(ofSize: 15)
        listened.backgroundColor = ZrColor(r: 131, g: 203, b: 172)
        listened.layer.cornerRadius = 5
        listened.clipsToBounds = true
        
        signature = UILabel(frame: CGRect(x: 100, y: 50, width: 150, height: 30))
        contentView.addSubview(signature)
        
        
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
