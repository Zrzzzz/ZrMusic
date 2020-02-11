//
//  CommentGet.swift
//  ZrMus
//
//  Created by Zr埋 on 2020/2/9.
//  Copyright © 2020 Zr埋. All rights reserved.
//

import Foundation

struct CommentGet: Codable {
    let hotComments: [CComment]?
    let comments: [CComment]?
    let total: Int?
}

struct CComment: Codable {
    let user: CUser?
    let content: String?
    let time: Int?
    let likedCount: Int?
    let commentId: Int?
    let liked: Bool?
}

struct CUser: Codable {
    let avatarUrl: String?
    let nickname: String?
}
