//
//  AppDelegate.swift
//  MyComic
//
//  Created by Alexander Gattringer on 29/12/15.
//  Copyright © 2015 Alexander Gattringer. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, FetcherDelegate {

    var window: UIWindow?
    var fetchersRunning = 0

    func application(application: UIApplication, performFetchWithCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        
        let result = fetchComics()
        completionHandler(result.fetchResult)
    }
    
    func fetchComics() -> (fetchResult: UIBackgroundFetchResult, nrOfNewComics: Int){
        let fetchers = DataManager.sharedManager.loadFetchersForSelectedComics()
        
        for var fetcher in fetchers {
            fetcher.delegate = self
            fetcher.fetchComics()
            fetchersRunning++
        }
        
        return (UIBackgroundFetchResult.NewData, 0)
    }
    
    func fetcherDidFinish(comics: [Comic], type: ComicType) {
        let overviewController = ComicOverviewController()
        overviewController.fetcherDidFinish(comics, type: type)
        fetchersRunning--
        if (fetchersRunning == 0){
            fireLocalNotification(DataManager.sharedManager.nrOfUnreadComics())
            print("fetch finished")
        }
    }
    
    func fireLocalNotification(nrOfComics:Int){
        if (nrOfComics == 0){
            return
        }
        
        let localNotification:UILocalNotification = UILocalNotification()
        localNotification.alertAction = "Hello there!"
        localNotification.alertBody = "There are \(nrOfComics) new comics available that you might wanna check out"
        localNotification.fireDate = NSDate(timeIntervalSinceNow: 3)
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        //ask for notifications
        let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
        application.registerUserNotificationSettings(settings)
        
        //background fetch interval
        application.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

