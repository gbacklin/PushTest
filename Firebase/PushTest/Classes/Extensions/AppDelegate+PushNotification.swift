//
//  AppDelegate+PushNotification.swift
//  PushTest
//
//  Created by Gene Backlin on 11/5/19.
//  Copyright © 2019 Gene Backlin. All rights reserved.
//

import UIKit
import Firebase

struct Notifications {
    static let PushNotificationPayloadReceived = NSNotification.Name(rawValue: "PushNotificationPayloadReceived")
}

// MARK: - Push Notifications

extension AppDelegate {
    
    // MARK: - APNS Utility
    
    func requestNotificationAuthorization(_ application: UIApplication, options: UNAuthorizationOptions = [.alert, .sound, .badge]) {
        let center = UNUserNotificationCenter.current()
        
        center.delegate = self
        center.requestAuthorization(options: options) { granted, error in
            // Enable or disable features based on authorization.
            if granted {
                center.getNotificationSettings { settings in
                    guard settings.authorizationStatus == .authorized else { return }
                    
                    if settings.alertSetting == .enabled {
                        debugPrint("Schedule an alert-only notification")
                    }
                    if settings.badgeSetting == .enabled {
                        debugPrint("Schedule an badge notification")
                    }
                    if settings.soundSetting == .enabled {
                        debugPrint("Schedule an sound notification")
                    }
                }
                
                DispatchQueue.main.async {
                    debugPrint("Registering for Remote Notifications...")
                    application.registerForRemoteNotifications()
                    application.applicationIconBadgeNumber = AppDelegate.badgeNumber
                }
            } else {
                debugPrint("In order to use this application, turn on notification permissions.")
            }
        }
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        token = tokenParts.joined()
        Messaging.messaging().apnsToken = deviceToken // For Firebase
        NSLog("Device Token: \(String(describing: token!))")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        debugPrint("didReceiveRemoteNotification userInfo: \(userInfo)")

        guard let aps = userInfo["aps"] as? [String: AnyObject] else {
            completionHandler(.failed)
            return
        }
        debugPrint("didReceiveRemoteNotification aps: \(aps)")
        didReceiveRemoteNotification(apsInfo: aps, fetchCompletionHandler: completionHandler)
    }
    
    func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [AnyHashable : Any], withResponseInfo responseInfo: [AnyHashable : Any], completionHandler: @escaping () -> Void) {
        debugPrint("handleActionWithIdentifier responseInfo: \(responseInfo)")
    }

}

// MARK: - UNUserNotificationCenterDelegate

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        debugPrint("didReceive response: \(response)")
        handleResponse(response: response)
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        debugPrint("willPresent notification: \(notification)")

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

    func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) {
        debugPrint("openSettingsFor notification")
    }

}
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

