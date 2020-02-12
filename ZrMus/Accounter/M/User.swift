//
//  User.swift
//  ZrMus
//
//  Created by Zr埋 on 2020/2/1.
//  Copyright © 2020 Zr埋. All rights reserved.
//

import Foundation

// MARK: - User
struct User: Codable {
    let level, listenSongs: Int?
    var profile: UProfile?
}

// MARK: - Profile
struct UProfile: Codable {
    var nickname, signature, avatarUrl, backgroundUrl: String?
    var province, city, birthday, gender, followeds, follows, playlistBeSubscribedCount: Int?
}

protocol UserDelegate: class {
    var user: User { get set }
    var province: String! { get set }
    var city: String! { get set }
}
