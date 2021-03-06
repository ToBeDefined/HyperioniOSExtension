//
//  AppDelegate.swift
//  HyperioniOSExtensionDemo
//
//  Created by TBD on 2018/4/12.
//  Copyright © 2018年 TBD. All rights reserved.
//

import UIKit
#if CUSTOM_DEBUG
import HyperioniOSExtension
#endif

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        #if CUSTOM_DEBUG
        HYPEnvironmentSelectorManager.shared.environmentItems = [MyEnvItem.init(name: "1"),
                                                                 MyEnvItem.init(name: "2"),
                                                                 MyEnvItem.init(name: "3"),
                                                                 MyEnvItem.init(name: "4")]
        HYPEnvironmentSelectorManager.shared.customEnvironmentItemTemplate = MyEnvItem.init(name: "base")
        HYPEnvironmentSelectorManager.shared.environmentSelectedBlock = { (obj) in
            if let obj = obj as? MyEnvItem {
                var message = "EnvName: \(obj.name ?? "no name")" + HYPEnvironmentItemManage.description(forItem: obj, escapeName: true)
                message = message.replacingOccurrences(of: "Optional(\"", with: "")
                message = message.replacingOccurrences(of: "\")", with: "")
                
                let alertController = UIAlertController.init(title: "Env Selected",
                                                             message: message,
                                                             preferredStyle: .alert)
                alertController.addAction(UIAlertAction.init(title: "确定",
                                                             style: .cancel,
                                                             handler: nil))
                UIApplication.shared.keyWindow?.rootViewController?.present(alertController,
                                                                            animated: true,
                                                                            completion: nil)
                
            }
        }
        #else
        _ = MyEnvItem.init(name: "Release Item")
        #endif
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

