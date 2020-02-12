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
    let playlist: [Playlist]
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
    let createTime: Int
    let highQuality: Bool
    let subscribedCount, cloudTrackCount, adType, trackNumberUpdateTime: Int
    let trackUpdateTime: Int
    let tags: [String]
    let ordered: Bool
    let userID, specialType: Int
    let coverImgID: Double
    let coverImgURL: String
    let updateTime, privacy, totalDuration, trackCount: Int
    let playCount: Int
    let commentThreadID: String
    let newImported, anonimous: Bool
    let playlistDescription: String?
    let status: Int
    let name: String
    let id: Int
    let coverImgIDStr: String?

    enum CodingKeys: String, CodingKey {
        case subscribers, subscribed, creator, artists, tracks, updateFrequency
        case backgroundCoverID = "backgroundCoverId"
        case backgroundCoverURL = "backgroundCoverUrl"
        case titleImage
        case titleImageURL = "titleImageUrl"
        case englishTitle, opRecommend, recommendInfo, createTime, highQuality, subscribedCount, cloudTrackCount, adType, trackNumberUpdateTime, trackUpdateTime, tags, ordered
        case userID = "userId"
        case specialType
        case coverImgID = "coverImgId"
        case coverImgURL = "coverImgUrl"
        case updateTime, privacy, totalDuration, trackCount, playCount
        case commentThreadID = "commentThreadId"
        case newImported, anonimous
        case playlistDescription = "description"
        case status, name, id
        case coverImgIDStr = "coverImgId_str"
    }
}

// MARK: - Creator
struct Creator: Codable {
    let nickname: String?
}
