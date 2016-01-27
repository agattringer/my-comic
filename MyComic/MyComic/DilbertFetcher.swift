//
//  DilbertFetcher.swift
//  MyComic
//
//  Created by Alexander Gattringer on 27/01/16.
//  Copyright © 2016 Alexander Gattringer. All rights reserved.
//

import Foundation

protocol DilbertFetcherDelegate {
    func dilbertFetcherDidFinish(comics: [Comic])
}

class DilbertFetcher : NSObject, FetcherProtocol, NSXMLParserDelegate {
    
    let urlToFetch: NSURL = NSURL(string:"http://comicfeeds.chrisbenard.net/view/dilbert/rss")!
    var comicsArray: [Comic] = Array()
    var delegate: DilbertFetcherDelegate?
    
    var xmlParser: NSXMLParser!
    var insideItem: Bool = false
    var element: String!
    var stringInElement: String = String()
    
    var currentComic: Comic = Comic(name: "")
    
    func fetchComics() {
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
            parseImgSrc(stringInElement)
            stringInElement = ""
            return
        }
    }
    
    func parseImgSrc(text: String){
        //regex for everything in double quotes
        let regex = "\"(?:\\.|(\\\\\\\")|[^\\\"\"\\n])*\""
        
        let matches = matchesForRegexInText(regex, text: text)
        
        //remove quote chars
        var imgSrc = matches[0].stringByReplacingOccurrencesOfString("\"", withString: "")
        
        //replace http with https as with http ios blocks communication
        imgSrc = imgSrc.stringByReplacingOccurrencesOfString("http", withString: "https")
        
        currentComic.comicImageSrc = NSURL(string:imgSrc)!
        currentComic.comicDescription = description
        currentComic.comicType = ComicType.Dilbert
    }
    
    func fetcherDidFinish() {
        
    }
}