//
//  TheaterLink.swift
//  Movie Finder
//
//  Created by Louise Chan on 2019-07-31.
//  Copyright © 2019 Louise Chan. All rights reserved.
//

import Foundation

class TheaterLink {
    var name: String
    var address: String
    var url: URL
    
    init(name: String, address: String, url: String) {
        self.name = name
        self.address = address
        self.url = URL(string: url)!
    }
}
