//
//  AppDelegate.swift
//  PushTest
//
//  Created by Gene Backlin on 10/17/19.
//  Copyright © 2019 Gene Backlin. All rights reserved.
//

import UIKit
import UserNotifications

struct Notifications {
    static let PushNotificationPayloadReceived = NSNotification.Name(rawValue: "PushNotificationPayloadReceived")
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var token: String?
    static var badgeNumber = 0

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UNUserNotificationCenter.current().delegate = self
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

// MARK: - Push Notifications

extension AppDelegate {
    func requestNotificationAuthorization(_ application: UIApplication) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (isGranted, error) in
            DispatchQueue.main.async {
                application.registerForRemoteNotifications()
                application.applicationIconBadgeNumber = AppDelegate.badgeNumber
            }
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        
        token = tokenParts.joined()
        NSLog("Device Token: \(String(describing: token!))")
    }
    
//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
//        debugPrint("didReceive response: \(userInfo)")
//        updateBadgeNumber(5)
//    }
//
    func updateBadgeNumber(_ number: Int) {
        AppDelegate.badgeNumber = number
        UIApplication.shared.applicationIconBadgeNumber = AppDelegate.badgeNumber
    }
}

// MARK: - UNUserNotificationCenterDelegate

extension AppDelegate: UNUserNotificationCenterDelegate {
    
//    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//        debugPrint("didReceive response: \(response)")
//
//        do {
//            let data = try JSONSerialization.data(withJSONObject: response.notification.request.content.userInfo, options: [])
//            let str = String(decoding: data, as: UTF8.self)
//            do {
//                //let model: BadgeNumberPushNotificationModel = try JSONDecoder().decode(BadgeNumberPushNotificationModel.self, from: data)
//                //updateBadgeNumber(model.badgeNumber)
//                NotificationCenter.default.post(name: Notifications.PushNotificationPayloadReceived, object: str, userInfo: nil)
//                debugPrint("Push Notificateion response received - badgeNumber: \(str)")
//            } catch {
//                debugPrint("Push Notificateion error received: \(error.localizedDescription)")
//            }
//        } catch {
//            debugPrint("JSONSerialization error received: \(error.localizedDescription)")
//        }
//
//    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        NSLog(response.notification.request.content.categoryIdentifier)
        do {
            let data = try JSONSerialization.data(withJSONObject: response.notification.request.content.userInfo, options: [])
            updateBadgeCount(data)
            UIApplication.shared.applicationIconBadgeNumber = 10
        } catch {
            debugPrint("JSONSerialization error received: \(error.localizedDescription)")
        }

        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Update the app interface directly.
        do {
            let data = try JSONSerialization.data(withJSONObject: notification.request.content.userInfo, options: [])
            updateBadgeCount(data)
        } catch {
            debugPrint("JSONSerialization error received: \(error.localizedDescription)")
        }
        // Play a sound.
        completionHandler(UNNotificationPresentationOptions.sound)
    }

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
}
