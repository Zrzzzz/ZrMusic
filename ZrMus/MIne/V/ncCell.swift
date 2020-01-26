//
//  ncCell.swift
//  ZrMus
//
//  Created by Zr埋 on 2020/1/25.
//  Copyright © 2020 Zr埋. All rights reserved.
//

import UIKit

class ncCell: UITableViewCell {
    
    var leftView: UIImageView!
    var titilLabel: UILabel!
    var countLabel: UILabel!
    let width = UIScreen.main.bounds.width
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        leftView = UIImageView(frame: CGRect(x: 5, y: 5, width: 70, height: 70))
        contentView.addSubview(leftView)
        
        titilLabel = UILabel(frame: CGRect(x: 90, y: 10, width: 100, height: 50))
        contentView.addSubview(titilLabel)
        titilLabel.font = .systemFont(ofSize: 20)
        titilLabel.textAlignment = .left
        
        countLabel = UILabel(frame: CGRect(x: width - 40, y: 20, width: 50, height: 50))
        contentView.addSubview(countLabel)
        countLabel.font = .systemFont(ofSize: 14)
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
