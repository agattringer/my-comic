//
//  ViewController.swift
//  MyComic
//
//  Created by Alexander Gattringer on 29/12/15.
//  Copyright © 2015 Alexander Gattringer. All rights reserved.
//

import UIKit

class ComicOverviewController: UITableViewController, FetcherDelegate{

    let cellReuseIdentifier = "ComicCell"
    let showComicDetail = "showComicDetail"
    let showSettings = "showSettings"
    
    var xkcdComics: [Comic] = []
    var explosmComics: [Comic] = []
    var dilbertComics: [Comic] = []
    var smbcComics: [Comic] = []
    
    private var selectedComics: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        let nib = UINib(nibName: "ComicTableViewCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: cellReuseIdentifier)
        
        setupView()
    }
    
    override func viewWillAppear(animated: Bool) {
        loadSavedData()
        self.tableView.reloadData()
    }
    
    func loadSavedData(){
        if let loadedComics = DataManager.sharedManager.loadSelectedComics(){
            selectedComics = loadedComics
        }
        if let loadedComics = DataManager.sharedManager.loadComicsWithType(ComicType.Xkcd){
            xkcdComics = loadedComics
        }
        if let loadedComics = DataManager.sharedManager.loadComicsWithType(ComicType.Explosm){
            explosmComics = loadedComics
        }
        if let loadedComics = DataManager.sharedManager.loadComicsWithType(ComicType.Dilbert){
            dilbertComics = loadedComics
        }
        if let loadedComics = DataManager.sharedManager.loadComicsWithType(ComicType.Smbc){
            smbcComics = loadedComics
        }
    }
    
    func setupView(){
        self.title = "Comics"
        
        //setup navbar
        let settingsButton = UIBarButtonItem(title: "\u{2699}", style: UIBarButtonItemStyle.Plain, target: self, action: "settingsButtonPressed")
        navigationItem.setLeftBarButtonItem(settingsButton, animated: false)
        
        let favouritesButton = UIBarButtonItem(title: "\u{2764}", style: UIBarButtonItemStyle.Plain, target: self, action: "favouritesButtonPressed")
        
        navigationItem.setRightBarButtonItem(favouritesButton, animated: false)
        
        //refresh control
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: "fetchComics", forControlEvents: UIControlEvents.ValueChanged)
    }
    
    func fetchComics(){
        let fetchers = DataManager.sharedManager.loadFetchersForSelectedComics()
        
        for var fetcher in fetchers {
            fetcher.delegate = self
            fetcher.fetchComics()
        }
    }
    
    func favouritesButtonPressed(){
        print("favourites")
    }
    
    func settingsButtonPressed(){
        performSegueWithIdentifier(showSettings, sender: self)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return selectedComics.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getComicArrayForSection(section).count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return selectedComics[section]
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:ComicTableViewCell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as! ComicTableViewCell
        
        let comics = getComicArrayForSection(indexPath.section)
        if (!comics.isEmpty){
            cell.initWithComic(comics[indexPath.row])
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return ComicTableViewCell.comicCellHeight;
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! ComicTableViewCell
        
        performSegueWithIdentifier(showComicDetail, sender: cell)
    }
    
    func getComicArrayForSection(section: Int) -> [Comic]{
        switch (selectedComics[section]){
        case ComicType.Xkcd.rawValue:
            return xkcdComics
        case ComicType.Explosm.rawValue:
            return explosmComics
        case ComicType.Dilbert.rawValue:
            return dilbertComics
        case ComicType.Smbc.rawValue:
            return smbcComics
        default:
            return [Comic]()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier != showComicDetail){
            //return if no comic detail
            return
        }
        
        let comicDetail:ComicDetailViewController = segue.destinationViewController as! ComicDetailViewController
        let cell:ComicTableViewCell = sender as! ComicTableViewCell
        
        comicDetail.comic = cell.comic
    }
    
    func fetcherDidFinish(comics: [Comic], type: ComicType) {
        var comicsToSave = [Comic]()
        
        switch (type){
        case ComicType.Xkcd:
            comicsToSave = getComicsToSave(comics, currentComics: xkcdComics)
            xkcdComics = comicsToSave
            break
        case ComicType.Explosm:
            comicsToSave = getComicsToSave(comics, currentComics: explosmComics)
            explosmComics = comicsToSave
            break
        case ComicType.Dilbert:
            comicsToSave = getComicsToSave(comics, currentComics: dilbertComics)
            dilbertComics = comicsToSave
            break
        case ComicType.Smbc:
            comicsToSave = getComicsToSave(comics, currentComics: smbcComics)
            smbcComics = comicsToSave
            break
        default:
            print("error")
            break
        }
        
        DataManager.sharedManager.saveComicsWithType(comicsToSave, type: type)
        
        self.refreshControl?.endRefreshing()
        self.tableView.reloadData()
    }
    
    private func getComicsToSave(newComics: [Comic], currentComics: [Comic]) -> [Comic]{
        
        var newComicArray = [Comic]()
        
        for comic in currentComics{
            var index = 0
            if (newComics.contains(comic)){
                newComicArray.insert(comic, atIndex: index++)
            }
        }
        
        for comic in newComics{
            if(!newComicArray.contains(comic)){
                newComicArray.append(comic)
            }
        }
    
        return newComicArray
    }
}

