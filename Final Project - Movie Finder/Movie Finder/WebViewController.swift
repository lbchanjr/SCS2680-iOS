//
//  WebViewController.swift
//  Movie Finder
//
//  Created by Louise Chan on 2019-07-31.
//  Copyright © 2019 Louise Chan. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var webView: UIWebView!
    
    @IBOutlet weak var statusLabel: UILabel!
    var theaterName: String!
    var theaterUrl: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up view controller to display the theater website.
        webView.delegate = self
        guard let url = self.theaterUrl else { return }
        let request = URLRequest(url: url)
        webView.loadRequest(request)
    }
    
    func setTheaterUrl(url: TheaterLink) {
    
        self.theaterName = url.name
        self.theaterUrl = url.url
        
    }
    
    // Proessed when webpage finishes loading.
    func webViewDidFinishLoad(_ webView: UIWebView) {
        statusLabel.text = theaterName
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    // Processed when webpage is loading.
    func webViewDidStartLoad(_ webView: UIWebView) {
        statusLabel.text = "Loading webpage..."
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
}
