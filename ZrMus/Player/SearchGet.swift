//
//  SearchGet.swift
//  ZrMus
//
//  Created by Zr埋 on 2020/2/5.
//  Copyright © 2020 Zr埋. All rights reserved.
//

import Foundation

// MARK: - SearchGet
struct SearchGet: Codable {
    let result: SResult?
    let code: Int?
}

// MARK: - Result
struct SResult: Codable {
    let queryCorrected: [String]?
    let songs: [SSong]?
    let songCount: Int?
}



// MARK: - Song
struct SSong: Codable {
    let id: Int?
    let name: String?
    let artists: [Artist]?
    let album: Album?
    let duration, copyrightID, status: Int?
    let alias: [JSONAny]?
    let rtype, ftype, mvid, fee: Int?
    let rURL: JSONNull?
    let mark: Double?

    enum CodingKeys: String, CodingKey {
        case id, name, artists, album, duration
        case copyrightID = "copyrightId"
        case status, alias, rtype, ftype, mvid, fee
        case rURL = "rUrl"
        case mark
    }
}

// MARK: - Album
struct Album: Codable {
    let id: Int?
    let name: String?
    let artist: Artist?
    let publishTime, size, copyrightID, status: Int?
    let picID: Double?
    let mark: Int?
    let transNames, alia: [String]?

    enum CodingKeys: String, CodingKey {
        case id, name, artist, publishTime, size
        case copyrightID = "copyrightId"
        case status
        case picID = "picId"
        case mark, transNames, alia
    }
}

// MARK: - Artist
struct Artist: Codable {
    let id: Int?
    let name: String?
    let picURL: JSONNull?
    let alias: [JSONAny]?
    let albumSize, picID: Int?
    let img1V1URL: String?
    let img1V1: Int?
    let trans: JSONNull?

    enum CodingKeys: String, CodingKey {
        case id, name
        case picURL = "picUrl"
        case alias, albumSize
        case picID = "picId"
        case img1V1URL = "img1v1Url"
        case img1V1 = "img1v1"
        case trans
    }
}

//MARK: - IsOKGet
struct IsOKGet: Codable {
    let success: Bool?
    let message: String?
}
