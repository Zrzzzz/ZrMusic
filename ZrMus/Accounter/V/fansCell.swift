//
//  fansCell.swift
//  ZrMus
//
//  Created by Zr埋 on 2020/1/24.
//  Copyright © 2020 Zr埋. All rights reserved.
//

import UIKit

class fansCell: UITableViewCell {
    
    let followeds: UILabel!
    let follows: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        contentView.addSubview(followeds)
        followeds.layer.cornerRadius = 90.0
        followeds.layer.masksToBounds = true
        followeds.backgroundColor = .red
        followeds.numberOfLines = 2
        followeds.textAlignment = .center
        followeds.snp.makeConstraints { (make) in
            make.left.equalTo(70)
            make.top.equalTo(5)
            make.width.height.equalTo(60)
        }
        
        contentView.addSubview(follows)
        follows.layer.cornerRadius = 90.0
        follows.layer.masksToBounds = true
        follows.backgroundColor = .red
        follows.numberOfLines = 2
        follows.textAlignment = .center
        follows.snp.makeConstraints { (make) in
            make.right.equalTo(70)
            make.top.equalTo(5)
            make.width.height.equalTo(60)
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
