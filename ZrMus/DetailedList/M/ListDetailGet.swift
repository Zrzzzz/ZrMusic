//
//  ListDetailGet.swift
//  ZrMus
//
//  Created by Zr埋 on 2020/1/26.
//  Copyright © 2020 Zr埋. All rights reserved.
//

import Foundation

// MARK: - ListDetailGet
struct ListDetailGet: Codable {
    let code: Int
    let relatedVideos: JSONNull?
    let playlist: DPlaylist
    let urls: JSONNull?
    let privileges: [Privilege]
}

// MARK: - Playlist
struct DPlaylist: Codable {
    let subscribers: [JSONAny]
    let subscribed: Bool
    let creator: DCreator
    let tracks: [Track]
    let trackIDS: [TrackID]
    let updateFrequency: JSONNull?
    let backgroundCoverID: Int
    let backgroundCoverURL: JSONNull?
    let titleImage: Int
    let titleImageURL, englishTitle: JSONNull?
    let opRecommend: Bool
    let subscribedCount, cloudTrackCount, adType, trackNumberUpdateTime: Int
    let createTime: Int
    let highQuality: Bool
    let privacy, trackUpdateTime, userID: Int
    let coverImgID: Double
    let updateTime: Int
    let newImported: Bool
    let specialType: Int
    let coverImgURL: String
    let trackCount: Int
    let commentThreadID: String
    let playCount: Int
    let tags: [JSONAny]
    let ordered: Bool
    let playlistDescription: JSONNull?
    let status: Int
    let name: String
    let id, shareCount: Int
    let coverImgIDStr: String
    let commentCount: Int

    enum CodingKeys: String, CodingKey {
        case subscribers, subscribed, creator, tracks
        case trackIDS = "trackIds"
        case updateFrequency
        case backgroundCoverID = "backgroundCoverId"
        case backgroundCoverURL = "backgroundCoverUrl"
        case titleImage
        case titleImageURL = "titleImageUrl"
        case englishTitle, opRecommend, subscribedCount, cloudTrackCount, adType, trackNumberUpdateTime, createTime, highQuality, privacy, trackUpdateTime
        case userID = "userId"
        case coverImgID = "coverImgId"
        case updateTime, newImported, specialType
        case coverImgURL = "coverImgUrl"
        case trackCount
        case commentThreadID = "commentThreadId"
        case playCount, tags, ordered
        case playlistDescription = "description"
        case status, name, id, shareCount
        case coverImgIDStr = "coverImgId_str"
        case commentCount
    }
}

// MARK: - Creator
struct DCreator: Codable {
    let defaultAvatar: Bool
    let province, authStatus: Int
    let followed: Bool
    let avatarURL: String
    let accountStatus, gender, city, birthday: Int
    let userID, userType: Int
    let nickname, signature, creatorDescription, detailDescription: String
    let avatarImgID: Double
    let backgroundImgID: Int
    let backgroundURL: String
    let authority: Int
    let mutual: Bool
    let expertTags, experts: JSONNull?
    let djStatus, vipType: Int
    let remarkName: JSONNull?
    let avatarImgIDStr, backgroundImgIDStr, creatorAvatarImgIDStr: String

    enum CodingKeys: String, CodingKey {
        case defaultAvatar, province, authStatus, followed
        case avatarURL = "avatarUrl"
        case accountStatus, gender, city, birthday
        case userID = "userId"
        case userType, nickname, signature
        case creatorDescription = "description"
        case detailDescription
        case avatarImgID = "avatarImgId"
        case backgroundImgID = "backgroundImgId"
        case backgroundURL = "backgroundUrl"
        case authority, mutual, expertTags, experts, djStatus, vipType, remarkName
        case avatarImgIDStr = "avatarImgIdStr"
        case backgroundImgIDStr = "backgroundImgIdStr"
        case creatorAvatarImgIDStr = "avatarImgId_str"
    }
}

// MARK: - TrackID
struct TrackID: Codable {
    let id, v: Int
    let alg: JSONNull?
}

// MARK: - Track
struct Track: Codable {
    let name: String
    let id, pst, t: Int
    let ar: [Ar]
    let alia: [JSONAny]
    let pop, st: Int
    let rt: String?
    let fee, v: Int
    let crbt: JSONNull?
    let cf: String
    let al: Al
    let dt: Int
    let h, m, l: H
    let a: JSONNull?
    let cd: String
    let no: Int
    let rtURL: JSONNull?
    let ftype: Int
    let rtUrls: [JSONAny]
    let djID, copyright, sID, mark: Int
    let rtype: Int
    let rurl: JSONNull?
    let mst, cp, mv, publishTime: Int
    let tns: [String]?

    enum CodingKeys: String, CodingKey {
        case name, id, pst, t, ar, alia, pop, st, rt, fee, v, crbt, cf, al, dt, h, m, l, a, cd, no
        case rtURL = "rtUrl"
        case ftype, rtUrls
        case djID = "djId"
        case copyright
        case sID = "s_id"
        case mark, rtype, rurl, mst, cp, mv, publishTime, tns
    }
}

// MARK: - Al
struct Al: Codable {
    let id: Int
    let name: String
    let picURL: String
    let tns: [JSONAny]
    let picStr: String?
    let pic: Double

    enum CodingKeys: String, CodingKey {
        case id, name
        case picURL = "picUrl"
        case tns
        case picStr = "pic_str"
        case pic
    }
}

// MARK: - Ar
struct Ar: Codable {
    let id: Int
    let name: String
    let tns, alias: [JSONAny]
}

// MARK: - H
struct H: Codable {
    let br, fid, size: Int
    let vd: Double
}

// MARK: - Privilege
struct Privilege: Codable {
    let id, fee, payed, st: Int
    let pl, dl, sp, cp: Int
    let subp: Int
    let cs: Bool
    let maxbr, fl: Int
    let toast: Bool
    let flag: Int
    let preSell: Bool
}
