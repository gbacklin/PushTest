//
//  AppDelegate.swift
//  PushTest
//
//  Created by Gene Backlin on 10/17/19.
//  Copyright © 2019 Gene Backlin. All rights reserved.
//
// {"aps":{"content-available":1,"alert":"","type":"open-issue-count","count":6}}
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var token: String?
    static var badgeNumber = 0
    
    // MARK: - Application Lifecycle

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        requestNotificationAuthorization(application)
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

// MARK: - Push Notification - Badge count

extension AppDelegate {
    
    func updateBadgeCount(_ data: Data) {
        do {
            let dict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject]
            let aps:[String: AnyObject] = dict!["aps"] as! [String : AnyObject]
            if let count: Int = aps["badge"] as? Int {
                DispatchQueue.main.async { [weak self] in
                    self!.updateBadgeNumber(count)
                    NotificationCenter.default.post(name: Notifications.PushNotificationPayloadReceived, object: aps, userInfo: nil)
                }
            } else if let type: String = aps["type"] as? String {
                if type == "open-issue-count" {
                    if let count: Int = aps["count"] as? Int {
                        DispatchQueue.main.async { [weak self] in
                            self!.updateBadgeNumber(count)
                            NotificationCenter.default.post(name: Notifications.PushNotificationPayloadReceived, object: aps, userInfo: nil)
                        }
                    }
                }
            }
        } catch {
            debugPrint("JSONSerialization error received: \(error.localizedDescription)")
        }
    }
    
    func updateBadgeNumber(_ number: Int) {
        AppDelegate.badgeNumber = number
        UIApplication.shared.applicationIconBadgeNumber = number
    }

    func didReceiveRemoteNotification(apsInfo: [String : AnyObject], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if apsInfo["content-available"] as? Int == 1 {
            let type: String = apsInfo["type"] as! String
            let badgeCount: Int = apsInfo["count"] as! Int
            debugPrint("content-available type: \(type) - badgeCount: \(badgeCount)")
            if type == "open-issue-count" {
                DispatchQueue.main.async { [weak self] in
                    self!.updateBadgeNumber(badgeCount)
                    NotificationCenter.default.post(name: Notifications.PushNotificationPayloadReceived, object: apsInfo, userInfo: nil)
                }
            }
            completionHandler(.newData)
        } else  {
            completionHandler(.noData)
        }
    }
    
    func handleResponse(response: UNNotificationResponse) {
        let userInfo = response.notification.request.content.userInfo
        let categoryIdentifier = response.notification.request.content.categoryIdentifier

        do {
            let data = try JSONSerialization.data(withJSONObject: userInfo, options: [])
            updateBadgeCount(data)
        } catch {
            debugPrint("JSONSerialization error received: \(error.localizedDescription) categoryIdentifier: \(categoryIdentifier)")
        }

        // Response has actionIdentifier, userText, Notification (which has Request, which has Trigger and Content)
        switch response.actionIdentifier {
        default:
            print("response.actionIdentifier: \(response.actionIdentifier)")
            break
        }
    }
}
