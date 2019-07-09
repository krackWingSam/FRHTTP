//
//  FRNetwork.swift
//  AvatarBeans
//
//  Created by Fermata 강상우 on 07/05/2019.
//  Copyright © 2019 강상우. All rights reserved.
//

import UIKit

public struct FRFailResponse {
    let response: HTTPURLResponse?
    let error: Error?
    let errMsg: String
    let errorCode: String?
}

public struct FRHTTPResponse {
    var error: FRFailResponse?
    var data: [AnyHashable: Any]?
    
    init?(response: HTTPURLResponse, data: Data) {
        do {
            guard let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [AnyHashable: Any] else { return nil }
            
            if self.isError(response, data: result) {}
            else {
                self.data = result
            }
            
        } catch {
            print(error)
            return 
        }
    }
    
    mutating func isError(_ response: HTTPURLResponse, data: Dictionary<AnyHashable, Any>) -> Bool {
        let code: String? = data["code"] as? String
        if code == "error" {
            guard let errorMsg: String = data["message"] as? String else { return true }
            self.error = FRFailResponse.init(response: response, error: nil, errMsg: errorMsg, errorCode: nil)
            return true
        }
        
        return false
    }
}

public class FRNetwork: NSObject {
    
    public typealias onFail = ((FRFailResponse) -> Void)
    public typealias FRHTTPHandler = (FRHTTPResponse) -> Void
    
    public static func inFailClosure(response: FRFailResponse) -> Void {
        // TODO:
        print("TODO: do something in Fail Closure")
        print("\tFail to get Response :")
        print("\t\(response)")
    }
    
    // MARK: - Network works
    public class func load(session: URLSession? = nil,
                    url: String,
                    errorHandler: onFail? = nil,
                    completionHandler: ((FRHTTPResponse) -> ())? = nil) {
        guard let request = FRHTTPUtil.getRequest(url) else {
            self.error(errorHandler: errorHandler, response: nil, error: nil, errMsg: "LocalizedKeySet.invalid_url.rawValue")
            return
        }
        
        self.load(session: session, request: request, errorHandler: errorHandler, completionHandler: completionHandler)
    }
    
    public class func load(session: URLSession? = nil,
                 request: URLRequest,
                 errorHandler: onFail? = inFailClosure,
                 completionHandler: ((FRHTTPResponse) -> ())? = nil) {
        let _session = session ?? URLSession.shared
        let task = _session.dataTask(with: request) { (data, response, error) in
            
            let httpResponse = response as? HTTPURLResponse
            print("\(httpResponse?.statusCode ?? 0) : \(request.url?.absoluteString ?? "")")
            
            guard error == nil else {
                print("on url: \(String(describing: request.url?.absoluteString)) desc: \(String(describing: error))")
                self.error(errorHandler: errorHandler, response: httpResponse, error: error, errMsg: SessionManager.shared.getRequestErrorMessage(response: httpResponse) ?? error?.localizedDescription)
                return
            }
            
            if let errMsg = SessionManager.shared.getRequestErrorMessage(response: httpResponse) {
                print("on url: \(String(describing: request.url?.absoluteString)) desc: \(String(describing: errMsg))")
                self.error(errorHandler: errorHandler, response: httpResponse, error: error, errMsg: errMsg)
                return
            }
            
            guard let responseData = data else {
                self.error(errorHandler: errorHandler, response: httpResponse, error: error, errMsg: "not_found_data.localized")
                return
            }
            
            guard let returnValue = FRHTTPResponse.init(response: httpResponse!, data: responseData) else {
                self.error(errorHandler: errorHandler, response: httpResponse, error: error, errMsg: "LocalizedKeySet.not_found_data.localized")
                return
            }
            
            completionHandler?(returnValue)
        }
        
        task.resume()
        
    }
    
    class func error(errorHandler: (onFail?), response: HTTPURLResponse?, error: Error?, errMsg: String?, errorCode: String? = nil) {
        
        if let errorHandler = errorHandler {
            let callback = FRFailResponse(response: response, error: error, errMsg: errMsg ?? ".lost_network_connection", errorCode: errorCode)
            errorHandler(callback)
            
        } else {
            print("TODO: Error Handler Missing. do somethin for this error")
        }
    }
}
