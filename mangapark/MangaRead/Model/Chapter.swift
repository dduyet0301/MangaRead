//
//  ChapterUrl.swift
//  MangaRead
//
//  Created by gem on 7/9/20.
//  Copyright © 2020 gem. All rights reserved.
//

import Foundation

struct Chapter {
    var name: String
    var url: String
    
    init(name: String, url: String) {
        self.name = name
        self.url = url
    }
}
