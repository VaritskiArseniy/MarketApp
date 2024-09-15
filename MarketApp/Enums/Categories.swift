//
//  Categories.swift
//  AppTest
//
//  Created by Арсений Варицкий on 22.02.24.
//

import Foundation

enum Categories {
    case bag
    case sneakers
    case cosmetics
    case shirt
    case trousers
    case hats
    case boots
    case uggs
    case dresses
    
    var title: String {
        switch self {
        case .bag:
            return "Сумки"
            
        case .sneakers:
            return "Кеды и кроссовки"
            
        case .boots:
            return "Ботинки"
            
        case .uggs:
            return "Угги"
            
        case .cosmetics:
            return "Косметика"
            
        case .shirt:
            return "Рубашки"
            
        case .trousers:
            return "Брюки"
            
        case .hats:
            return "Головные уборы"
            
        case .dresses:
            return "Платья"
        }
    }
}
