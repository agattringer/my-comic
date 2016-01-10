//
//  ViewController.swift
//  MyComic
//
//  Created by Alexander Gattringer on 29/12/15.
//  Copyright © 2015 Alexander Gattringer. All rights reserved.
//

import UIKit

class ComicOverviewController: UITableViewController, XkcdFetcherDelegate{

    let cellReuseIdentifier = "ComicCell"
    var xkcdComics: [Comic] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        let nib = UINib(nibName: "ComicTableViewCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: cellReuseIdentifier)
        
        self.title = "Comics"
        
        //setup navbar
        let settingsButton = UIBarButtonItem(title: "\u{2699}", style: UIBarButtonItemStyle.Plain, target: self, action: "settingsButtonPressed")
        navigationItem.setLeftBarButtonItem(settingsButton, animated: false)
        
        //refresh control
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: "fetchComics", forControlEvents: UIControlEvents.ValueChanged)
    }
    
    func fetchComics(){
        let fetcher = XkcdFetcher()
        fetcher.delegate = self
        fetcher.fetchComics()
    }
    
    //settings button pressed
    func settingsButtonPressed(){
        NSLog(":::settings pressed:::")
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return xkcdComics.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch (section){
        case 0:
            return "xkcd"
        case 1:
            return "nerfnow"
        case 2:
            return "xmbc"
        default:
            return "error"
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:ComicTableViewCell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as! ComicTableViewCell
        
        cell.descriptionLabel.text = "This is comic number xy more text because testing is important"
        
        if (!xkcdComics.isEmpty){
            cell.descriptionLabel.text = xkcdComics[indexPath.row].comicName
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return ComicTableViewCell.comicCellHeight;
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let comic = Comic(name: String(indexPath.row))
        
        let comicDetail:ComicDetailViewController = ComicDetailViewController(comic: comic)
        self.navigationController?.pushViewController(comicDetail, animated: true)
        
    }
    
    func xkcdFetcherDidFinish(comics: [Comic]) {
        xkcdComics = comics
        self.refreshControl?.endRefreshing()
        self.tableView.reloadData()
    }

}

