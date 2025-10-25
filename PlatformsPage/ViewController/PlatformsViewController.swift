//
//  PlatformsViewController.swift
//  RAWG_SideProject
//
//  Created by Willy Hsu on 2025/10/25.
//

import Foundation
import UIKit
import SnapKit
import Combine

class PlatformsViewController: UIViewController {
    
    var selectedPlatform: PlatformModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        if let platform = selectedPlatform {
            self.title = platform.name
        } else {
            self.title = "Platforms"
        }
    }
    
}
