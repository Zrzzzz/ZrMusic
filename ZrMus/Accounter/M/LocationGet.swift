//
//  CityGet.swift
//  ZrMus
//
//  Created by Zr埋 on 2020/2/2.
//  Copyright © 2020 Zr埋. All rights reserved.
//

import Foundation

// MARK: - LocationGet
struct LocationGet: Codable {
    let status: Int?
    let message, dataVersion: String?
    let result: [[Result]]?

    enum CodingKeys: String, CodingKey {
        case status, message
        case dataVersion = "data_version"
        case result
    }
}

// MARK: - Result
struct Result: Codable {
    let id, name, fullname: String?
    let level: Int?
    let location: Location?
    let address: String?
}

// MARK: - Location
struct Location: Codable {
    let lat, lng: Double?
}
