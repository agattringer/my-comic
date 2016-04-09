//
//  SmbcFetcher.swift
//  MyComic
//
//  Created by Alexander Gattringer on 28/01/16.
//  Copyright © 2016 Alexander Gattringer. All rights reserved.
//

import Foundation

class SmbcFetcher : NSObject, FetcherProtocol, NSXMLParserDelegate {
    let urlToFetch = NSURL(string:"http://smbc-comics.com/rss.php")!
    let dateFormat = "EEE, dd MMM yyyy hh:mm:ss -0500"
    var comicsArray: [Comic] = Array()
    
    var delegate: FetcherDelegate?
    var xmlParser: NSXMLParser!
    var insideItem: Bool = false
    var element: String!
    var stringInElement: String = String()
    
    var currentComic: Comic = Comic(name: "")
    
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
            if (comicsArray.count > 3) {
                finishFetch()
                return
            }
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
    
    func parseImgSrcAndDescription(text: String){
        //regex for everything in double quotes
        var regex = "\"(?:\\.|(\\\\\\\")|[^\\\"\"\\n])*\""
        
        var matches = matchesForRegexInText(regex, text: text)
        
        //remove quote chars
        let imgSrc = matches[0].stringByReplacingOccurrencesOfString("\"", withString: "")
        
        //remove linebreaks
        //imgSrc = imgSrc.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
       
        //regex for <p> tag
        regex = "<p>(.*?)<\\/p>"
        matches = matchesForRegexInText(regex, text: text)
        
        //trim tags and unnecessary text for description
        var description = matches[0].substringFromIndex(matches[0].startIndex.advancedBy(14))
        description = description.substringToIndex(description.startIndex.advancedBy(description.characters.count - 4))
        
        currentComic.comicImageSrc = NSURL(string:imgSrc)!
        currentComic.comicDescription = description
        currentComic.comicType = ComicType.Smbc
    }
    
    func finishFetch(){
        performSelectorOnMainThread("fetcherDidFinish", withObject: nil, waitUntilDone: false)
    }
    
    func fetcherDidFinish(){
        xmlParser.abortParsing()
        comicsArray.sortInPlace({$0.releaseDate.compare($1.releaseDate) == .OrderedDescending})
        delegate?.fetcherDidFinish(comicsArray, type: ComicType.Smbc)
    }
    
}