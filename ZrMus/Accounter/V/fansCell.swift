//
//  fansCell.swift
//  ZrMus
//
//  Created by Zr埋 on 2020/1/24.
//  Copyright © 2020 Zr埋. All rights reserved.
//

import UIKit

class fansCell: UITableViewCell {
    
    var followeds: UILabel!
    var follows: UILabel!
    var subed: UILabel!
    let width = UIScreen.main.bounds.width
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        followeds = UILabel(frame: CGRect(x: 30, y: 5, width: 70, height: 70))
        contentView.addSubview(followeds)
        followeds.setCornerRadiusCircle()
        followeds.backgroundColor = .red
        followeds.numberOfLines = 2
        followeds.textAlignment = .center
        
        
        follows = UILabel(frame: ZrRect(y: 5, width: 70, height: 70))
        contentView.addSubview(follows)
        follows.setCornerRadiusCircle()
        follows.backgroundColor = .red
        follows.numberOfLines = 2
        follows.textAlignment = .center
        
        subed = UILabel(frame: CGRect(x: width - 100, y: 5, width: 70, height: 70))
        contentView.addSubview(subed)
        subed.setCornerRadiusCircle()
        subed.backgroundColor = .red
        subed.numberOfLines = 0
        subed.font = .systemFont(ofSize: 14)
        subed.textAlignment = .center

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
