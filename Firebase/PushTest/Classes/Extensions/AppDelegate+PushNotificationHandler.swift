//
//  AppDelegate+PushNotificationHandler.swift
//  PushTest
//
//  Created by Gene Backlin on 2/11/20.
//  Copyright © 2020 Gene Backlin. All rights reserved.
//

import UIKit

extension AppDelegate {
    
    // MARK: - Push Notification - Badge count handlers

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
                if let redirect: String = dict!["redirect"] as? String {
                    // This is as a result from Firebase notifications with the
                    // key being count and value a value
                    debugPrint("redirect: \(redirect)")
                    let updatedBadgeNumber = UIApplication.shared.applicationIconBadgeNumber + Int(count)!
                    updateBadgeNumber(Int(updatedBadgeNumber))
                    redirectToNewViewController(dict: dict!)
                } else {
                    let updatedBadgeNumber = UIApplication.shared.applicationIconBadgeNumber + Int(count)!
                    updateBadgeNumber(Int(updatedBadgeNumber))
                    NotificationCenter.default.post(name: Notifications.PushNotificationPayloadReceived, object: dict!, userInfo: nil)
                }
            } else if let redirect: String = dict!["redirect"] as? String {
                // This is as a result from Firebase notifications with the
                // key being count and value a value
                debugPrint("redirect: \(redirect)")
                var updatedBadgeNumber = UIApplication.shared.applicationIconBadgeNumber
                if let count: String = dict!["count"] as? String {
                    updatedBadgeNumber += Int(count)!
                    updateBadgeNumber(Int(updatedBadgeNumber))
                }
                updateBadgeNumber(Int(updatedBadgeNumber))
                redirectToNewViewController(dict: dict!)
            }
        } catch {
            debugPrint("JSONSerialization error received: \(error.localizedDescription)")
        }
    }
    
    func updateBadgeNumber(_ number: Int) {
        AppDelegate.badgeNumber = number
        UIApplication.shared.applicationIconBadgeNumber = number
    }
    
    func redirectToNewViewController(dict: [String: AnyObject]) {
        DispatchQueue.main.async { [weak self] in
            self?.window = UIWindow(frame: UIScreen.main.bounds)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let controller: APNSViewController = storyboard.instantiateViewController(withIdentifier: "APNSViewController") as? APNSViewController {
                let navigationController: UINavigationController = storyboard.instantiateViewController(withIdentifier: "APNSNavigationController") as! UINavigationController
                controller.dict = dict
                navigationController.viewControllers = [controller]
                self?.window?.rootViewController = navigationController
                self?.window?.makeKeyAndVisible()
                NotificationCenter.default.post(name: Notifications.PushNotificationPayloadReceived, object: dict, userInfo: nil)
            }
        }
    }

    // MARK: - Push Notification handlers
    
    func didReceiveRemoteNotification(userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        guard let apsInfo = userInfo["aps"] as? [String: AnyObject] else {
            completionHandler(.failed)
            return
        }
        debugPrint("didReceiveRemoteNotification apsInfo: \(apsInfo)")
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
    
    func handleDidReceiveResponseResponse(_ response: UNNotificationResponse) {
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
    
    func handleWillPresentNotification(_ data: Data) {
        updateBadgeCount(data)
    }
}
