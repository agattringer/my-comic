//
//  SettingsTableViewController.swift
//  MyComic
//
//  Created by Alexander Gattringer on 08/02/16.
//  Copyright © 2016 Alexander Gattringer. All rights reserved.
//

import Foundation
import UIKit

class SettingsTableViewController : UITableViewController {
    
    let cellReuseIdentifier = "Cell"
    var availableComics:NSArray = []
    var selectedComics:NSMutableArray = []
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        checkForSettings()
        styleView()
        tableView.reloadData()
    }
    
    func styleView(){
        self.title = "Settings"
        tableView.tableFooterView = UIView() //remove empty cells
        
    }
    
    func checkForSettings(){
        var settingsDict: NSDictionary?
        if let path = NSBundle.mainBundle().pathForResource("Config", ofType: "plist") {
            settingsDict = NSDictionary(contentsOfFile: path)
        }
        if let dict = settingsDict {
            availableComics = dict.objectForKey("Available Comics") as! NSArray
        }
    }
    
    func handleSelection(cell: UITableViewCell){
        if (selectedComics.containsObject(cell)){
            cell.accessoryType = UITableViewCellAccessoryType.None
            selectedComics.removeObject(cell)
            return
        }
        
        cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        selectedComics.addObject(cell)
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Which comics are you interested in?"
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier)!
        cell.textLabel?.text = availableComics[indexPath.row] as? String
        
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)! as UITableViewCell
        handleSelection(cell)
        //deselect again
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return availableComics.count
    }
}
