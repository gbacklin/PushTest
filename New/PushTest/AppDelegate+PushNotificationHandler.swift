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
