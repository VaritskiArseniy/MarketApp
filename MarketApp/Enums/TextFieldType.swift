//
//  TextFieldType.swift
//  AppTest
//
//  Created by Арсений Варицкий on 30.12.23.
//

import Foundation
import UIKit

enum TextFieldType {
    case name
    case surname
    case gender
    case birthday
    case email
    case password
    case repeatPassword
    case phoneNumber
    
    var label: String {
        switch self {
        case .name:
            return "Имя"
            
        case .surname:
            return "Фамилия"
            
        case .gender:
            return "Пол"
            
        case .birthday:
            return "Дата рождения"
            
        case .phoneNumber:
            return "Номер телефона"
            
        case .email:
            return "Email"
            
        case .password:
            return "Пароль"
            
        case .repeatPassword:
            return "Повторите пароль"
        }
    }
    
    var keyboardType: UIKeyboardType {
        switch self {
            
        case .phoneNumber:
            return .numberPad
            
        case .email:
            return .emailAddress
        
        default:
            return .default
        }
    }
}
