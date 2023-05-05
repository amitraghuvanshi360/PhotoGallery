//
//  WebViewController.swift
//  gallery-project
//
//  Created by Ankush Sharma on 05/05/23.
//

import Foundation
import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let webview = WKWebView()
        webview.navigationDelegate = self
        self.view = webview
        let loadURL = "https://www.qtickets.com"
        let url = URL(string: loadURL)!
        webview.load(URLRequest(url: url))
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
