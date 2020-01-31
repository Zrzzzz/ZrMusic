//
//  ZrExtension.swift
//  ZrMus
//
//  Created by Zr埋 on 2020/1/30.
//  Copyright © 2020 Zr埋. All rights reserved.
//

import UIKit

extension UILabel {
//    根据Frame宽高字体自适应最小宽（高）
    func fontSuitToFrame () {
        let aView = self.sizeThatFits(CGRect.zero.size)
        guard aView.width * aView.height != 0 else { return }
        let rate1 = self.frame.width / aView.width
        let rate2 = self.frame.height / aView.height
        let rate = rate1 > rate2 ? rate2 : rate1
        self.font = .systemFont(ofSize: self.font.pointSize * rate)
    }
}

extension UIButton {
    enum ButtonLayout {
        case leftImage
        case rightImage
        case topImage
        case bottomImage
    }
//    Btn图片与文字并存
    func setLayoutType(type: ButtonLayout){
        let image: UIImage? = self.imageView?.image
        switch type {
        case .leftImage:
            print("系统默认的方式")
        case .rightImage:
            self.imageEdgeInsets = UIEdgeInsets(top:0, left: (self.titleLabel?.frame.size.width)!, bottom: 0, right:-(self.titleLabel?.frame.size.width)!)
            self.titleEdgeInsets = UIEdgeInsets(top: 0, left: -(image?.size.width)!, bottom: 0, right: (image?.size.width)!)
        case .topImage:
            self.imageEdgeInsets = UIEdgeInsets(top:-(self.titleLabel?.frame.size.height)!, left: 0, bottom: 0, right:-((self.titleLabel?.frame.size.width)!))
            //图片距离右边框距离减少图片的宽度，距离上m边距的距离减少文字的高度
            self.titleEdgeInsets = UIEdgeInsets(top: ((image?.size.height)!), left: -((image?.size.width)!), bottom: 0, right:0)
        //文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
        default:
            self.imageEdgeInsets = UIEdgeInsets(top: (self.titleLabel?.frame.size.height)!, left:0, bottom: 0, right:-((self.titleLabel?.frame.size.width)!))
            //图片距离上边距增加文字的高度  距离右边距减少文字的宽度
            self.titleEdgeInsets = UIEdgeInsets(top: -(image?.size.height)!, left: -(image?.size.width)!, bottom: 0, right: 0)
        }
    }
}

extension CALayer {
    enum gradientDirect {
        case LtoR
        case RtoL
        case UtoB
        case BtoU
    }
//    渐变色
    static func getGradientLayer(aColor: UIColor, bColor: UIColor, type: gradientDirect) -> CAGradientLayer {
        let gradientColors = [aColor.cgColor, bColor.cgColor]

        let gradientLocations: [NSNumber] = [0.0, 1.0]
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations
//        设置不同的type
        switch type {
        case .LtoR:
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        case .RtoL:
            gradientLayer.startPoint = CGPoint(x: 1, y: 0)
            gradientLayer.endPoint = CGPoint(x: 0, y: 0)
        case .UtoB:
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        case .BtoU:
            gradientLayer.startPoint = CGPoint(x: 0, y: 1)
            gradientLayer.endPoint = CGPoint(x: 0, y: 0)
        default:
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        }
        return gradientLayer
    }
}

func ZrColor(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) -> UIColor {
    return UIColor(red: r / 255, green: g / 255, blue: b / 255, alpha: a)
}

func ZrColor(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
    return UIColor(red: r / 255, green: g / 255, blue: b / 255, alpha: 1.0)
}

/// its rect will be insert at screen's center
/// - Parameters:
///   - y:
///   - width: 
///   - height:
func ZrLabel(y: CGFloat, width: CGFloat, height: CGFloat) -> UILabel {
    let x = (UIScreen.main.bounds.width - width) / 2
    let label = UILabel(frame: CGRect(x: x, y: y, width: width, height: height))
    label.textAlignment = .center
    return label
}

/// its rect will be insert at screen's center
/// - Parameters:
///   - y:
///   - width:
///   - height:
func ZrRect(y: CGFloat, width: CGFloat, height: CGFloat) -> CGRect {
    let x = (UIScreen.main.bounds.width - width) / 2
    return CGRect(x: x, y: y, width: width, height: height)
}

func ZrRect(xOffset: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) -> CGRect {
    var x = (UIScreen.main.bounds.width - width) / 2
    return CGRect(x: x + xOffset, y: y, width: width, height: height)
}

