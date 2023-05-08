//
//  WebViewController.swift
//  gallery-project
//
//  Created by Ankush Sharma on 05/05/23.
//

import Foundation
import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate , UIWebViewDelegate{
    
    @IBOutlet weak var webVw: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.displayWebView()
    }
    
    func displayWebView(){
        let myWebView:UIWebView = UIWebView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.webVw.frame.height))
        myWebView.delegate = self
        self.webVw.addSubview(myWebView)
        let url = URL (string: "https://qtickets.com");
        let request = URLRequest(url: url! as URL);
        myWebView.loadRequest(request);
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
