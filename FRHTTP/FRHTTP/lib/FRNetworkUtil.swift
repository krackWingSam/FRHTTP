//
//  FRNetworkUtil.swift
//  AvatarBeans
//
//  Created by Fermata 강상우 on 07/05/2019.
//  Copyright © 2019 강상우. All rights reserved.
//

import UIKit

public enum HTTPContentType: Int {
    case urlencoded
    case json
}

public class FRHTTPUtil: NSObject {
    class func addingPercentEncodingForRFC3986(_ value: String) -> String? {
        // Encoding for RFC 3986. Unreserved Characters: ALPHA / DIGIT / “-” / “.” / “_” / “~”
        // Section 3.4 also explains that since a query will often itself include a URL it is preferable to not percent encode the slash (“/”) and question mark (“?”).
        let unreserved = "-._~/?"
        var allowed = CharacterSet.alphanumerics
        allowed.insert(charactersIn: unreserved)
        return value.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)

    }
    
    class func encodedUrl(_ value: String) -> String {
        return addingPercentEncodingForRFC3986(value) ?? value
    }
    
    class func convertURL(_ url: String) -> URL? {
        guard url.count > 0 else { return nil }
        var _url = URL(string: url)
        if _url == nil {
            _url = URL(string: encodedUrl(url))
        }
        return _url
    }
    
    public class func getRequest(_ url: String, timeout: TimeInterval = REQUEST_TIMEOUT, method: String = "GET") -> URLRequest? {
        guard let _url = convertURL(url) else { return nil }
        var request = URLRequest(url: _url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: timeout)
        
        // TODO: setting default reuqest value
        for (key, value) in SessionManager.shared.sessionConfigurationHeaders {
            request.setValue(value as? String, forHTTPHeaderField: key)
        }
        
        request.httpMethod = method
        return request
    }
    
    public class func getRequest(_ url: String, data: Dictionary<AnyHashable, Any>?, contentType: HTTPContentType = .urlencoded) -> URLRequest? {
        guard let _url = convertURL(url) else { return nil }
        var request = URLRequest(url: _url)
        request.httpMethod = "POST"
        
        switch contentType {
        case .urlencoded:
            setRawData(&request, data: data)
        case .json:
            setJsonData(&request, data: data)
        }
        
        return request
    }
    
    // MARK: - Set Data
    class func setRawData(_ request: inout URLRequest, data: Dictionary<AnyHashable, Any>?){
        
        if let _data = parseData(raw: data!) {
            request.setValue(FRUtil.toString(_data.count), forHTTPHeaderField: "Content-Length")
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
            request.httpBody = _data
            
        } else {
            print("Encode Failed...")
        }
    }
    
    class func setJsonData(_ request: inout URLRequest, data: Dictionary<AnyHashable, Any>?) {
        
        if let _data = parseData(json: data!) {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("\(_data.count)", forHTTPHeaderField: "Content-Length")
            request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
            request.httpBody = _data
        }
    }
}


// MARK: - Parse Data
extension FRHTTPUtil {
    class func parseData(raw: Dictionary<AnyHashable, Any>) -> Data? {
        guard let data = raw.queryString()?.data(using: .ascii, allowLossyConversion: true) else { return nil }
        return data
    }
    
    class func parseData(json: Dictionary<AnyHashable, Any>?) -> Data? {
        var jsonBody: Data?
        
        if let _json = json {
            do {
                let __json = try JSONSerialization.data(withJSONObject: _json, options: [])
                jsonBody = String(data: __json, encoding: .utf8)?.data(using: .utf8)
                
            } catch let error {
                print(error)
                return nil
            }
        }
        
        return jsonBody
    }
}
