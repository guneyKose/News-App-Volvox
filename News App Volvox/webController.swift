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
    
    var url = "https://www.google.com"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myURL = URL(string: url)
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
        webView.uiDelegate = self
        
    }
}
