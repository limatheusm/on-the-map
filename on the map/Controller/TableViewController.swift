//
//  TableViewController.swift
//  on the map
//
//  Created by Matheus Lima on 09/01/19.
//  Copyright © 2019 Matheus Lima. All rights reserved.
//

import UIKit

class TableViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let parseClient = ParseClient.sharedInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func refresh() {
        guard tableView != nil else { return }
        self.tableView.reloadData()
    }
}

// MARK: TableViewDelegate & TableViewDataSource

extension TableViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentsDataSource.studentsLocation?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    /* Set row info */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        /* Get cell type */
        let cellReuseIdentifier = "TableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) ?? UITableViewCell(style: .subtitle, reuseIdentifier: cellReuseIdentifier)
        
        guard let studentsLocation = StudentsDataSource.studentsLocation else { return cell }
        let currentStudentLocation = studentsLocation[indexPath.row]
        
        /* Set cell defaults */
        let fullName = "\(currentStudentLocation.firstName ?? "Unknow") \(currentStudentLocation.lastName ?? "")"
        let image = UIImage(named: "icon_pin")
        let mediaURL = currentStudentLocation.mediaURL ?? ""
        
        cell.textLabel?.text = fullName
        cell.detailTextLabel?.text = mediaURL
        cell.imageView?.image = image
        cell.imageView?.contentMode = UIView.ContentMode.scaleAspectFit
        
        return cell
    }
    
    /* Handle touch */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let studentsLocation = StudentsDataSource.studentsLocation else { return }
        let studentLocationSelected = studentsLocation[indexPath.row]
        let mediaURL = studentLocationSelected.mediaURL
        
        if let toOpen = mediaURL {
            UIApplication.shared.open(URL(string: toOpen)!)
        }
        
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}
