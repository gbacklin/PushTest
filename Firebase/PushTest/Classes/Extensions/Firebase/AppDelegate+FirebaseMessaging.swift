//
//  AppDelegate+FirebaseMessaging.swift
//  PushTest
//
//  Created by Gene Backlin on 2/17/20.
//  Copyright © 2020 Gene Backlin. All rights reserved.
//

import UIKit
import Firebase

// MARK: - AppDelegate

extension AppDelegate {
    func initializeFirebaseMessaging() {
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
    }
}

// MARK: - Firebase Messaging Delegate

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        debugPrint("Firebase registration token: \(fcmToken)")
        let dataDict: [String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        debugPrint("Firebase didReceive remoteMessage: \(remoteMessage.appData)")
    }
}
