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
    let detailplaylist: DetailPlaylist
    let urls: JSONNull?
    let privileges: [Privilege]
}

// MARK: - DetailPlaylist
struct DetailPlaylist: Codable {
    let subscribers: [Creator]
    let subscribed: Bool
    let creator: Creator
    let tracks: [Track]
    let trackIDS: [TrackID]
    let updateFrequency: JSONNull?
    let backgroundCoverID: Int
    let backgroundCoverURL: JSONNull?
    let titleImage: Int
    let titleImageURL, englishTitle: JSONNull?
    let opRecommend: Bool
    let specialType, updateTime, trackCount: Int
    let commentThreadID: String
    let ordered: Bool
    let coverImgURL: String
    let newImported: Bool
    let trackUpdateTime: Int
    let coverImgID: Double
    let playCount, privacy, trackNumberUpdateTime, subscribedCount: Int
    let cloudTrackCount, createTime: Int
    let highQuality: Bool
    let adType: Int
    let tags: [JSONAny]
    let status: Int
    let playlistDescription: JSONNull?
    let userID: Int
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
        case englishTitle, opRecommend, specialType, updateTime, trackCount
        case commentThreadID = "commentThreadId"
        case ordered
        case coverImgURL = "coverImgUrl"
        case newImported, trackUpdateTime
        case coverImgID = "coverImgId"
        case playCount, privacy, trackNumberUpdateTime, subscribedCount, cloudTrackCount, createTime, highQuality, adType, tags, status
        case playlistDescription = "description"
        case userID = "userId"
        case name, id, shareCount
        case coverImgIDStr = "coverImgId_str"
        case commentCount
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
    let alia: [String]
    let pop, st: Int
    let rt: Rt?
    let fee, v: Int
    let crbt: JSONNull?
    let cf: String
    let al: Al
    let dt: Int
    let h, m: L?
    let l: L
    let a: JSONNull?
    let cd: String
    let no: Int
    let rtURL: JSONNull?
    let ftype: Int
    let rtUrls: [JSONAny]
    let djID, copyright, sID: Int
    let mark: Double
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
    let tns: [String]
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

// MARK: - L
struct L: Codable {
    let br, fid, size: Int
    let vd: Double
}

enum Rt: String, Codable {
    case empty = ""
    case the600902000000441341 = "600902000000441341"
    case the600902000002631948 = "600902000002631948"
    case the600902000007899855 = "600902000007899855"
    case the600902000007969773 = "600902000007969773"
    case the600902000007969797 = "600902000007969797"
    case the600902000009432282 = "600902000009432282"
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
