//
//  UIAlertControllerExtensions.swift
//  TodoApp
//
//  Created by Shintaro Takemura on 2018/10/28.
//  Copyright © 2018 Shintaro Takemura. All rights reserved.
//

import UIKit

extension UIAlertController {
    func addAction(title: String, style: UIAlertAction.Style = .default, handler: ((UIAlertAction) -> Void)? = nil) -> Self {
        let alertAction = UIAlertAction(title: title, style: style, handler: handler)
        addAction(alertAction)
        return self
    }    
}
