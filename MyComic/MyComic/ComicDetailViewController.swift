//
//  ComicDetailViewController.swift
//  MyComic
//
//  Created by Alexander Gattringer on 03/01/16.
//  Copyright © 2016 Alexander Gattringer. All rights reserved.
//

import UIKit
import Haneke

class ComicDetailViewController : UIViewController {
    var comic: ComicProtocol
    @IBOutlet weak var comicImageView: UIImageView!
    
    init(comic:ComicProtocol){
        self.comic = comic
        super.init(nibName: nil, bundle: nil)
        
        self.title = comic.comicName
    }
    
    //we are not nscoding compliant
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    override func viewDidLoad() {
        comicImageView.hnk_setImageFromURL(comic.comicImageSrc)
    }
}
