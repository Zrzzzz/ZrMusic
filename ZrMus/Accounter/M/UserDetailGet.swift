//
//  UserDetailGet.swift
//  ZrMus
//
//  Created by Zr埋 on 2020/2/1.
//  Copyright © 2020 Zr埋. All rights reserved.
//

import Foundation

// MARK: - UserDetailGet
struct UserDetailGet: Codable {
    let level, listenSongs: Int?
    let userPoint: UserPoint?
    let mobileSign, pcSign: Bool?
    let profile: UProfile?
    let peopleCanSeeMyPlayRecord: Bool?
    let bindings: [UBinding]?
    let adValid: Bool?
    let code, createTime, createDays: Int?
}

// MARK: - Binding
struct UBinding: Codable {
    let url: String?
    let userID, expiresIn, refreshTime, bindingTime: Int?
    let tokenJSONStr: JSONNull?
    let expired: Bool?
    let id, type: Int?

    enum CodingKeys: String, CodingKey {
        case url
        case userID = "userId"
        case expiresIn, refreshTime, bindingTime
        case tokenJSONStr = "tokenJsonStr"
        case expired, id, type
    }
}

// MARK: - Profile
struct UProfile: Codable {
    let mutual: Bool?
    let profileDescription: String?
    let userID: Int?
    let nickname: String?
    let djStatus, createTime, accountStatus, province: Int?
    let vipType: Int?
    let followed: Bool?
    let remarkName: JSONNull?
    let avatarImgID: Double?
    let birthday, gender, userType: Int?
    let avatarURL: String?
    let authStatus: Int?
    let detailDescription: String?
    let experts: UExperts?
    let expertTags: JSONNull?
    let city: Int?
    let defaultAvatar: Bool?
    let backgroundImgID: Int?
    let backgroundURL: String?
    let avatarImgIDStr, backgroundImgIDStr, signature: String?
    let authority, followeds, follows: Int?
    let blacklist: Bool?
    let eventCount, allSubscribedCount, playlistBeSubscribedCount: Int?
    let profileAvatarImgIDStr: String?
    let followTime: JSONNull?
    let followMe: Bool?
    let artistIdentity: [JSONAny]?
    let cCount, sDJPCount, playlistCount, sCount: Int?
    let newFollows: Int?

    enum CodingKeys: String, CodingKey {
        case mutual
        case profileDescription = "description"
        case userID = "userId"
        case nickname, djStatus, createTime, accountStatus, province, vipType, followed, remarkName
        case avatarImgID = "avatarImgId"
        case birthday, gender, userType
        case avatarURL = "avatarUrl"
        case authStatus, detailDescription, experts, expertTags, city, defaultAvatar
        case backgroundImgID = "backgroundImgId"
        case backgroundURL = "backgroundUrl"
        case avatarImgIDStr = "avatarImgIdStr"
        case backgroundImgIDStr = "backgroundImgIdStr"
        case signature, authority, followeds, follows, blacklist, eventCount, allSubscribedCount, playlistBeSubscribedCount
        case profileAvatarImgIDStr = "avatarImgId_str"
        case followTime, followMe, artistIdentity, cCount, sDJPCount, playlistCount, sCount, newFollows
    }
}

// MARK: - Experts
struct UExperts: Codable {
}

// MARK: - UserPoint
struct UserPoint: Codable {
    let userID, balance, updateTime, version: Int?
    let status, blockBalance: Int?

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case balance, updateTime, version, status, blockBalance
    }
}

