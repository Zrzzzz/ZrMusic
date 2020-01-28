//
//  SongListTransformer.swift
//  ZrMus
//
//  Created by Zr埋 on 2020/1/28.
//  Copyright © 2020 Zr埋. All rights reserved.
//

import UIKit
import CoreData

@objc (SongListTransformer)
class SongListTransformer: ValueTransformer {
    
    override func transformedValue(_ value: Any?) -> Any? {
        return SongList.self
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        return NSKeyedUnarchiver.unarchiveObject(with: value as! Data)
    }
    
}
