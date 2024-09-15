//
//  String+Extension.swift
//  AppTest
//
//  Created by Арсений Варицкий on 3.01.24.
//

import Foundation
import UIKit
import FirebaseStorage

extension String {
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
    
    func isValidURL() -> Bool {
        self.hasPrefix("gs://") || self.hasPrefix("http://") || self.hasPrefix("https://")
    }
}
