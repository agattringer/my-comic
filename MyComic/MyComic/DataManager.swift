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
    
    var documentsDirectory:NSURL!
    var selectedComicsURL:NSURL!
    var xkcdURL:NSURL!
    var explosmURL:NSURL!
    var dilbertURL:NSURL!
    var smbcURL:NSURL!
    var favouritesURL:NSURL!
    
    //This prevents others from using the default '()' initializer for this class.
    private init() {
        documentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
        selectedComicsURL = documentsDirectory.URLByAppendingPathComponent("selectedComics")
        
        xkcdURL = documentsDirectory.URLByAppendingPathComponent(ComicType.Xkcd.rawValue)
        explosmURL = documentsDirectory.URLByAppendingPathComponent(ComicType.Explosm.rawValue)
        dilbertURL = documentsDirectory.URLByAppendingPathComponent(ComicType.Dilbert.rawValue)
        smbcURL = documentsDirectory.URLByAppendingPathComponent(ComicType.Smbc.rawValue)
        favouritesURL = documentsDirectory.URLByAppendingPathComponent("favouriteComics")
    }
    
    func loadFavouriteComics() -> [Comic]?{
        return NSKeyedUnarchiver.unarchiveObjectWithFile(favouritesURL.path!) as? [Comic]
    }
    
    func saveFavouriteComics(comics: [Comic]){
        NSKeyedArchiver.archiveRootObject(comics, toFile: favouritesURL.path!)
    }
    
    func loadSelectedComics() -> [String]?{
        return NSKeyedUnarchiver.unarchiveObjectWithFile(selectedComicsURL.path!) as? [String]
    }
    
    func saveSelectedComics(comics: [String]){
         NSKeyedArchiver.archiveRootObject(comics, toFile: selectedComicsURL.path!)
    }
    
    func saveComicsWithType(comics: [Comic], type: ComicType){
        let file = getFileURLForComicType(type)
        
        NSKeyedArchiver.archiveRootObject(comics, toFile: file.path!)
    }
    
    func loadComicsWithType(type: ComicType) -> [Comic]?{
        let file = getFileURLForComicType(type)
        
        return NSKeyedUnarchiver.unarchiveObjectWithFile(file.path!) as? [Comic]
    }
    
    func getFileURLForComicType(type:ComicType) -> NSURL{
        switch (type){
        case ComicType.Xkcd:
            return xkcdURL
        case ComicType.Explosm:
            return explosmURL
        case ComicType.Dilbert:
            return dilbertURL
        case ComicType.Smbc:
            return smbcURL
        default:
            print("error")
            return NSURL()
        }
    }
    
    func loadFetchersForSelectedComics() -> [FetcherProtocol]{
        var fetchers = [FetcherProtocol]()
        
        if let selectedComics = loadSelectedComics(){
            if (selectedComics.contains(ComicType.Xkcd.rawValue)){
                fetchers.append(XkcdFetcher())
            }
            
            if (selectedComics.contains(ComicType.Explosm.rawValue)){
                fetchers.append(ExplosmFetcher())
            }
            
            if (selectedComics.contains(ComicType.Dilbert.rawValue)){
                fetchers.append(DilbertFetcher())
            }
            
            if (selectedComics.contains(ComicType.Smbc.rawValue)){
                fetchers.append(SmbcFetcher())
            }
        }
        
        return fetchers
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
