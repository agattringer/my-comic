//
//  DataHelper.swift
//  MyComic
//
//  Created by Alexander Gattringer on 08/02/16.
//  Copyright © 2016 Alexander Gattringer. All rights reserved.
//

import Foundation

class DataManager {
    static let sharedManager = DataManager()
    var documentsDirectory:NSURL!
    // = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    var selectedComicsURL:NSURL!
    // = documentsDirectory.URLByAppendingPathComponent("selectedComics")
    
    //This prevents others from using the default '()' initializer for this class.
    private init() {
        documentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
        selectedComicsURL = documentsDirectory.URLByAppendingPathComponent("selectedComics")
    }
    
    func loadSelectedComics() -> [String]?{
        return NSKeyedUnarchiver.unarchiveObjectWithFile(selectedComicsURL.path!) as? [String]
    }
    
    func saveSelectedComics(comics: [String]){
         NSKeyedArchiver.archiveRootObject(comics, toFile: selectedComicsURL.path!)
    }
    
    func loadFetchersForSelectedComics() -> [FetcherProtocol]{
        return [FetcherProtocol]()
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
