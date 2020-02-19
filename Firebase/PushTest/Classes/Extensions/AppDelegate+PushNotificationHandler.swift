//
//  AppDelegate+PushNotificationHandler.swift
//  PushTest
//
//  Created by Gene Backlin on 2/11/20.
//  Copyright © 2020 Gene Backlin. All rights reserved.
//

import UIKit

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
            } else if let count: String = dict!["count"] as? String {
                // This is as a result from Firebase notifications with the
                // key being count and value a value
                DispatchQueue.main.async { [weak self] in
                    if let redirect: String = dict!["redirect"] as? String {
                        // This is as a result from Firebase notifications with the
                        // key being count and value a value
                        debugPrint("redirect: \(redirect)")
                        DispatchQueue.main.async { [weak self] in
                            self?.window = UIWindow(frame: UIScreen.main.bounds)
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            if let controller: APNSViewController = storyboard.instantiateViewController(withIdentifier: "APNSViewController") as? APNSViewController {
                                let navigationController: UINavigationController = storyboard.instantiateViewController(withIdentifier: "APNSNavigationController") as! UINavigationController
                                controller.dict = dict
                                navigationController.viewControllers = [controller]
                                self?.window?.rootViewController = navigationController
                                self?.window?.makeKeyAndVisible()
                                NotificationCenter.default.post(name: Notifications.PushNotificationPayloadReceived, object: dict!, userInfo: nil)
                            }
                        }
                    } else {
                        self!.updateBadgeNumber(Int(count)!)
                        NotificationCenter.default.post(name: Notifications.PushNotificationPayloadReceived, object: dict!, userInfo: nil)
                    }
                }
            } else if let redirect: String = dict!["redirect"] as? String {
                // This is as a result from Firebase notifications with the
                // key being count and value a value
                debugPrint("redirect: \(redirect)")
                DispatchQueue.main.async { [weak self] in
                    self?.window = UIWindow(frame: UIScreen.main.bounds)
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    if let controller: APNSViewController = storyboard.instantiateViewController(withIdentifier: "APNSViewController") as? APNSViewController {
                        let navigationController: UINavigationController = storyboard.instantiateViewController(withIdentifier: "APNSNavigationController") as! UINavigationController
                        controller.dict = dict
                        navigationController.viewControllers = [controller]
                        self?.window?.rootViewController = navigationController
                        self?.window?.makeKeyAndVisible()
                        NotificationCenter.default.post(name: Notifications.PushNotificationPayloadReceived, object: dict!, userInfo: nil)
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
            let badgeCount: String = apsInfo["count"] as! String
            debugPrint("content-available type: \(type) - badgeCount: \(badgeCount)")
            if type == "open-issue-count" {
                DispatchQueue.main.async { [weak self] in
                    self!.updateBadgeNumber(Int(badgeCount)!)
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
