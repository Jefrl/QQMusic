//
//  AppDelegate.swift
//  QQMusicDemo
//
//  Created by Jefrl on 17/5/17.
//  Copyright © 2017年 com.Jefrl.www. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

     var displayLink: CADisplayLink?
    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
       
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
    }


}

extension AppDelegate {
    
    func updateLockMessage() -> () {
        print("444")
        //        QQMusicOperationTool.shareInstance.setUpLockMessage()
        
    }
    
    func addDisPlayLink() -> () {
        displayLink = CADisplayLink(target: self, selector: #selector(updateLockMessage))
        displayLink?.add(to: RunLoop.current, forMode: RunLoopMode.commonModes)
    }
    
    func removeDisPlayLink() -> () {
        displayLink?.invalidate()
        displayLink = nil
    }
    
}


