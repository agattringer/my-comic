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

struct PropertyKey {
    static let nameKey = "name"
    static let imageKey = "image"
    static let typeKey = "type"
    static let descriptionKey = "description"
    static let imageSrcKey = "imgSrc"
}

class Comic : NSObject, ComicProtocol, NSCoding {
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("comics")
    

    var comicName: String
    var comicType: ComicType = ComicType.Default
    var comicImage: UIImage = UIImage()
    var comicDescription: String
    var comicImageSrc: NSURL
    
    override init(){
        self.comicName = ""
        comicDescription = ""
        comicImageSrc = NSURL(string: "")!
        super.init()
    }
    
    init(name: String){
        self.comicName = name
        comicDescription = ""
        comicImageSrc = NSURL(string: "")!
        super.init()
    }
    
    init(name: String, type: ComicType, image: UIImage, description: String) {
        comicName = name
        comicType = type
        comicImage = image
        comicDescription = description
        comicImageSrc = NSURL(string: "")!
        super.init()
    }
    
    func getDescription() -> String{
        return "comic: " + comicName
    }
    
    //this initializer is required to conform to nscoding protocol
    required convenience init?(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObjectForKey(PropertyKey.nameKey) as! String
        let image = aDecoder.decodeObjectForKey(PropertyKey.imageKey) as! UIImage
        let type = aDecoder.decodeIntegerForKey(PropertyKey.typeKey) as ComicType.RawValue
        let description = aDecoder.decodeObjectForKey(PropertyKey.descriptionKey) as! String
        
        self.init(name: name, type: ComicType(rawValue: type)!, image: image, description: description)
    }
    
    //encode properties
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(comicName, forKey: PropertyKey.nameKey)
        aCoder.encodeObject(comicImage, forKey: PropertyKey.imageKey)
        aCoder.encodeInteger(comicType.rawValue , forKey: PropertyKey.typeKey)
        aCoder.encodeObject(comicDescription, forKey: PropertyKey.descriptionKey)
        aCoder.encodeObject(comicImageSrc, forKey: PropertyKey.imageSrcKey)
    }
}
