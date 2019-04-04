//
//  Extensions.swift
//  TMDbDemo
//
//  Created by Pavel Belevtsev on 4/3/19.
//  Copyright © 2019 Pavel Belevtsev. All rights reserved.
//

import Foundation
import UIKit

func LS(_ S: String) -> String {
    return NSLocalizedString(S, comment: "")
}

extension UIView {
    public var safeInsets: UIEdgeInsets {
        if #available(iOS 11, *),
            let window = UIApplication.shared.keyWindow {
            return window.safeAreaInsets
        }
        return UIEdgeInsets.init(top: 20.0, left: 0.0, bottom: 0.0, right: 0.0)
    }
}

