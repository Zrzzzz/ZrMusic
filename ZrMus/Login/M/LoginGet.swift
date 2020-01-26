//
//  LoginGet.swift
//  ZrMus
//
//  Created by Zr埋 on 2020/1/24.
//  Copyright © 2020 Zr埋. All rights reserved.
//

import Foundation

// MARK: - LoginGet
struct LoginGet: Codable {
    let code: Int
    let account: Account
    let profile: Profile
}

// MARK: - Account
struct Account: Codable {
    let id: Int
    let userName: String
    let type, status, whitelistAuthority, createTime: Int
    let salt: String
    let tokenVersion, ban, baoyueVersion, donateVersion: Int
    let vipType, viptypeVersion: Int
    let anonimousUser: Bool
}
// MARK: - Profile
struct Profile: Codable {
    let avatarImgIDStr, backgroundImgIDStr: String
    let defaultAvatar: Bool
    let avatarURL: String
    let backgroundImgID, userType, djStatus: Int
    let userID: String
    let province: Int
    let avatarImgID: Double
    let city, vipType, gender, accountStatus: Int
    let nickname: String
    let birthday: Int
    let mutual: Bool
    let remarkName, expertTags: JSONNull?
    let authStatus: Int
    let signature: String
    let authority: Int
    let profileDescription, detailDescription: String
    let followed: Bool
    let backgroundURL: String
    let profileAvatarImgIDStr: String
    let followeds, follows, eventCount, playlistCount: Int
    let playlistBeSubscribedCount: Int

    enum CodingKeys: String, CodingKey {
        case avatarImgIDStr = "avatarImgIdStr"
        case backgroundImgIDStr = "backgroundImgIdStr"
        case defaultAvatar
        case avatarURL = "avatarUrl"
        case backgroundImgID = "backgroundImgId"
        case userType
        case userID = "userId"
        case djStatus, province
        case avatarImgID = "avatarImgId"
        case city, vipType, gender, accountStatus, nickname, birthday, mutual, remarkName, expertTags, authStatus, signature, authority
        case profileDescription = "description"
        case detailDescription, followed
        case backgroundURL = "backgroundUrl"
        case profileAvatarImgIDStr = "avatarImgId_str"
        case followeds, follows, eventCount, playlistCount, playlistBeSubscribedCount
    }
}
