//
//  AppDelegate.swift
//  TestCode
//
//  Created by Zhouheng on 2020/6/3.
//  Copyright © 2020 tataUFO. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let nav = UINavigationController(rootViewController: FMRootViewController())
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
        
        return true
    }


}

