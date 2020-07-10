//
//  Contains.swift
//  MangaRead
//
//  Created by gem on 7/7/20.
//  Copyright © 2020 gem. All rights reserved.
//

import Foundation

class Contains {
    public static var BASE_URL = "https://mangapark.net"
    
    public static var arrManga: [Manga] = []
    public static var arrLatest: [Manga] = []
    public static var arrUpdates: [Manga] = []
    public static var arrPopular: [Manga] = []
    public static var mangaDetail = MangaDetail.init(image: "", title: "", star: "", rating: "", popularity: "", alternative: "", author: "", artist: "", genre: "", type: "", release: "", status: "", latest: "", summary: "", chapters: [])
    public static var arrChapter: [Chapter] = []
    public static var arrImage: [String] = []
}
