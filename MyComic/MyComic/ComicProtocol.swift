//
//  ComicProtocol.swift
//  MyComic
//
//  Created by Alexander Gattringer on 04/01/16.
//  Copyright © 2016 Alexander Gattringer. All rights reserved.
//

import Foundation
import UIKit

struct PropertyKey {
    static let nameKey = "name"
    static let imageKey = "image"
    static let typeKey = "type"
    static let descriptionKey = "description"
    static let urlKey = "imageSrc"
    static let favKey = "isFavourite"
    static let unreadKey = "isUnread"
    static let releaseKey = "releaseDate"
}

enum ComicType : String {
    case Xkcd = "Xkcd"
    case NerfNow = "Nerf Now"
    case Dilbert = "Dilbert"
    case Explosm = "Cyanide & Happiness"
    case Smbc = "Smbc"
    case Default = "Default"
}

protocol ComicProtocol {
    var comicName: String { get set }
    var comicType: ComicType { get set }
    var comicDescription: String { get set }
    var comicImageSrc: NSURL  { get set }
    var isFavourite: Bool { get set }
    var isUnread: Bool { get set }
    var releaseDate: NSDate { get set }
    func getDescription() -> String
}