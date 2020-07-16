//
//  Contains.swift
//  MangaRead
//
//  Created by gem on 7/7/20.
//  Copyright © 2020 gem. All rights reserved.
//

import Foundation

class Contains {
    public static let BASE_URL = "https://mangapark.net"
    public static let RECENT_COREDATA = "Recent"
    public static let BOOKMARK_COREDATA = "Bookmark"

    public static var arrLatest: [Manga] = []
    public static var arrUpdates: [Manga] = []
    public static var arrPopular: [Manga] = []
    public static var arrChapter: [Chapter] = []
    public static var arrImage: [String] = []
    
    public static var arrReadingItem: [Manga] = []
    public static var arrBookmark: [Manga] = []
    public static var arrRecent: [Manga] = []
    
    public static var arrSearchResult: [Manga] = []
    
    public static var mangaDetail = MangaDetail.init(image: "", title: "", star: "", rating: "", popularity: "", alternative: "", author: "", artist: "", genre: "", type: "", release: "", status: "", latest: "", summary: "", chapters: [])

}
