//
//  AppDelegate.swift
//  BitMEX
//
//  Created by Behnam Karimi on 6/19/1398 AP.
//  Copyright © 1398 AP Behnam Karimi. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var app: App!
    
    private var prevGameStatus: Bool = false // true = playing

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.

//        app.webSocket.close()
        prevGameStatus = app.game.isPlaying
        if app.game.isPlaying {
            app.game.pause()
        }
        app.chart?.CHARTSHOULDNOTBEREDRAWN = true
        app.chartNeedsSetupOnViewAppeared = true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        if let app = self.app {
            app.saveSettings()
        }
        app.chart?.CHARTSHOULDNOTBEREDRAWN = true
        app.chartNeedsSetupOnViewAppeared = true
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//        app.webSocket.open()
        if prevGameStatus {
            app.game.resume()
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        app.game.pause()
        app?.saveSettings()
    }


}

