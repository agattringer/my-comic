//
//  Comic.swift
//  MyComic
//
//  Created by Alexander Gattringer on 10/01/16.
//  Copyright © 2016 Alexander Gattringer. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class Comic : NSObject, ComicProtocol, NSCoding {
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("comics")
    
    var isUnread: Bool
    var isFavourite: Bool
    var comicName: String
    var comicType: ComicType = ComicType.Default
    var comicDescription: String
    var comicImageSrc: NSURL
    
    override init(){
        self.comicName = ""
        comicDescription = ""
        comicImageSrc = NSURL(string: "")!
        isFavourite = false
        isUnread = true
        super.init()
    }
    
    init(name: String){
        self.comicName = name
        comicDescription = ""
        comicImageSrc = NSURL(string: "")!
        isFavourite = false
        isUnread = true
        super.init()
    }
    
    init(name: String, type: ComicType, description: String, url: NSURL, favourite: Bool, unread: Bool) {
        comicName = name
        comicType = type
        comicDescription = description
        comicImageSrc = url
        isFavourite = favourite
        isUnread = unread
        super.init()
    }
    
    func getDescription() -> String{
        return "comic: " + comicName
    }
    
    static func getComicTypeForString(string:String) -> ComicType {
        return ComicType.Default
    }
    
    //this initializer is required to conform to nscoding protocol
    required convenience init?(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObjectForKey(PropertyKey.nameKey) as! String
        let type = aDecoder.decodeObjectForKey(PropertyKey.typeKey) as! String
        let description = aDecoder.decodeObjectForKey(PropertyKey.descriptionKey) as! String
        let url = aDecoder.decodeObjectForKey(PropertyKey.urlKey) as! NSURL
        let fav = aDecoder.decodeBoolForKey(PropertyKey.favKey) as Bool
        let unread = aDecoder.decodeBoolForKey(PropertyKey.unreadKey) as Bool
        
        self.init(name: name, type: ComicType(rawValue: type)!, description: description, url: url, favourite: fav, unread: unread)
    }
    
    //encode properties
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(comicName, forKey: PropertyKey.nameKey)
        aCoder.encodeObject(comicType.rawValue , forKey: PropertyKey.typeKey)
        aCoder.encodeObject(comicDescription, forKey: PropertyKey.descriptionKey)
        aCoder.encodeObject(comicImageSrc, forKey: PropertyKey.urlKey)
        aCoder.encodeBool(isFavourite, forKey: PropertyKey.favKey)
        aCoder.encodeBool(isUnread, forKey: PropertyKey.unreadKey)
    }
    
    override func isEqual(object: AnyObject?) -> Bool {
        if let object = object as? Comic {
            return comicImageSrc == object.comicImageSrc && comicName == object.comicName
        }
        return false
    }
    
    override var hash: Int {
        return comicImageSrc.hashValue
    }
}
