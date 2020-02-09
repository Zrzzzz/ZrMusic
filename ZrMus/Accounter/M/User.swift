//
//  User.swift
//  ZrMus
//
//  Created by Zr埋 on 2020/2/2.
//  Copyright © 2020 Zr埋. All rights reserved.
//

import UIKit

struct User {
//    名字
    var nickname: String?
//    性别
    var gender: Int?
//    等级
    var level: Int?
//    听过的歌
    var listenSongs: Int?
//    生日
    var birth: Int?
//    城市
    var province: String?
    var city: String?
//    签名
    var signature: String?
//    图片
    var avatarImg: URL?
    var backImg: URL?
//    关注
    var follows: Int?
//    粉丝
    var followeds: Int?
//    被订阅歌单数
    var beSubed: Int?
}

protocol UserDelegate: class {
    var user: User { get set }
}
