//
//  UIVIewController+Alert.swift
//  Foodie
//
//  Created by parul vats on 13/07/2019.
//  Copyright © 2019 SmartSum. All rights reserved.
//

import UIKit

extension UIViewController {
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message:
            message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
        }))
        self.present(alertController, animated: true, completion: nil)
    }
}
