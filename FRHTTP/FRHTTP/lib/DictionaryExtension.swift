//
//  DictionaryExtension.swift
//  FRHTTP
//
//  Created by Fermata 강상우 on 09/07/2019.
//  Copyright © 2019 강상우. All rights reserved.
//

import Foundation

extension Dictionary {
    func queryString(encoding: Bool = true) -> String? {
        guard self.count > 0  else { return nil }
        var components = URLComponents()
        var queryItems = Array<URLQueryItem>()
        
        if let queryData = self as? Dictionary<String, Any?> {
            for (key, value) in queryData {
                guard let _value = value else { continue }
                switch _value {
                case is String, is Int, is Bool, is Double, is Float, is NSNumber, is NSString:
                    if encoding {
                        queryItems.append(URLQueryItem(name: FRHTTPUtil.encodedUrl(key), value: FRHTTPUtil.encodedUrl(FRUtil.toString(_value) )))
                    } else {
                        queryItems.append(URLQueryItem(name: key, value: FRUtil.toString(_value)))
                    }
                default:
                    break
                }
            }
            
            components.queryItems = queryItems
            return components.query
        }
        
        return nil
    }
}
