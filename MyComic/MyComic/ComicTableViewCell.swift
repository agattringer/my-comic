//
//  ComicTableViewCell.swift
//  MyComic
//
//  Created by Alexander Gattringer on 03/01/16.
//  Copyright © 2016 Alexander Gattringer. All rights reserved.
//

import UIKit
import Haneke

class ComicTableViewCell : UITableViewCell {
    //height constant for view construction
    static let comicCellHeight:CGFloat = 120;
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    var comic: Comic!
    
    func initWithComic (comic: Comic){
        self.comic = comic
        self.thumbnailImageView.hnk_setImageFromURL(comic.comicImageSrc)
        self.descriptionLabel.text = comic.comicName
        if (comic.isUnread){
            self.backgroundColor = UIColor.blueColor()
        }else{
            self.backgroundColor = UIColor.whiteColor()
        }
    }
    
}
