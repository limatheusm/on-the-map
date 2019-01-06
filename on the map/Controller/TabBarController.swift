//
//  TabBarController.swift
//  on the map
//
//  Created by Matheus Lima on 06/01/19.
//  Copyright © 2019 Matheus Lima. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: Actions
    
    @IBAction func logoutPressed(_ sender: UIBarButtonItem) {
        print("logoutPressed")
        UdacityClient.sharedInstance().logout { (success, errorString) in
            DispatchQueue.main.async {
                if success {
                    print("Logout Success")
                    self.dismiss(animated: true, completion: nil)
                } else {
                    print("Logout Failed", errorString!)
                }
            }
        }
    }
    
    @IBAction func refreshPressed(_ sender: UIBarButtonItem) {
        print("refreshPressed")
    }
    
    @IBAction func addPinPressed(_ sender: UIBarButtonItem) {
        print("addPinPressed")
    }
}
