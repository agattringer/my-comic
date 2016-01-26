//
//  ExplosmFetcher.swift
//  MyComic
//
//  Created by Alexander Gattringer on 26/01/16.
//  Copyright © 2016 Alexander Gattringer. All rights reserved.
//

import UIKit
import Foundation

protocol ExplosmFetcherDelegate {
    func explosmFetcherDidFinish(comics: [Comic])
}

class ExplosmFetcher : NSObject, FetcherProtocol {
    
    let explosmUrlString = "http://www.explosm.net"
    var delegate: ExplosmFetcherDelegate?
    
    var comicsArray: [Comic] = Array()
    
    func fetchComics() {
        performSelectorInBackground("getSourceFromWebsite", withObject: explosmUrlString)
    }
    
    func getSourceFromWebsite(){
        
        let data = NSData(contentsOfURL: NSURL(string: explosmUrlString)!)
        
        let document = TFHpple(HTMLData: data)
        
        let elements = document.searchWithXPathQuery("//*[@id=\"permalink\"]")
        
        let element = elements[0].raw
        NSLog(element)
        
    }
    
    func websiteFetchFinished(data: NSData?) {
        let websiteString = String(data: data!, encoding: NSUTF8StringEncoding)!
        NSLog(websiteString)
    }
}
