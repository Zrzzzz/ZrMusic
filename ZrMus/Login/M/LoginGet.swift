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
    let code: Int?
    let profile: Profile?
}

// MARK: - Profile
struct Profile: Codable {
    let userId: Int?
}
