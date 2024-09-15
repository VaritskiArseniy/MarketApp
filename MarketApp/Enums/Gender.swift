//
//  Gender.swift
//  AppTest
//
//  Created by Арсений Варицкий on 4.01.24.
//

import Foundation

enum Gender: CaseIterable {
    case male
    case female
    
    var gender: String {
        switch self {
        case .male:
            return "Мужской"
            
        case .female:
            return "Женский"
        }
    }
}
