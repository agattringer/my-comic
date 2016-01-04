//
//  ComicProtocol.swift
//  MyComic
//
//  Created by Alexander Gattringer on 04/01/16.
//  Copyright © 2016 Alexander Gattringer. All rights reserved.
//

import Foundation

enum ComicType {
    case Xkcd
    case NerfNow
    case Dilbert
    case Explosm
}

protocol ComicProtocol {
    var comicName: String { get set }
    var comicType: ComicType { get set }
    
    init(name:String)
    func getDescription() -> String
}