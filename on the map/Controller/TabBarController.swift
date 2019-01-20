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
        self.fetchAndRefreshData()
    }
    
    func fetchStudentsLocation(completionHandlerForUI: @escaping () -> Void) {
        /* Fetch locations */
        ParseClient.sharedInstance().getStudentsLocation { (studentsLocation, errorString) in
            guard errorString == nil else {
                self.displayError(errorString!)
                return
            }
            
            guard let studentsLocation = studentsLocation else {
                self.displayError("Students Location null")
                return
            }
            
            /* Update singleton with new data */
            StudentsDataSource.studentsLocation = studentsLocation
            
            /* Update views */
            DispatchQueue.main.async {
                completionHandlerForUI()
            }
        }
    }
    
    func refreshUI() {
        guard let mapViewController = self.viewControllers?[0] as? MapViewController else { return }
        guard let tableViewController = self.viewControllers?[1] as? TableViewController else { return }
        mapViewController.refresh()
        tableViewController.refresh()
    }
    
    func fetchAndRefreshData() {
        LoaderView.show()
        fetchStudentsLocation {
            LoaderView.hide()
            self.refreshUI()
        }
    }

    // MARK: Actions
    
    @IBAction func logoutPressed(_ sender: UIBarButtonItem) {
        UdacityClient.sharedInstance().logout { (success, errorString) in
            DispatchQueue.main.async {
                if success {
                    self.dismiss(animated: true, completion: nil)
                } else {
                    self.displayError(errorString ?? "Logout failed")
                }
            }
        }
    }
    
    @IBAction func refreshPressed(_ sender: Any) {
        self.fetchAndRefreshData()
    }
    
    
    @IBAction func addPinPressed(_ sender: Any) {
        self.addPinButton.isEnabled = false
        /* Check if the user already has a marker on the map */
        guard let accountKey = UdacityClient.sharedInstance().accountKey else {
            self.displayError("Account key not found")
            return
        }
        
        let vc = storyboard!.instantiateViewController(withIdentifier: "AddLocationViewController") as! AddLocationViewController
        
        ParseClient.sharedInstance().getStudentLocation(withAccountKey: accountKey) { (studentLocation, errorString) in
            guard errorString == nil else {
                self.displayError(errorString!)
                return
            }
            
            DispatchQueue.main.async {
                self.addPinButton.isEnabled = true
                if studentLocation == nil {
                    vc.httpMethodToSubmit = "POST"
                    self.present(vc, animated: true, completion: nil)
                } else {
                    self.showOverwriteAlert {
                        /* Yes */
                        vc.httpMethodToSubmit = "PUT"
                        self.present(vc, animated: true, completion: nil)
                    }
                }
            }
        }
    }
}

// Helpers

extension TabBarController {
    private func displayError(_ errorString: String) {
        print(errorString)
        let alert = UIAlertController(title: "Ops!", message: errorString, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showOverwriteAlert(completionForOverwrite: @escaping () -> Void) {
        /* ALERT: Overwrite student location? */
        let alert = UIAlertController(title: "", message: ParseClient.Messages.askOverwriteStudentLocation, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Overwrite", style: .default, handler: { (action) in
            /* Yes */
            completionForOverwrite()
        }))
        /* Present alert */
        self.present(alert, animated: true, completion: nil)
    }
}
