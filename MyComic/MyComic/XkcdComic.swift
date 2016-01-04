//
//  xkcdComic.swift
//  MyComic
//
//  Created by Alexander Gattringer on 04/01/16.
//  Copyright © 2016 Alexander Gattringer. All rights reserved.
//

import Foundation

class XkcdComic : ComicProtocol {
    var comicName: String
    var comicType: ComicType
    
    required init(name: String){
        comicName = name
        comicType = ComicType.Xkcd
    }
    
    func getDescription() -> String{
        return "xkcd: " + comicName
    }
}

