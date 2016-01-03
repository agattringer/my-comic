//
//  ViewController.swift
//  MyComic
//
//  Created by Alexander Gattringer on 29/12/15.
//  Copyright © 2015 Alexander Gattringer. All rights reserved.
//

import UIKit

class ComicOverviewController: UITableViewController{

    let cellReuseIdentifier = "ComicCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        let nib = UINib(nibName: "ComicTableViewCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: cellReuseIdentifier)
        
        self.title = "Comics"
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
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
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return ComicTableViewCell.comicCellHeight;
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

}

