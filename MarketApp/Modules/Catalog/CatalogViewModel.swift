//
//  CatalogViewModel.swift
//  AppTest
//
//  Created by Арсений Варицкий on 8.02.24.
//

import Foundation
import UIKit
 
protocol CatalogViewModelInterface {
    func fetchProducts(completion: @escaping ([ProductModel]) -> Void)
    func fetchTopProducts(completion: @escaping ([ProductModel]) -> Void)
    func sortProductByPrice(products: [ProductModel]) -> [ProductModel]
    func sortProductByMark(products: [ProductModel]) -> [ProductModel]
    func sortProductByPurchase(products: [ProductModel]) -> [ProductModel]
//    func filterProduct(searchText: String, completion: @escaping ([ProductModel]) -> Void)
    func filterProduct(searchText: String) -> [ProductModel]
    func fetchBanners(completion: @escaping () -> Void)
}

class CatalogViewModel {
    private weak var output: CatalogOutput?
    
    private var productUseCase: ProductUseCase
    private var adBannerUseCase: AdBannerUseCase
    
    var bannerImages: [UIImage] = []
    var productsData: [ProductModel] = []
    var topProductsData: [ProductModel] = []

    init(
        output: CatalogOutput,
        productUseCase: ProductUseCase,
        adBannerUseCase: AdBannerUseCase
    ) {
        self.output = output
        self.productUseCase = productUseCase
        self.adBannerUseCase = adBannerUseCase
    }
    
    func fetchProducts(completion: @escaping ([ProductModel]) -> Void) {
        productUseCase.fetchProducts { [weak self] products in
            guard let self = self else { return }
            let sortedProducts = Array(Set(products))
            self.productsData = sortedProducts
            completion(self.productsData)
        }
    }
    
    func fetchTopProducts(completion: @escaping ([ProductModel]) -> Void) {
        productUseCase.fetchTopProducts { [weak self] topProducts in
            guard let self = self else { return }
            self.topProductsData = topProducts
            completion(topProducts)
        }
    }
    
    func sortProductByPrice(products: [ProductModel]) -> [ProductModel] {
        return products.sorted { $0.price > $1.price }
    }
    
    func sortProductByMark(products: [ProductModel]) -> [ProductModel] {
        return products.sorted { $0.mark > $1.mark }
    }
    
    func sortProductByPurchase(products: [ProductModel]) -> [ProductModel] {
        return products.sorted { $0.purchases > $1.purchases }
    }
    
    func filterProduct(searchText: String) -> [ProductModel] {
        let filteredProducts: [ProductModel]
        if searchText.isEmpty {
            filteredProducts = productsData
        } else {
            filteredProducts = productsData.filter { product in
                return product.name.lowercased().contains(searchText.lowercased())
                
            }
        }
        
        return filteredProducts
    }
    
    func fetchBanners(completion: @escaping () -> Void) {
        adBannerUseCase.fetchBanners { [weak self] banners in
            guard let self = self else { return }
            self.bannerImages = banners
            completion()
        }
    }
}

extension CatalogViewModel: CatalogViewModelInterface {}
