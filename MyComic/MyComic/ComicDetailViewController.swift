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
   
    var comic: ComicProtocol!
    
    @IBOutlet weak var comicImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    func setComic(comic:ComicProtocol){
        self.comic = comic
        self.title = comic.comicName
    }
    
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
    }
    
    func createShareButton(){
        let shareButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self, action: "shareComic")
        self.navigationItem.rightBarButtonItem = shareButton
        
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
