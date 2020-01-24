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
    let tokenJSONStr: String
    let userID: Int
    let expired: Bool
    let bindingTime, expiresIn, id, type: Int
    let url: String
    let refreshTime: Int

    enum CodingKeys: String, CodingKey {
        case tokenJSONStr = "tokenJsonStr"
        case userID = "userId"
        case expired, bindingTime, expiresIn, id, type, url, refreshTime
    }
}

// MARK: - Profile
struct Profile: Codable {
    let avatarImgIDStr, backgroundImgIDStr: String
    let defaultAvatar: Bool
    let avatarURL: String
    let backgroundImgID, userType, userID, djStatus: Int
    let province: Int
    let avatarImgID: Double
    let city, vipType, gender, accountStatus: Int
    let nickname: String
    let birthday: Int
    let mutual: Bool
    let remarkName, expertTags: JSONNull?
    let authStatus: Int
    let experts: Experts
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
        case city, vipType, gender, accountStatus, nickname, birthday, mutual, remarkName, expertTags, authStatus, experts, signature, authority
        case profileDescription = "description"
        case detailDescription, followed
        case backgroundURL = "backgroundUrl"
        case profileAvatarImgIDStr = "avatarImgId_str"
        case followeds, follows, eventCount, playlistCount, playlistBeSubscribedCount
    }
}

// MARK: - Experts
struct Experts: Codable {
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
