//
//  UI+Extension.swift
//  Covid News
//
//  Created by Alex Paul on 1/27/21.
//  Copyright © 2021 Alexander Paul. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func alert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
      }
}
