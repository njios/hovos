//
//  AboutUsVC.swift
//  Hovos
//
//  Created by neeraj kumar joshi on 2/7/20.
//  Copyright © 2020 neeraj kumar joshi. All rights reserved.
//

import Foundation
import UIKit
import WebKit
class AboutUsVC: UIViewController {
    
    @IBOutlet weak var webView:WKWebView!
    private var aboutUs = "https://www.hovos.com/help/?isWebview=1"
   
    override func viewDidLoad() {
        let url = URL(string: aboutUs)!
        let urlrequest = URLRequest(url: url)
        webView.load(urlrequest)
        self.view.addSubview(webView)
    }
    
}
