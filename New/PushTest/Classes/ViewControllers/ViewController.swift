//
//  ViewController.swift
//  PushTest
//
//  Created by Gene Backlin on 10/17/19.
//  Copyright © 2019 Gene Backlin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var badgeCountTextField: UITextField!
    @IBOutlet var entryTextField: UITextField!
    @IBOutlet var textView: UITextView!
    @IBOutlet var imageView: BadgeImageView!
    @IBOutlet var badgeNumberStepper: UIStepper!
    
    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate

    var passphrase: String? {
        return Bundle.main.object(forInfoDictionaryKey: "Passphrase") as? String
    }

    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(type(of:self).didReceivePushNotificationUpdate(_:)), name: Notifications.PushNotificationPayloadReceived, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(type(of:self).appEnteredForeground(_:)), name: UIApplication.willEnterForegroundNotification, object: nil)
        syncBadgeNumber(UIApplication.shared.applicationIconBadgeNumber)
    }
    
    // MARK: - @IBAction
    
    @IBAction func updateBadgeCount(_ sender: UIStepper) {
        UIApplication.shared.applicationIconBadgeNumber = Int(sender.value)
        textView.text = ""
        syncBadgeNumber(Int(sender.value))
    }
    
    @IBAction func sendTextToServer(_ sender: Any) {
        textView.text = ""

        if let text = badgeCountTextField.text {
            if text.count > 0 {
                if let deviceToken: String = appDelegate.token {
                    
                    let message = entryTextField.text
                    
                    //var headers: [String : AnyObject] = [String : AnyObject]()
                    //headers["Content-Type"] = "application/json" as AnyObject
                    //headers["Content-Length"] = Int(129) as AnyObject
                    //headers["Accept"] = "application/json" as AnyObject
                    
                    var parameters: [String : AnyObject] = [String : AnyObject]()
                    parameters["message"] = message as AnyObject
                    parameters["passphrase"] = passphrase as AnyObject
                    parameters["deviceToken"] = deviceToken as AnyObject
                    parameters["count"] = text as AnyObject

                    let network = Network()
                    network.post(url: "http://www.marizack.com/apns/PushTest/badgeCounter.php", token: deviceToken, headers: nil, parameters: parameters, completion: { (response, headers, error) in
                        print(response!)
                    })
                } else {
                    textView.text = "No token available"
                }
            }
        }
    }
    
    // MARK: - Utility
    
    func updateImage(number: Int) {
        if number < 1 {
            appDelegate.updateBadgeNumber(0)
            imageView.image = UIImage(named: "image")
        } else {
            appDelegate.updateBadgeNumber(number)
            if number < 10 {
                imageView.textToImage(drawText: "\(number)", inImage: UIImage(named: "image_badge")!, atPoint: CGPoint(x: 59, y: 3))
            } else {
                imageView.textToImage(drawText: "\(number)", inImage: UIImage(named: "image_badge")!, atPoint: CGPoint(x: 55, y: 3))
            }
        }
    }

    func syncBadgeNumber(_ num: Int) {
        DispatchQueue.main.async { [weak self] in
            self!.updateImage(number: num)
            self!.entryTextField.text = "\(num)"
            self!.badgeNumberStepper.value = Double(num)
        }
    }
    
    func updateBadgeNumber(_ num: Int) {
        DispatchQueue.main.async { [weak self] in
            if let previousNumber: Int = Int(self!.entryTextField.text!) {
                self!.updateImage(number: previousNumber + num)
                self!.entryTextField.text = "\(previousNumber + num)"
                self!.badgeNumberStepper.value = Double(num)
            } else {
                self!.updateImage(number: num)
                self!.entryTextField.text = "\(num)"
                self!.badgeNumberStepper.value = Double(num)
            }
        }
    }
    
    // MARK: - Notification
    
    @objc func didReceivePushNotificationUpdate(_ notification: Notification) {
        if let response = notification.object as? [String : AnyObject] {
            textView.text = "\(response)"
            let count: String = response["count"] as! String
            updateBadgeNumber(Int(count)!)
        }
    }

    @objc func appEnteredForeground(_ notification: Notification) {
        syncBadgeNumber(UIApplication.shared.applicationIconBadgeNumber)
    }

}
