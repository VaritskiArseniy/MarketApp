//
//  ProductViewModel.swift
//  AppTest
//
//  Created by Арсений Варицкий on 13.05.24.
//

import Foundation

protocol ProductViewModelInterface {
    
}

class ProductViewModel {
    private weak var output: ProductOutput?

    init(output: ProductOutput? = nil) {
        self.output = output
    }
}

extension ProductViewModel: ProductViewModelInterface {}
