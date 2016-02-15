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
    var availableComics:[String]!
    var selectedComics:NSMutableArray = []
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        checkForSettings()
        setupView()
    }
    
    func setupView(){
        self.title = "Settings"
        tableView.tableFooterView = UIView() //remove empty cells
    }
    
    func checkForSettings(){
        //setup available comics
        availableComics = DataManager.sharedManager.loadAvailableComics()
        
        //setup selected comics
        let prevSelected = DataManager.sharedManager.loadSelectedComics()
        if (prevSelected != nil){
            selectedComics.addObjectsFromArray(prevSelected!)
        }
    }
    
    func handleSelection(cell: UITableViewCell){
        if (selectedComics.containsObject((cell.textLabel?.text)!)){
            cell.accessoryType = UITableViewCellAccessoryType.None
            selectedComics.removeObject((cell.textLabel?.text)!)
        }else{
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            selectedComics.addObject((cell.textLabel?.text)!)
        }
        //directly save to disk
        DataManager.sharedManager.saveSelectedComics(selectedComics as AnyObject as! [String])
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Which comics are you interested in?"
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier)!
        cell.textLabel?.text = availableComics[indexPath.row]
        
        if (selectedComics.containsObject((cell.textLabel?.text)!)){
            //cell is selected -> show it!
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
        
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
