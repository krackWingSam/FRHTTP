//
//  HTTPFunc.swift
//  FRNetworkSample
//
//  Created by exs-mobile 강상우 on 09/07/2019.
//  Copyright © 2019 강상우. All rights reserved.
//

import UIKit
import FRHTTP

let testGetURLString = "http://api.randomuser.me/"
let testPostURLString = "https://my-json-server.typicode.com/krackwingsam/FRHTTP/posts"

class HTTPFunc: NSObject {
    class func get() {
        FRNetwork.load(url: testGetURLString + "?results=2") { (response) in
            print(response)
        }
    }
    
    class func post(contentType: HTTPContentType) {
        let data = ["id":"3",
                    "title":"changed Title"]
        guard let request = FRHTTPUtil.getRequest(testPostURLString, data: data, contentType: contentType) else { return }
        FRNetwork.load(request: request, completionHandler: responseHandler(response:))
    }
    
    class func responseHandler(response: FRHTTPResponse) {
        print(response)
    }
}
