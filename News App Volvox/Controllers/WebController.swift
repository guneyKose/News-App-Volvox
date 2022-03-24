//
//  WebController.swift
//  News App Volvox
//
//  Created by Güney Köse on 18.03.2022.
//

import UIKit
import WebKit

class WebController: UIViewController, UIWebViewDelegate, WKUIDelegate {
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var activityItem: UIActivityIndicatorView!
    var url = "https://www.google.com"
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        activityItem.startAnimating()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myURL = URL(string: url)
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
        webView.uiDelegate = self
        
        DispatchQueue.main.asyncAfter(deadline: .now() + webView.estimatedProgress + 1) {
            self.activityItem.isHidden = true
        }
    }
   
}
