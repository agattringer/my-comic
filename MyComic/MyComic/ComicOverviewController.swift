//
//  ViewController.swift
//  MyComic
//
//  Created by Alexander Gattringer on 29/12/15.
//  Copyright © 2015 Alexander Gattringer. All rights reserved.
//

import UIKit

class ComicOverviewController: UITableViewController, XkcdFetcherDelegate, ExplosmFetcherDelegate, DilbertFetcherDelegate, SmbcFetcherDelegate{

    let cellReuseIdentifier = "ComicCell"
    var xkcdComics: [Comic] = []
    var explosmComics: [Comic] = []
    var dilbertComics: [Comic] = []
    var smbcComics: [Comic] = []
    
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
        
        //check for saved comics
        if let storedComics = loadStoredComics() {
            xkcdComics += storedComics
        }
    }
    
    func loadStoredComics() -> [Comic]?{
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Comic.ArchiveURL.path!) as? [Comic]
    }
    
    func fetchComics(){
        let fetcher = XkcdFetcher()
        fetcher.delegate = self
        fetcher.fetchComics()
        
        let explosmFetcher = ExplosmFetcher()
        explosmFetcher.delegate = self
        explosmFetcher.fetchComics()
        
        let dilbertFetcher = DilbertFetcher()
        dilbertFetcher.delegate = self
        dilbertFetcher.fetchComics()
        
        let smbcFetcher = SmbcFetcher()
        smbcFetcher.delegate = self
        smbcFetcher.fetchComics()
    }
    
    //settings button pressed
    func settingsButtonPressed(){
        NSLog(":::settings pressed:::")
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return xkcdComics.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch (section){
        case 0:
            return "xkcd"
        case 1:
            return "Cyanide & Happiness"
        case 2:
            return "Dilbert"
        case 3:
            return "Smbc"
        default:
            return "error"
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:ComicTableViewCell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as! ComicTableViewCell
        
        
        switch (indexPath.section) {
        case 0:
            if (!xkcdComics.isEmpty){
                cell.initWithComic(xkcdComics[indexPath.row])
            }
        case 1:
            if (!explosmComics.isEmpty){
                cell.initWithComic(explosmComics[indexPath.row])
            }
        case 2:
            if (!dilbertComics.isEmpty){
                cell.initWithComic(dilbertComics[indexPath.row])
            }
        case 3:
            if (!smbcComics.isEmpty){
                cell.initWithComic(smbcComics[indexPath.row])
            }
        default:
            print("no comics error")
        }
        
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return ComicTableViewCell.comicCellHeight;
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! ComicTableViewCell
        
        let comicDetail:ComicDetailViewController = ComicDetailViewController(comic: cell.comic)
        self.navigationController?.pushViewController(comicDetail, animated: true)
        
    }
    
    func xkcdFetcherDidFinish(comics: [Comic]) {
        xkcdComics = comics
        self.refreshControl?.endRefreshing()
        
        NSKeyedArchiver.archiveRootObject(xkcdComics, toFile: Comic.ArchiveURL.path!)
        
        self.tableView.reloadData()
    }
    
    func explosmFetcherDidFinish(comics: [Comic]) {
        explosmComics = comics
        self.refreshControl?.endRefreshing()
        self.tableView.reloadData()
    }
    
    func dilbertFetcherDidFinish(comics: [Comic]) {
        dilbertComics = comics
        self.refreshControl?.endRefreshing()
        self.tableView.reloadData()
    }
    
    func smbcFetcherDidFinish(comics: [Comic]) {
        smbcComics = comics
        self.refreshControl?.endRefreshing()
        self.tableView.reloadData()
    }

}

