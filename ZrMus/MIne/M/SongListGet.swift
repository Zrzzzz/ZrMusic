//
//  SongListGet.swift
//  ZrMus
//
//  Created by Zr埋 on 2020/1/26.
//  Copyright © 2020 Zr埋. All rights reserved.
//

import Foundation

// MARK: - SongListGet
struct SongListGet: Codable {
    let more: Bool
    let playlist: [Playlist]
    let code: Int
}

// MARK: - Playlist
struct Playlist: Codable {
    let subscribers: [JSONAny]
    let subscribed: Bool
    let creator: Creator
    let artists, tracks, updateFrequency: JSONNull?
    let backgroundCoverID: Int
    let backgroundCoverURL: JSONNull?
    let titleImage: Int
    let titleImageURL, englishTitle: JSONNull?
    let opRecommend: Bool
    let recommendInfo: JSONNull?
    let adType, trackNumberUpdateTime, subscribedCount, cloudTrackCount: Int
    let createTime: Int
    let highQuality: Bool
    let privacy, trackUpdateTime, userID: Int
    let coverImgID: Double
    let updateTime: Int
    let newImported, anonimous: Bool
    let totalDuration, specialType: Int
    let coverImgURL: String
    let trackCount: Int
    let commentThreadID: String
    let playCount: Int
    let tags: [String]
    let ordered: Bool
    let playlistDescription: String?
    let status: Int
    let name: String
    let id: String
    let coverImgIDStr: String?

    enum CodingKeys: String, CodingKey {
        case subscribers, subscribed, creator, artists, tracks, updateFrequency
        case backgroundCoverID = "backgroundCoverId"
        case backgroundCoverURL = "backgroundCoverUrl"
        case titleImage
        case titleImageURL = "titleImageUrl"
        case englishTitle, opRecommend, recommendInfo, adType, trackNumberUpdateTime, subscribedCount, cloudTrackCount, createTime, highQuality, privacy, trackUpdateTime
        case userID = "userId"
        case coverImgID = "coverImgId"
        case updateTime, newImported, anonimous, totalDuration, specialType
        case coverImgURL = "coverImgUrl"
        case trackCount
        case commentThreadID = "commentThreadId"
        case playCount, tags, ordered
        case playlistDescription = "description"
        case status, name, id
        case coverImgIDStr = "coverImgId_str"
    }
}

// MARK: - Creator
struct Creator: Codable {
    let defaultAvatar: Bool
    let province, authStatus: Int
    let followed: Bool
    let avatarURL: String
    let accountStatus, gender, city, birthday: Int
    let userID, userType: Int
    let nickname, signature: String
    let avatarImgID, backgroundImgID: Double
    let backgroundURL: String
    let authority: Int
    let mutual: Bool
    let expertTags: [String]?
    let experts: [String: String]?
    let djStatus, vipType: Int
    let remarkName: JSONNull?
    let avatarImgIDStr, backgroundImgIDStr: String
    let creatorAvatarImgIDStr: String?

    enum CodingKeys: String, CodingKey {
        case defaultAvatar, province, authStatus, followed
        case avatarURL = "avatarUrl"
        case accountStatus, gender, city, birthday
        case userID = "userId"
        case userType, nickname, signature
        case avatarImgID = "avatarImgId"
        case backgroundImgID = "backgroundImgId"
        case backgroundURL = "backgroundUrl"
        case authority, mutual, expertTags, experts, djStatus, vipType, remarkName
        case avatarImgIDStr = "avatarImgIdStr"
        case backgroundImgIDStr = "backgroundImgIdStr"
        case creatorAvatarImgIDStr = "avatarImgId_str"
    }
}
