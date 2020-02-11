//
//  AppDelegate.swift
//  MSconsenter
//
//  Created by Daniel Naeh on 21/08/2019.
//  Copyright © 2019 Eldergen. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift
import Alamofire
import SwiftyJSON






@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Inside your application(application:didFinishLaunchingWithOptions:)
       // let TOKEN_URL = "https://wcbsearch.swan.ac.uk/test/token"
        let config = Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: 15,

            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { migration, oldSchemaVersion in
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
                if (oldSchemaVersion < 15) {
                    // Nothing to do!
                    // Realm will automatically detect new properties and removed properties
                    // And will update the schema on disk automatically
                }
            })

        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = config
        
        getToken()
        
        
      do {

        let myRealm = try Realm()

         
         // realm print file path
         print ("Realm URL ---------")
        
     
                        // print for test
         //let consentBitsfromLocal =  myRealm.objects(ConsentBits.self).filter("givenName  != '' ")
         //print(consentBitsfromLocal)
           
        // Important to show database name 
         print(myRealm.configuration.fileURL)
        // Override point for customization after application launch.
        UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplication.backgroundFetchIntervalMinimum)

        
        
      } catch _ as NSError {
          print("Failed to initialise database! please try later")
      }

        
        //try? FileManager.default.removeItem(at: Realm.Configuration.defaultConfiguration.fileURL!)

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
        // Saves changes in the application's managed object context before the application terminates.
    }

//    func backgroundThread(_ delay: Double = 0.0, background: (() -> Void)? = nil, completion: (() -> Void)? = nil) {
//        dispatch_get_global_queue(UInt(QOS_CLASS_USER_INITIATED.value), 0).async() {
//            background?()
//
//            let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)))
//            dispatch_after(popTime, dispatch_get_main_queue()) {
//                completion?()
//            }
//        }
//    }
    
//    func backgroundThread(background: {
//               // Your function here to run in the background
//       },
//       completion: {
//               // A function to run in the foreground when the background thread is complete
//       })
//
//
//    func backgroundThread(3.0, completion: {
//            // Your delayed function here to be run in the foreground
//    })


  func application(_ application: UIApplication,
                     performFetchWithCompletionHandler completionHandler:
                     @escaping (UIBackgroundFetchResult) -> Void) {
       // Check for new data. 
       if   ProcessSendTable(){
          completionHandler(.newData)
       }
       completionHandler(.noData)
    }

    
}

