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
        let currentComicSource = matches[2]
        
        sourceStrings.append(currentComicSource)
        var currentComicString = currentComicSource.substringFromIndex(currentComicSource.startIndex.advancedBy(explosmUrlString.characters.count + 7))
        
        //get number of current comic for decreasing to get older ones
        currentComicString = currentComicString.stringByReplacingOccurrencesOfString("/", withString: "")
        currentComicString = currentComicString.stringByReplacingOccurrencesOfString("\"", withString: "")
        let currentComicNumber = Int(currentComicString)!
        
        for index in 0..<nrOfComicsToFetch {
            comicsArray.append(fetchSingleComic(explosmComicUrlString + "\(currentComicNumber - index)"))
        }
        
        //finished
        performSelectorOnMainThread("fetcherDidFinish", withObject: nil, waitUntilDone: false)
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
        
        
        return Comic(name: comicName, type: ComicType.Explosm, description: comicDescription, url: NSURL(string: comicSrc)!)
    }

    func fetcherDidFinish(){
        delegate?.fetcherDidFinish(comicsArray, type: ComicType.Explosm)
    }


}
