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
    func fetcherDidFinish()
}

extension FetcherProtocol {
    func matchesForRegexInText(regex: String!, text: String!) -> [String] {
        
        do {
            let regex = try NSRegularExpression(pattern: regex, options: [])
            let nsString = text as NSString
            let results = regex.matchesInString(text,
                options: [], range: NSMakeRange(0, nsString.length))
            return results.map { nsString.substringWithRange($0.range)}
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
}