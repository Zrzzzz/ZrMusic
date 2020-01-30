//
//  DLCell1.swift
//  ZrMus
//
//  Created by Zr埋 on 2020/1/30.
//  Copyright © 2020 Zr埋. All rights reserved.
//

import UIKit

class DLCell1: UITableViewCell {
//    控件
    var coverImg: UIImageView!
    var nameLabel: UILabel!
    var downLoadBtn: UIButton!
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
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension DLCell1 {
    func drawUI() {
        
        coverImg = UIImageView(frame: CGRect(x: 10, y: 10, width: 120, height: 120))
        contentView.addSubview(coverImg)
        
        nameLabel = UILabel(frame: CGRect(x: width - 150, y: 10, width: 150, height: 80))
        contentView.addSubview(nameLabel)
        nameLabel.numberOfLines = 2
        nameLabel.adjustsFontSizeToFitWidth = true
        
        downLoadBtn = UIButton(frame: CGRect(x: width - 100, y: 60, width: 30, height: 30))
        contentView.addSubview(downLoadBtn)
        downLoadBtn.setImage(UIImage(systemName: "square.and.arrow.down"), for: .normal)
        downLoadBtn.setTitle("下载到本地", for: .normal)
        downLoadBtn.setLayoutType(type: .topImage)
        
        let topColor = ZrColor(r: 122, g: 115, b: 116)
        let bottomColor = ZrColor(r: 255, g: 255, b: 255)
        contentView.layer.insertSublayer(CALayer.getGradientLayer(topColor: topColor, bottomColor: bottomColor, type: .UtoB), at: 0)
    }
    
    
}

