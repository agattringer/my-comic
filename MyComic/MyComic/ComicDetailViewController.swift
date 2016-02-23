//
//  ComicDetailViewController.swift
//  MyComic
//
//  Created by Alexander Gattringer on 03/01/16.
//  Copyright © 2016 Alexander Gattringer. All rights reserved.
//

import UIKit
import Haneke

class ComicDetailViewController : UIViewController, UIScrollViewDelegate {
    
    var comic: Comic!{
        didSet{
            self.title = comic.comicName
            self.comic.isFavourite = isFavouriteComic()
        }
    }

    @IBOutlet weak var starButton: UIButton!
    @IBOutlet weak var comicImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        setupView()
        createShareButton()
    }
    
    func setupView(){
        let comicFormat = Format<UIImage>(name: "comics", diskCapacity: 100 * 1024 * 1024) { image in
            return image
        }
        
        comicImageView.hnk_setImageFromURL(comic.comicImageSrc, format: comicFormat)
        
        self.scrollView.minimumZoomScale = 0.5;
        self.scrollView.maximumZoomScale = 6.0;
        self.scrollView.contentSize = comicImageView.bounds.size;
        
        self.scrollView.scrollEnabled = true;
        self.scrollView.delegate = self
        self.scrollView.contentMode = UIViewContentMode.Center
        
        setupStarButton(comic.isFavourite)
    }
    
    func createShareButton(){
        let shareButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self, action: "shareComic")
        self.navigationItem.rightBarButtonItem = shareButton
    }
    
    @IBAction func starComic(sender: AnyObject) {
        comic.isFavourite = !comic.isFavourite
        setupStarButton(comic.isFavourite)
        addToOrRemoveFromFavourites()
    }
    
    func addToOrRemoveFromFavourites(){
        let favouriteComics = NSMutableArray()
        
        if let loadedComics = DataManager.sharedManager.loadFavouriteComics(){
            favouriteComics.addObjectsFromArray(loadedComics)
        }
        favouriteComics.removeObject(comic)
        
        if (comic.isFavourite){
            favouriteComics.addObject(comic)
        }
        DataManager.sharedManager.saveFavouriteComics(favouriteComics as AnyObject as! [Comic])
    }
    
    func isFavouriteComic() -> Bool{
        if let loadedComics = DataManager.sharedManager.loadFavouriteComics(){
            return loadedComics.contains(comic)
        }
        return false
    }
    
    func setupStarButton(enabled: Bool){
        if (enabled){
            starButton.setImage(UIImage(named: "icon_star_full.png"), forState: UIControlState.Normal)
        }else{
            starButton.setImage(UIImage(named: "icon_star.png"), forState: UIControlState.Normal)
        }
    }
    
    func shareComic(){
        let objectsToShare = [comicImageView.image!, comic.comicName]
        let activityController = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        presentViewController(activityController, animated: true, completion: nil)
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.comicImageView
    }
    
}
