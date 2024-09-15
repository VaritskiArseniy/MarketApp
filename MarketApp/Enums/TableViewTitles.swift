//
//  TableViewTitles.swift
//  AppTest
//
//  Created by Арсений Варицкий on 4.02.24.
//

import Foundation

enum TableViewTitles {
    case name
    case surname
    case gender
    case birthday
    case phone
    case email
    
    var title: String {
        switch self {
        case .name:
            return "Имя"
            
        case .surname:
            return "Фамилия"
            
        case .gender:
            return "Пол"
            
        case .birthday:
            return "Дата рождения"
            
        case .phone:
            return "Номер телефона"
            
        case .email:
            return "Email"
        }
    }
}
