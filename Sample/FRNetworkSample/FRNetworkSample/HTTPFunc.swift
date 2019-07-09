//
//  HTTPFunc.swift
//  FRNetworkSample
//
//  Created by exs-mobile 강상우 on 09/07/2019.
//  Copyright © 2019 강상우. All rights reserved.
//

import UIKit
import FRHTTP

let testURLString = "http://api.randomuser.me/"

class HTTPFunc: NSObject {
    class func get() {
        FRNetwork.load(url: testURLString + "?results=2") { (response) in
            print(response)
        }
    }
    
    class func post(contentType: HTTPContentType) {
        let data = ["result":"10"]
        guard var request = FRHTTPUtil.getRequest(testURLString, data: data, contentType: contentType) else { return }
        request.httpMethod = "GET"
        FRNetwork.load(request: request, completionHandler: responseHandler(response:))
    }
    
    class func responseHandler(response: FRHTTPResponse) {
        print(response)
    }
}
