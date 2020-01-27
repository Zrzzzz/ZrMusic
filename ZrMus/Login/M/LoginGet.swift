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
    let loginType, code: Int
    let account: Account
    let token: String
    let profile: Profile
    let bindings: [Binding]
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

// MARK: - Binding
struct Binding: Codable {
    let userID: Int
    let tokenJSONStr, url: String
    let bindingTime, expiresIn: Int
    let expired: Bool
    let refreshTime, id, type: Int

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case tokenJSONStr = "tokenJsonStr"
        case url, bindingTime, expiresIn, expired, refreshTime, id, type
    }
}

// MARK: - Profile
struct Profile: Codable {
    let userID, vipType, gender, accountStatus: Int
    let province: Int
    let defaultAvatar: Bool
    let avatarURL: String
    let djStatus: Int
    let experts: Experts
    let mutual: Bool
    let remarkName, expertTags: JSONNull?
    let authStatus, city, userType, backgroundImgID: Int
    let avatarImgID: Double
    let nickname: String
    let birthday: Int
    let avatarImgIDStr, backgroundImgIDStr, profileDescription, detailDescription: String
    let followed: Bool
    let backgroundURL: String
    let signature: String
    let authority: Int
    let profileAvatarImgIDStr: String
    let followeds, follows, eventCount, playlistCount: Int
    let playlistBeSubscribedCount: Int

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case vipType, gender, accountStatus, province, defaultAvatar
        case avatarURL = "avatarUrl"
        case djStatus, experts, mutual, remarkName, expertTags, authStatus, city, userType
        case backgroundImgID = "backgroundImgId"
        case avatarImgID = "avatarImgId"
        case nickname, birthday
        case avatarImgIDStr = "avatarImgIdStr"
        case backgroundImgIDStr = "backgroundImgIdStr"
        case profileDescription = "description"
        case detailDescription, followed
        case backgroundURL = "backgroundUrl"
        case signature, authority
        case profileAvatarImgIDStr = "avatarImgId_str"
        case followeds, follows, eventCount, playlistCount, playlistBeSubscribedCount
    }
}

// MARK: - Experts
struct Experts: Codable {
}
