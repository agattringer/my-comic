//
//  ComicProtocol.swift
//  MyComic
//
//  Created by Alexander Gattringer on 04/01/16.
//  Copyright © 2016 Alexander Gattringer. All rights reserved.
//

import Foundation
import UIKit

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
    
    func getDescription() -> String
}