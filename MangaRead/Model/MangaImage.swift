//
//  MangaImage.swift
//  MangaRead
//
//  Created by gem on 7/10/20.
//  Copyright © 2020 gem. All rights reserved.
//

import Foundation

struct MangaImage {
    var imgUrl: String
    var imgNumber: String
    
    init(imgUrl: String, imgNumber: String) {
        self.imgUrl = imgUrl
        self.imgNumber = imgNumber
    }
}
