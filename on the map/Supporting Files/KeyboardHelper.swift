//
//  KeyboardHelper.swift
//  on the map
//
//  Created by Matheus Lima on 06/01/19.
//  Copyright © 2019 Matheus Lima. All rights reserved.
//

import Foundation

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
