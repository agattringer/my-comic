//
//  ComicTableViewCell.swift
//  MyComic
//
//  Created by Alexander Gattringer on 03/01/16.
//  Copyright © 2016 Alexander Gattringer. All rights reserved.
//

import UIKit

class ComicTableViewCell : UITableViewCell {
    //height constant for view construction
    static let comicCellHeight:CGFloat = 120;
    
    @IBOutlet weak var tumbnailImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
}
