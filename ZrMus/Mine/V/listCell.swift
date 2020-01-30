//
//  listCell.swift
//  ZrMus
//
//  Created by Zr埋 on 2020/1/29.
//  Copyright © 2020 Zr埋. All rights reserved.
//

import UIKit

class listCell: UITableViewCell {
//    content
    var imgView: UIImageView!
    var nameLabel: UILabel!
    var countLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
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
