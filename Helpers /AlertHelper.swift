//
//  AlertHelper.swift
//  RAWG_SideProject
//
//  Created by Willy Hsu on 2025/8/10.
//

import Foundation
import UIKit

class AlertHelper {
    
    static func showErrorAlert(
        from viewController: UIViewController,
        message: String
    ) {
        let alert = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )
        
        let confirmAction = UIAlertAction(title: "Done", style: .default)
        alert.addAction(confirmAction)
        
        viewController.present(alert, animated: true)
    }
}
