//
//  MapViewModel.swift
//  AppTest
//
//  Created by Арсений Варицкий on 27.05.24.
//

import Foundation
import MapKit

protocol MapViewModelInterface {
    func fetchShops(completion: @escaping ([ShopModel]) -> Void)
}

class MapViewModel {
    private weak var output: MapOutput?
    weak var view: MapViewControllerInterface?

    private let shopUseCase: ShopUseCase
    
    var shopsData: [ShopModel] = []
    
    init(output: MapOutput, shopUseCase: ShopUseCase) {
        self.output = output
        self.shopUseCase = shopUseCase
    }
    
    func fetchShops(completion: @escaping ([ShopModel]) -> Void) {
        shopUseCase.fetchShops { [weak self] shops in
            guard let self = self else { return }
            self.shopsData = shops
            completion(self.shopsData)
        }
    }
    
    func fetchShopsFromRealm(completion: @escaping ([ShopModel]) -> Void) {
         shopUseCase.fetchShopFromRealm { [weak self] shops in
             guard let self = self else { return }
             self.shopsData = shops
             completion(self.shopsData)
         }
     }
    
    func shop(for annotation: MKPointAnnotation) -> ShopModel? {
        return shopsData.first { $0.latitude == annotation.coordinate.latitude && $0.longitude == annotation.coordinate.longitude }
    }
}

extension MapViewModel: MapViewModelInterface { }
