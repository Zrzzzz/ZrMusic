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
    let loginType, code: Int?
    let account: Account?
    let token: String?
    let profile: Profile?
    let bindings: [Binding]?
}

// MARK: - Account
struct Account: Codable {
    let id: Int?
    let userName: String?
    let type, status, whitelistAuthority, createTime: Int?
    let salt: String?
    let tokenVersion, ban, baoyueVersion, donateVersion: Int?
    let vipType, viptypeVersion: Int?
    let anonimousUser: Bool?
}

// MARK: - Binding
struct Binding: Codable {
    let url: String?
    let userID: Int?
    let tokenJSONStr: String?
    let expiresIn, bindingTime, refreshTime: Int?
    let expired: Bool?
    let id, type: Int?

    enum CodingKeys: String, CodingKey {
        case url
        case userID = "userId"
        case tokenJSONStr = "tokenJsonStr"
        case expiresIn, bindingTime, refreshTime, expired, id, type
    }
}

// MARK: - Profile
struct Profile: Codable {
    let userID, vipType, gender, accountStatus: Int?
    let avatarImgID: Double?
    let nickname: String?
    let birthday, city, userType, backgroundImgID: Int?
    let province: Int?
    let defaultAvatar: Bool?
    let avatarURL: String?
    let djStatus: Int?
    let followed: Bool?
    let backgroundURL: String?
    let detailDescription, avatarImgIDStr, backgroundImgIDStr: String?
    let experts: Experts?
    let mutual: Bool?
    let remarkName, expertTags: JSONNull?
    let authStatus: Int?
    let profileDescription, signature: String?
    let authority: Int?
    let profileAvatarImgIDStr: String?
    let followeds, follows, eventCount, playlistCount: Int?
    let playlistBeSubscribedCount: Int?

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case vipType, gender, accountStatus
        case avatarImgID = "avatarImgId"
        case nickname, birthday, city, userType
        case backgroundImgID = "backgroundImgId"
        case province, defaultAvatar
        case avatarURL = "avatarUrl"
        case djStatus, followed
        case backgroundURL = "backgroundUrl"
        case detailDescription
        case avatarImgIDStr = "avatarImgIdStr"
        case backgroundImgIDStr = "backgroundImgIdStr"
        case experts, mutual, remarkName, expertTags, authStatus
        case profileDescription = "description"
        case signature, authority
        case profileAvatarImgIDStr = "avatarImgId_str"
        case followeds, follows, eventCount, playlistCount, playlistBeSubscribedCount
    }
}

// MARK: - Experts
struct Experts: Codable {
}
