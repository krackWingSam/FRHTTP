//
//  ViewController.swift
//  FRNetworkSample
//
//  Created by exs-mobile 강상우 on 09/07/2019.
//  Copyright © 2019 강상우. All rights reserved.
//

import UIKit
import FRHTTP

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    // MARK: IBActions
    @IBAction func action_HTTP_GET(_ sender: UIButton) {
        HTTPFunc.get()
    }
    
    @IBAction func action_HTTP_POST(_ sender: UIButton) {
        let tag = sender.tag
        guard let contentType = HTTPContentType(rawValue: tag) else { return }
        HTTPFunc.post(contentType: contentType)
    }

}

