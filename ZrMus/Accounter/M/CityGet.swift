//
//  CityGet.swift
//  ZrMus
//
//  Created by Zr埋 on 2020/2/2.
//  Copyright © 2020 Zr埋. All rights reserved.
//

import Foundation

// MARK: - CityGet
struct CityGet: Codable {
    let status, info, infocode, count: String?
    let suggestion: Suggestion?
    let districts: [CityGetDistrict]?
}

// MARK: - CityGetDistrict
struct CityGetDistrict: Codable {
    let citycode: [JSONAny]?
    let adcode, name, center, level: String?
    let districts: [DistrictDistrict]?
}

// MARK: - DistrictDistrict
struct DistrictDistrict: Codable {
    let citycode, adcode, name, center: String?
    let level: String?
    let districts: [JSONAny]?
}

// MARK: - Suggestion
struct Suggestion: Codable {
    let keywords, cities: [JSONAny]?
}

