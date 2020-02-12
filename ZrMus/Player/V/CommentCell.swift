//
//  CommentCell.swift
//  ZrMus
//
//  Created by Zr埋 on 2020/2/9.
//  Copyright © 2020 Zr埋. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {
    
    var avatarImg: UIImageView!
    var nicknameLabel: UILabel!
    var timeLabel: UILabel!
    var contentLabel: UILabel!
    var likedCountLabel: UILabel!
    var likeBtn: UIButton!
    
    let width = UIScreen.main.bounds.width
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        avatarImg = UIImageView(frame: CGRect(x: 5, y: 5, width: 50, height: 50))
        contentView.addSubview(avatarImg)
        avatarImg.setCornerRadiusCircle()
        avatarImg.clipsToBounds = true
        
        nicknameLabel = UILabel(frame: CGRect(x: 80, y: 5, width: 300, height: 35))
        contentView.addSubview(nicknameLabel)
        nicknameLabel.font = .systemFont(ofSize: 13, weight: .medium)
        
        timeLabel = UILabel(frame: CGRect(x: 80, y: 25, width: 100, height: 30))
        contentView.addSubview(timeLabel)
        timeLabel.font = .systemFont(ofSize: 11, weight: .light)
        
        contentLabel = UILabel(frame: CGRect(x: 80, y: 60, width: width - 90, height: 50))
        contentView.addSubview(contentLabel)
        contentLabel.numberOfLines = 0
        contentLabel.font = .systemFont(ofSize: 14, weight: .bold)
        
        likedCountLabel = UILabel(frame: CGRect(x: width - 103, y: 13, width: 70, height: 16))
        contentView.addSubview(likedCountLabel)
        likedCountLabel.font = .systemFont(ofSize: 13, weight: .light)
        likedCountLabel.textAlignment = .right
        
        likeBtn = UIButton(frame: CGRect(x: width - 30, y: 10, width: 20, height: 20))
        contentView.addSubview(likeBtn)
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
