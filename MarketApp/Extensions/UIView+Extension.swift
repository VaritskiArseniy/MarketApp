//
//  UIView+Extension.swift
//  AppTest
//
//  Created by Арсений Варицкий on 4.03.24.
//

import UIKit

extension UIView {
    func addSubviews(_ views: [UIView]) {
        views.forEach { addSubview($0) }
    }
}
