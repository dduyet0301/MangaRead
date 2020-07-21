//
//  Manga.swift
//  MangaRead
//
//  Created by gem on 7/7/20.
//  Copyright © 2020 gem. All rights reserved.
//

import Foundation

struct Manga: Decodable {
    var title: String
    var image: String
    var latestChapter: String
    var url: String
    
    init(title: String,
         image: String,
         latestChapter: String,
         url: String) {
        self.title = title
        self.image = image
        self.latestChapter = latestChapter
        self.url = url
    }
}
