//
//  DetailViewController.swift
//  Assignment 2 iPad App
//
//  Created by Louise Chan on 2019-07-10.
//  Copyright © 2019 Louise Chan. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!

    @IBOutlet weak var detailTitle: UINavigationItem!
    
    @IBOutlet weak var webView: UIWebView!
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = detailItem {
            if let label = detailDescriptionLabel {
                
                var urlName: String = detail["name"].stringValue.lowercased()
                if urlName == "76ers" {
                    urlName = "https://www.nba.com/teams/sixers"
                }
                else if urlName == "trail blazers" {
                    urlName = "https://www.nba.com/teams/blazers"
                }
                else {
                    urlName = "https://www.nba.com/teams/" + urlName
                }
                
                label.text = urlName
                
                if let url = URL(string: urlName){
                    let request = URLRequest(url: url)
                    webView.loadRequest(request)
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let detail = detailItem {
            let teamName = detail["city"].stringValue + " " + detail["name"].stringValue + " Webpage"
            self.detailTitle.title = teamName
        }
        
        configureView()
    }

    var detailItem: JSON? {
        didSet {
            // Update the view.
            configureView()
        }
    }


}

