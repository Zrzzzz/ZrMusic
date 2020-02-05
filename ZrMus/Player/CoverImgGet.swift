//
//  CoverImgGet.swift
//  ZrMus
//
//  Created by Zr埋 on 2020/2/6.
//  Copyright © 2020 Zr埋. All rights reserved.
//

import Foundation

struct CoverImgGet: Codable {
    let album: CAlbum?
}

struct CAlbum: Codable {
    let picUrl: String?
}
