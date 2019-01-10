//
//  ActivityIndicatorAlert.swift
//  on the map
//
//  Created by Matheus Lima on 10/01/19.
//  Copyright © 2019 Matheus Lima. All rights reserved.
//

import UIKit

class LoaderView: UIView {
    static let instance: LoaderView = LoaderView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
    static let activityView = UIActivityIndicatorView(style: .whiteLarge)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        
        self.addSubview(LoaderView.activityView)

        LoaderView.activityView.startAnimating()
        
        self.alpha = 1.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func show() {
        var rootViewController = UIApplication.shared.keyWindow?.rootViewController!
        
        while let presentedViewController = rootViewController?.presentedViewController {
            rootViewController = presentedViewController
        }
        
        self.show(rootViewController!)
    }
    
    static func show(_ viewController: UIViewController) {
        let rootView = viewController.view
        rootView!.addSubview(instance)
        LoaderView.activityView.center = rootView!.center
        
        instance.topAnchor.constraint(equalTo: rootView!.topAnchor).isActive = true
        instance.bottomAnchor.constraint(equalTo: rootView!.bottomAnchor).isActive = true
        instance.leadingAnchor.constraint(equalTo: rootView!.leadingAnchor).isActive = true
        instance.trailingAnchor.constraint(equalTo: rootView!.trailingAnchor).isActive = true
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            instance.alpha = 1.0
        })
    }
    
    static func hide() {
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            instance.alpha = 0.0
        }, completion: { (finished) -> Void in
            instance.removeFromSuperview()
        })
    }
}
