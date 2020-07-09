//
//  MangaDetail.swift
//  MangaRead
//
//  Created by gem on 7/7/20.
//  Copyright © 2020 gem. All rights reserved.
//

import Foundation

struct MangaDetail {
    var image: String
    var title: String
    var star: String
    var rating: String
    var popularity: String
    var alternative: String
    var author: String
    var artist: String
    var genre: String
    var type: String
    var release: String
    var status: String
    var latest: String
    var summary: String
    var chapter: String
    
    init(image: String,
         title: String,
         star: String,
         rating: String,
         popularity: String,
         alternative: String,
         author: String,
         artist: String,
         genre: String,
         type: String,
         release: String,
         status: String,
         latest: String,
         summary: String,
         chapter: String) {
        self.image = image
        self.title = title
        self.star = star
        self.rating = rating
        self.popularity = popularity
        self.alternative = alternative
        self.author = author
        self.artist = artist
        self.genre = genre
        self.type = type
        self.release = release
        self.status = status
        self.latest = latest
        self.summary = summary
        self.chapter = chapter
    }
}
