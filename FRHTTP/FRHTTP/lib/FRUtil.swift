//
//  FRUtil.swift
//  FRHTTP
//
//  Created by Fermata 강상우 on 09/07/2019.
//  Copyright © 2019 강상우. All rights reserved.
//

import UIKit

class FRUtil {
    class func toString<T>(_ value: T?, defaultValue: String = "") -> String {
        guard let v = value else { return defaultValue }
        switch v {
        case is String, is NSString:
            return v as? String ?? defaultValue
        case is Int, is Int8, is Int16, is Int32, is Int64, is UInt, is UInt8, is UInt16, is UInt32, is UInt64, is Bool, is Double, is Float, is NSNumber:
            return String(describing: v)
        case is Character:
            if let _v = v as? Character {
                return String(_v)
            }
        default:
            break
        }
        
        return defaultValue
    }
}
