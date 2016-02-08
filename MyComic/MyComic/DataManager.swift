//
//  DataHelper.swift
//  MyComic
//
//  Created by Alexander Gattringer on 08/02/16.
//  Copyright © 2016 Alexander Gattringer. All rights reserved.
//

import Foundation

class DataManager {
    //singleton
    static let sharedManager = DataManager()
    
    let xkcd = "Xkcd"
    let explosm = "Cyanide & Happiness"
    let dilbert = "Dilbert"
    let smbc = "Smbc"
    
    var documentsDirectory:NSURL!
    var selectedComicsURL:NSURL!
    var xkcdURL:NSURL!
    var explosmURL:NSURL!
    var dilbertURL:NSURL!
    var smbcURL:NSURL!
    
    //This prevents others from using the default '()' initializer for this class.
    private init() {
        documentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
        selectedComicsURL = documentsDirectory.URLByAppendingPathComponent("selectedComics")
        
        xkcdURL = documentsDirectory.URLByAppendingPathComponent(xkcd)
        explosmURL = documentsDirectory.URLByAppendingPathComponent(explosm)
        dilbertURL = documentsDirectory.URLByAppendingPathComponent(dilbert)
        smbcURL = documentsDirectory.URLByAppendingPathComponent(smbc)
    }
    
    func loadSelectedComics() -> [String]?{
        return NSKeyedUnarchiver.unarchiveObjectWithFile(selectedComicsURL.path!) as? [String]
    }
    
    func saveSelectedComics(comics: [String]){
         NSKeyedArchiver.archiveRootObject(comics, toFile: selectedComicsURL.path!)
    }
    
    func loadFetchersForSelectedComics() -> [FetcherProtocol]{
        let fetchers = NSMutableArray()
        
        if let selectedComics = loadSelectedComics(){
            if (selectedComics.contains(xkcd)){
                fetchers.addObject(XkcdFetcher())
            }
            
            if (selectedComics.contains(explosm)){
                fetchers.addObject(ExplosmFetcher())
            }
            
            if (selectedComics.contains(dilbert)){
                fetchers.addObject(DilbertFetcher())
            }
            
            if (selectedComics.contains(smbc)){
                fetchers.addObject(SmbcFetcher())
            }
        }
        
        //cast to fetcher array
        return fetchers as AnyObject as! [FetcherProtocol]
    }
    
    func loadAvailableComics() -> [String]{
        var settingsDict: NSDictionary?
        var availableComics = [String]()
        
        if let path = NSBundle.mainBundle().pathForResource("Config", ofType: "plist") {
            settingsDict = NSDictionary(contentsOfFile: path)
        }
        if let dict = settingsDict {
             availableComics = dict.objectForKey("Available Comics") as! [String]
        }
        return availableComics //empty string array
    }
}
