//
//  FetcherProtocol.swift
//  MyComic
//
//  Created by Alexander Gattringer on 08/01/16.
//  Copyright © 2016 Alexander Gattringer. All rights reserved.
//

import Foundation

protocol FetcherProtocol {
    var comicsArray: [Comic] { get set }
    func fetchComics()
}