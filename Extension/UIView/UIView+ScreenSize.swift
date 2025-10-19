//
//  UIView+ScreenSize.swift
//  RAWG_SideProject
//
//  Created by Willy Hsu on 2025/10/19.
//

import Foundation
import UIKit

extension UIView {
    func getScreenWidth() -> CGFloat {
        return window?.windowScene?.screen.bounds.width ?? bounds.width
    }

    func getScreenHeight() -> CGFloat {
        return window?.windowScene?.screen.bounds.height ?? bounds.height
    }
}
