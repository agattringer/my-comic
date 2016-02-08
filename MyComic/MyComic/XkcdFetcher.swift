//
//  XkcdFetcher.swift
//  MyComic
//
//  Created by Alexander Gattringer on 08/01/16.
//  Copyright © 2016 Alexander Gattringer. All rights reserved.
//

import UIKit
import Foundation

class XkcdFetcher : NSObject, FetcherProtocol, NSXMLParserDelegate {
    //URL for the xkcd rss feed
    let urlToFetch: NSURL = NSURL(string:"https://xkcd.com/rss.xml")!

    var xmlParser: NSXMLParser!
    var insideItem: Bool = false
    var element: String!
    var stringInElement: String = String()
    
    var currentComic: Comic = Comic(name: "")
    var comicsArray: [Comic] = Array()
    var delegate:FetcherDelegate?
    
    func fetchComics(){
        comicsArray.removeAll()
        performSelectorInBackground("startParser", withObject: nil)
    }
    
    func startParser(){
        xmlParser = NSXMLParser(contentsOfURL: urlToFetch)
        xmlParser.delegate = self
        
        xmlParser.parse()
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        element = elementName
        
        if (elementName == "item"){
            insideItem = true
            return
        }
        
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        //handle end of item
        if (elementName == "item"){
            comicsArray.append(currentComic)
            currentComic = Comic(name:"")
            insideItem = false
            return
        }
        
        if (insideItem && elementName == "description"){
            parseImgSrcAndDescription(stringInElement)
            stringInElement = ""
            return
        }
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        if (insideItem && element == "title"){
            currentComic.comicName = string
            return
        }
        
        if (insideItem && string.characters.count > 1 && element == "description"){
            stringInElement.appendContentsOf(string)
        }
    }
    
    func parserDidEndDocument(parser: NSXMLParser) {
        performSelectorOnMainThread("fetcherDidFinish", withObject: nil, waitUntilDone: false)
    }
    
    func fetcherDidFinish(){
        delegate?.fetcherDidFinish(comicsArray, type: ComicType.Xkcd)
    }
    
    func parseImgSrcAndDescription(text: String){
        //regex for everything in double quotes
        let regex = "\"(?:\\.|(\\\\\\\")|[^\\\"\"\\n])*\""
        
        let matches = matchesForRegexInText(regex, text: text)
        
        //remove quote chars
        let imgSrc = matches[0].stringByReplacingOccurrencesOfString("\"", withString: "")
        
        let description = matches[1].stringByReplacingOccurrencesOfString("\"", withString: "")
        
        currentComic.comicImageSrc = NSURL(string:imgSrc)!
        currentComic.comicDescription = description
        currentComic.comicType = ComicType.Xkcd
    }
    
}
