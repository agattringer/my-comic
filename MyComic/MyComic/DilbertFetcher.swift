//
//  DilbertFetcher.swift
//  MyComic
//
//  Created by Alexander Gattringer on 27/01/16.
//  Copyright © 2016 Alexander Gattringer. All rights reserved.
//

import Foundation

class DilbertFetcher : NSObject, FetcherProtocol, NSXMLParserDelegate {
    
    let urlToFetch: NSURL = NSURL(string:"http://comicfeeds.chrisbenard.net/view/dilbert/rss")!
    let dateFormat = "EEE, DD MMM yyyy HH:mm:ss xxx"
    var comicsArray: [Comic] = Array()
    var delegate: FetcherDelegate?
    
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
            if (comicsArray.count > 3) {
                finishFetch()
                return
            }
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
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        if (insideItem && element == "title" && currentComic.comicName == ""){
            currentComic.comicName = string
            return
        }
        
        if (insideItem && element == "pubDate" && string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) != ""){
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = dateFormat
            if let date = dateFormatter.dateFromString(string){
                currentComic.releaseDate = date
                return
            }
        }
        
        if (insideItem && string.characters.count > 1 && element == "description"){
            stringInElement.appendContentsOf(string)
        }
    }
    
    func parseImgSrc(text: String){
        //regex for everything in double quotes
        let regex = "\"(?:\\.|(\\\\\\\")|[^\\\"\"\\n])*\""
        
        let matches = matchesForRegexInText(regex, text: text)
        
        //remove quote chars
        let imgSrc = matches[0].stringByReplacingOccurrencesOfString("\"", withString: "")
        
        currentComic.comicImageSrc = NSURL(string:imgSrc)!
        currentComic.comicType = ComicType.Dilbert
    }
    
    func finishFetch(){
        performSelectorOnMainThread("fetcherDidFinish", withObject: nil, waitUntilDone: false)
    }
    
    func fetcherDidFinish(){
        xmlParser.abortParsing()
        delegate?.fetcherDidFinish(comicsArray, type: ComicType.Dilbert)
    }
}