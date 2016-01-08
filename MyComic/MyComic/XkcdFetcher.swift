//
//  XkcdFetcher.swift
//  MyComic
//
//  Created by Alexander Gattringer on 08/01/16.
//  Copyright © 2016 Alexander Gattringer. All rights reserved.
//

import Foundation

class XkcdFetcher : NSObject, FetcherProtocol, NSXMLParserDelegate {
    let urlToFetch: NSURL = NSURL(string:"https://xkcd.com/rss.xml")!
    
    var xmlParser: NSXMLParser!
    var comicTitle: String!
    var comicLink: String!
    var comicDescription: String!
    var currentParsedComic: String! = String()
    var comicDict: [String:String]! = Dictionary()
    var comicsArray: [Dictionary<String, String>]! = Array()
    
    func fetchComics(){
        performSelectorInBackground("startParser", withObject: nil)
    }
    
    func startParser(){
        xmlParser = NSXMLParser(contentsOfURL: urlToFetch)
        xmlParser.delegate = self
        
        xmlParser.parse()
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        NSLog(elementName)
    }
}
