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
    
    let width = UIScreen.main.bounds.width
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        imgView = UIImageView(frame: CGRect(x: 5, y: 5, width: 70, height: 70))
        contentView.addSubview(imgView)
        
        nameLabel = UILabel(frame: CGRect(x: 93, y: 15, width: 250, height: 50))
        contentView.addSubview(nameLabel)
        nameLabel.numberOfLines = 0
        nameLabel.font = UIFont(name: "AvenirNextCondensed-Bold", size: 18)
        
        countLabel = UILabel(frame: CGRect(x: width - 50, y: 20, width: 40, height: 40))
        contentView.addSubview(countLabel)
        countLabel.font = .systemFont(ofSize: 15)
        
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
