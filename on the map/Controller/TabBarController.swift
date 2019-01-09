//
//  TabBarController.swift
//  on the map
//
//  Created by Matheus Lima on 06/01/19.
//  Copyright © 2019 Matheus Lima. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    @IBOutlet weak var addPinButton: UIBarButtonItem!
    
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
    
    @IBAction func refreshPressed(_ sender: Any) {
        guard let mapViewController = self.viewControllers?[0] as? MapViewController else { return }
        mapViewController.fetchAndPopulatePoints()
    }
    
    
    @IBAction func addPinPressed(_ sender: Any) {
        self.addPinButton.isEnabled = false
        /* Check if the user already has a marker on the map */
        guard let accountKey = UdacityClient.sharedInstance().accountKey else {
            print("Account key not found")
            return
        }
        
        let vc = storyboard!.instantiateViewController(withIdentifier: "AddLocationViewController") as! AddLocationViewController
        
        ParseClient.sharedInstance().getStudentLocation(withAccountKey: accountKey) { (studentLocation, errorString) in
            guard (errorString == nil) else {
                print(errorString!)
                return
            }
            
            guard (studentLocation == nil) else {
                vc.httpMethodToSubmit = "POST"
                self.navigationController?.pushViewController(vc, animated: true)
                return
            }
            
            DispatchQueue.main.async {
                self.addPinButton.isEnabled = true
                if studentLocation == nil {
                    vc.httpMethodToSubmit = "POST"
                    self.present(vc, animated: true, completion: nil)
                } else {
                    /* ALERT: Overwrite student location? */
                    let alert = UIAlertController(title: "", message: ParseClient.Messages.askOverwriteStudentLocation, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
                    alert.addAction(UIAlertAction(title: "Overwrite", style: .default, handler: { (action) in
                        /* Yes */
                        vc.httpMethodToSubmit = "PUT"
                        self.present(vc, animated: true, completion: nil)
                    }))
                    
                    /* Present alert */
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
}
