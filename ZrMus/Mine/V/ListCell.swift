//
//  ListCell.swift
//  ZrMus
//
//  Created by Zr埋 on 2020/1/29.
//  Copyright © 2020 Zr埋. All rights reserved.
//

import UIKit

class ListCell: UITableViewCell {
//    content
    var imgView: UIImageView!
    var nameLabel: UILabel!
    var creatorLabel: UILabel!
    
    let width = UIScreen.main.bounds.width
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        imgView = UIImageView()
        imgView.setCornerRadius(5)
        contentView.addSubview(imgView)
        imgView.snp.makeConstraints { (make) in
            make.left.equalTo(contentView.snp.left).offset(5)
            make.width.height.equalTo(53)
            make.centerY.equalTo(contentView.snp.centerY)
        }
        
        nameLabel = UILabel()
        contentView.addSubview(nameLabel)
        nameLabel.numberOfLines = 1
        nameLabel.lineBreakMode = .byCharWrapping
        nameLabel.font = UIFont(name: "AvenirNextCondensed-Regular", size: 16)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(imgView.snp.right).offset(10)
            make.right.equalTo(contentView.snp.right).offset(-10)
            make.top.equalTo(imgView.snp.top)
            make.height.equalTo(30)
        }
        
        creatorLabel = UILabel()
        creatorLabel.textAlignment = .center
        contentView.addSubview(creatorLabel)
        creatorLabel.font = .systemFont(ofSize: 12, weight: .light)
        creatorLabel.snp.makeConstraints { (make) in
            make.height.equalTo(20)
            make.left.equalTo(imgView.snp.right).offset(10)
            make.bottom.equalTo(imgView.snp.bottom)
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
