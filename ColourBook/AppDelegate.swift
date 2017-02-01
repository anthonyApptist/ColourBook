//
//  AppDelegate.swift
//  ColourBook
//
//  Created by Mark Meritt on 2016-11-19.
//  Copyright © 2016 Apptist. All rights reserved.
//

import UIKit
import Firebase


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    private static let _instance = AppDelegate()
    
    // public instance
    
    static var instance: AppDelegate {
        return _instance
    }


    var window: UIWindow?
    
    let userDefaults = UserDefaults.standard
    
    let storyboard = UIStoryboard.init(name: "Main", bundle: nil)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FIRApp.configure()
        
        window = UIWindow.init(frame: UIScreen.main.bounds)
      
        if userDefaults.bool(forKey: "skipTutorial") == false {
        
        let initialView = storyboard.instantiateViewController(withIdentifier: "TutorialVC")
        
        window?.rootViewController = initialView
        window?.makeKeyAndVisible()

            
        }
        if userDefaults.bool(forKey: "skipTutorial") == true {
            
            if userDefaults.bool(forKey: "userJoined") == false {
                
                let initialView = storyboard.instantiateViewController(withIdentifier: "SignUpVC")
                
                window?.rootViewController = initialView
                window?.makeKeyAndVisible()
                
            }
            
            if userDefaults.bool(forKey: "userJoined") == true  {
                
                let initialView = storyboard.instantiateViewController(withIdentifier: "MyDashboardVC")
                
                window?.rootViewController = initialView
                window?.makeKeyAndVisible()
                
                if userDefaults.bool(forKey: "userLoggedIn") == true {
                    
                    let initialView = storyboard.instantiateViewController(withIdentifier: "MyDashboardVC")
                    
                    window?.rootViewController = initialView
                    window?.makeKeyAndVisible()
                }
                
                if userDefaults.bool(forKey: "userLoggedIn") == false {
                    
                    let initialView = storyboard.instantiateViewController(withIdentifier: "LogInVC")
                    
                    window?.rootViewController = initialView
                    window?.makeKeyAndVisible()
                }
            }
    
        }
        
        return true

    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

