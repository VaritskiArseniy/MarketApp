//
//  DateFormater+Extension.swift
//  AppTest
//
//  Created by Арсений Варицкий on 26.05.24.
//

import Foundation

extension DateFormatter {
    static let reviewDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }()
}
