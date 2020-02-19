//
//  APNSViewController.swift
//  PushTest
//
//  Created by Gene Backlin on 2/19/20.
//  Copyright © 2020 Gene Backlin. All rights reserved.
//

import UIKit

class APNSViewController: UIViewController {
    @IBOutlet var countLabel: UILabel!

    var dict: [String: AnyObject]?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let count: String = dict!["count"] as? String {
            countLabel.text = count
        } else {
            countLabel.text = "0"
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
