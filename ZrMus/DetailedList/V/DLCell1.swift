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
    var deleteBtn: UIButton!
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
        
        nameLabel = UILabel(frame: CGRect(x: 150, y: 10, width: width - 160, height: 80))
        contentView.addSubview(nameLabel)
        nameLabel.numberOfLines = 2
        nameLabel.font = .italicSystemFont(ofSize: 25)
        
        downLoadBtn = UIButton(frame: CGRect(x: width - 150, y: 70, width: 50, height: 50))
        contentView.addSubview(downLoadBtn)
        downLoadBtn.setImage(UIImage(systemName: "square.and.arrow.down")?.withTintColor(DyColor(light: .black, dark: .systemBlue), renderingMode: .alwaysOriginal), for: .normal)
        downLoadBtn.setTitle("下载", for: .normal)
        downLoadBtn.setTitleColor(DyColor(light: .black, dark: .systemBlue), for: .normal)
        downLoadBtn.titleLabel?.font = .boldSystemFont(ofSize: 12)
        downLoadBtn.setLayoutType(type: .topImage)
        
        deleteBtn = UIButton(frame: CGRect(x: width - 100, y: 70, width: 50, height: 50))
        contentView.addSubview(deleteBtn)
        deleteBtn.setImage(UIImage(systemName: "trash")?.withTintColor(.red, renderingMode: .alwaysOriginal), for: .normal)
        deleteBtn.setTitle("删除", for: .normal)
        deleteBtn.setTitleColor(.red, for: .normal)
        deleteBtn.titleLabel?.font = .boldSystemFont(ofSize: 12)
        deleteBtn.setLayoutType(type: .topImage)
        
        let topColor = ZrColor(r: CGFloat.random(in: 0...255), g: CGFloat.random(in: 0...255), b: CGFloat.random(in: 0...255))
        let bottomColor = UIColor { (trait) -> UIColor in
            return trait.userInterfaceStyle == .dark ? UIColor.systemGray6 : UIColor.white
        }
        let gradientLayer = CALayer.getGradientLayer(aColor: topColor, bColor: bottomColor, type: .UtoB)
        gradientLayer.frame.size = CGSize(width: width, height: 140)
        self.contentView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    
}

