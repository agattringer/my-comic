//
//  ComicProtocol.swift
//  MyComic
//
//  Created by Alexander Gattringer on 04/01/16.
//  Copyright © 2016 Alexander Gattringer. All rights reserved.
//

import Foundation
import UIKit

enum ComicType : Int {
    case Xkcd
    case NerfNow
    case Dilbert
    case Explosm
    case Default
}

protocol ComicProtocol {
    var comicName: String { get set }
    var comicType: ComicType { get set }
    var comicImage: UIImage { get set }
    var comicDescription: String { get set }
    var comicImageSrc: String  { get set }
    
    func getDescription() -> String
}