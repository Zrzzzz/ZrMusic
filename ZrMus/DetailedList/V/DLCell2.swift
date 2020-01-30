//
//  DLCell2.swift
//  ZrMus
//
//  Created by Zr埋 on 2020/1/30.
//  Copyright © 2020 Zr埋. All rights reserved.
//

import UIKit

class DLCell2: UITableViewCell {
//    控件
    var countLabel: UILabel!
    var nameLabel: UILabel!
    var creatorLabel: UILabel!
//    属性
    let width = UIScreen.main.bounds.width
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        drawUI()
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

extension DLCell2 {
    func drawUI() {
        countLabel = UILabel(frame: CGRect(x: 5, y: 15, width: 50, height: 50))
        contentView.addSubview(countLabel)
        countLabel.fontSuitToFrame()
        
        nameLabel = UILabel(frame: CGRect(x: 70, y: 5, width: 200, height: 45))
        contentView.addSubview(nameLabel)
        nameLabel.fontSuitToFrame()
        
        creatorLabel = UILabel(frame: CGRect(x: 70, y: 55, width: width - 70, height: 20))
        contentView.addSubview(creatorLabel)
        creatorLabel.fontSuitToFrame()
    }
}
