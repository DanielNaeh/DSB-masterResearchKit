//
//  WifiSignal.swift
//  MSconsenter
//
//  Created by Daniel Naeh on 02/10/2019.
//  Copyright © 2019 Eldergen. All rights reserved.
//
import SystemConfiguration
import Alamofire


class NetworkStatus {
    
static let sharedInstance = NetworkStatus()

    
public var  connected:Bool = false

    private init() {}

let reachabilityManager = Alamofire.NetworkReachabilityManager(host: "www.google.com")

func enquireStatus (){
    
    if reachabilityManager?.isReachableOnEthernetOrWiFi ?? false
    {
        self.connected = true
    }
    else
    {
         self.connected = false
    }
}
    
    
    
func startNetworkReachabilityObserver() {
    reachabilityManager?.listener = { status in

        switch status {

        case .notReachable:
            print("The network is not reachable")
            self.connected = false
        case .unknown :
            print("It is unknown whether the network is reachable")
            self.connected = false
        case .reachable(.ethernetOrWiFi):
            print("The network is reachable over the WiFi connection")
            self.connected = true
        case .reachable(.wwan):
            print("The network is reachable over the WWAN connection")
            self.connected = true

        }
    }
    reachabilityManager?.startListening()
    }
    
}

//var backgroundTask: UIBackgroundTaskIdentifier = .invalid

//func registerBackgroundTask() {
//  backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
//    self?.endBackgroundTask()
//  }
//  assert(backgroundTask != .invalid)
//}
//
//func endBackgroundTask() {
//  print("Background task ended.")
//  UIApplication.shared.endBackgroundTask(backgroundTask)
//  backgroundTask = .invalid
//  }



// inteface for introcuing a listener in viewcontroller

//  1. define top      let networkStatus = NetworkStatus.sharedInstance
//  2. define anywhere in code a func 
 
// override func awakeFromNib() {
   //     super.awakeFromNib()
    //    networkStatus.startNetworkReachabilityObserver()
     //       if networkStatus.connected {
                
       //     }
          
  //  }
