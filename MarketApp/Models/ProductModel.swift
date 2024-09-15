//
//  TopProductModel.swift
//  AppTest
//
//  Created by Арсений Варицкий on 20.02.24.
//

import Foundation
import UIKit

struct ProductModel: Hashable {
    static func == (lhs: ProductModel, rhs: ProductModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    var id: Int
    var image: [String]
    var name: String
    var category: String
    var price: Double
    var mark: Double
    var purchases: Int
    var description: String
    var reviews: [ReviewModel?]
}
