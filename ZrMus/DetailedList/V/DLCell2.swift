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
    var addBtn: UIButton!
//    属性
    let width = UIScreen.main.bounds.width
    var isOK: Bool!
    
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
        countLabel = UILabel(frame: CGRect(x: 15, y: 25, width: 30, height: 30))
        contentView.addSubview(countLabel)
        
        nameLabel = UILabel(frame: CGRect(x: 70, y: 0, width: 200, height: 55))
        contentView.addSubview(nameLabel)
        
        creatorLabel = UILabel(frame: CGRect(x: 70, y: 55, width: width - 70, height: 15))
        contentView.addSubview(creatorLabel)
        
        addBtn = UIButton(frame: CGRect(x: width - 40, y: 0, width: 30, height: 30))
        addBtn.setImage(UIImage(systemName: "text.badge.plus")?.withTintColor(DyColor(light: .white, dark: .red), renderingMode: .alwaysOriginal), for: .normal)
        addBtn.setImage(UIImage(systemName: "text.badge.plus")?.withRenderingMode(.alwaysOriginal).withTintColor(ZrColor(r: 166, g: 27, b: 41)), for: .highlighted)
        contentView.addSubview(addBtn)
    }
    
}
