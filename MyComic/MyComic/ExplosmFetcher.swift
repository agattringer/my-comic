//
//  ExplosmFetcher.swift
//  MyComic
//
//  Created by Alexander Gattringer on 26/01/16.
//  Copyright © 2016 Alexander Gattringer. All rights reserved.
//

import UIKit
import Foundation

class ExplosmFetcher : NSObject, FetcherProtocol {
    
    let explosmUrlString = "http://explosm.net/"
    let explosmComicUrlString = "http://explosm.net/comics/"
    let nrOfComicsToFetch = 4
    //regex for everything in double quotes
    let doubleQuoteRegex = "\"(?:\\.|(\\\\\\\")|[^\\\"\"\\n])*\""
    let dateFormat = "yyyy.MM.dd"
    
    var delegate: FetcherDelegate?
    
    var comicsArray: [Comic] = Array()
    var sourceStrings: [String] = Array()
    
    func fetchComics() {
        comicsArray.removeAll()
        performSelectorInBackground("getSourcesFromWebsite", withObject: explosmUrlString)
    }
    
    func getSourcesFromWebsite(){
        //get source text from website
        let data = NSData(contentsOfURL: NSURL(string: explosmUrlString)!)
        
        let document = TFHpple(HTMLData: data)
        //use xpath to search for the right elements
        let elements = document.searchWithXPathQuery("//*[@id=\"permalink\"]")
        
        
        let matches = matchesForRegexInText(doubleQuoteRegex, text: elements[0].raw)
        let currentComicSource = matches[2].stringByReplacingOccurrencesOfString("\"", withString: "")
        
        let comicUrlsToFetch = NSMutableArray()
        comicUrlsToFetch.addObject(currentComicSource)
        
        comicUrlsToFetch.addObjectsFromArray(getComicsFromSidebar(document))
        
        for url in comicUrlsToFetch {
            comicsArray.append(fetchSingleComic(url as! String))
        }
        
        //finished
        performSelectorOnMainThread("fetcherDidFinish", withObject: nil, waitUntilDone: false)
    }
    
    func getComicsFromSidebar(document: TFHpple) -> [String]{
        var urlArray = [String]()
        
        //second comic
        urlArray.append(getUrlForSearchPath(document, searchPath: "//*[@id=\"past-week-container\"]/div/div/div/div[1]/div/div[2]/div/h3/a"))
        
        //third
        urlArray.append(getUrlForSearchPath(document, searchPath: "//*[@id=\"past-week-container\"]/div/div/div/div[2]/div/div[2]/div/h3/a"))
        
        //fourth
        urlArray.append(getUrlForSearchPath(document, searchPath: "//*[@id=\"past-week-container\"]/div/div/div/div[3]/div/div[2]/div/h3/a"))
        
        return urlArray
    }
    
    func getUrlForSearchPath(document: TFHpple, searchPath: String) -> String{
        var elements = document.searchWithXPathQuery(searchPath)
        var matches = matchesForRegexInText(doubleQuoteRegex, text: elements[0].raw)
       
        var comicSrc = matches[0].stringByReplacingOccurrencesOfString("\"", withString: "")
        comicSrc = comicSrc.substringFromIndex(comicSrc.startIndex.advancedBy(1))
        
        return explosmUrlString + comicSrc
    }
    
    func fetchSingleComic(urlString: String) -> Comic{
        
        let data = NSData(contentsOfURL: NSURL(string: urlString)!)
        let document = TFHpple(HTMLData: data)
        
        var elements = document.searchWithXPathQuery("//*[@id=\"main-comic\"]")
        
        let matches = matchesForRegexInText(doubleQuoteRegex, text: elements[0].raw)
        var comicSrc = matches[1].stringByReplacingOccurrencesOfString("\"", withString: "")
        comicSrc = comicSrc.substringFromIndex(comicSrc.startIndex.advancedBy(2))
        comicSrc = "http://" + comicSrc
        
        elements = document.searchWithXPathQuery("/html/body/div[1]/div/div[4]/div[1]/div[3]/div[1]/div/div[2]/div/h3/a")
        
        let comicName = elements[0].content
        
        elements = document.searchWithXPathQuery("/html/body/div[1]/div/div[4]/div[1]/div[3]/div[1]/div/div[2]/div/small")
        
        let comicDescription = elements[0].content
        let formatter = NSDateFormatter()
        formatter.dateFormat = dateFormat
        let releaseDate = formatter.dateFromString(comicName)
        
        return Comic(name: comicName, type: ComicType.Explosm, description: comicDescription, url: NSURL(string: comicSrc)!, favourite: false, unread: true, release: releaseDate!)
    }

    func fetcherDidFinish(){
        comicsArray.sortInPlace({$0.releaseDate.compare($1.releaseDate) == .OrderedDescending})
        delegate?.fetcherDidFinish(comicsArray, type: ComicType.Explosm)
    }


}
