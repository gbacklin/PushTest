//
//  ViewController.swift
//  PushTest
//
//  Created by Gene Backlin on 9/7/17.
//  Copyright © 2017 Gene Backlin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var inputTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func send(_ sender: Any) {
        if let text = inputTextField.text {
            if text.count > 0 {
                if let deviceToken: String = ((UIApplication.shared.delegate) as! AppDelegate).token {
                    
                    let message = inputTextField.text
                    let passphrase = "marissa123"
                    
//                    var headers: [String : AnyObject] = [String : AnyObject]()
//                    headers["Content-Type"] = "application/json" as AnyObject
//                    headers["Content-Length"] = Int(129) as AnyObject
//                    headers["Accept"] = "application/json" as AnyObject

                    var parameters: [String : AnyObject] = [String : AnyObject]()
                    parameters["message"] = message as AnyObject
                    parameters["passphrase"] = passphrase as AnyObject
                    parameters["deviceToken"] = deviceToken as AnyObject

                    let network = Network()
                    network.post(url: "http://www.marizack.com/apns/parameterPush.php", token: deviceToken, headers: nil, parameters: parameters, completion: { (response, headers, error) in
                        print("response: \(String(describing: response))")
                    })
                }
            }
        }
    }
    
}

