//
//  ShopUseCase.swift
//  AppTest
//
//  Created by Арсений Варицкий on 31.05.24.
//

import Foundation
import MapKit
import FirebaseDatabase
import FirebaseStorage
import RealmSwift

protocol ShopUseCase {
    func fetchShops(completion: @escaping ([ShopModel]) -> Void)
    func fetchShopFromRealm(completion: @escaping ([ShopModel]) -> Void) 
}

class ShopUseCaseImplementation {
    
    private let database = Database.database().reference()
    private let storage = Storage.storage()
    private let realmManager: RealmManagerProtocol
    
    init(realmManager: RealmManagerProtocol) {
        self.realmManager = realmManager
    }
    
    var shops: [ShopModel] = []
    
    func fetchShops(completion: @escaping ([ShopModel]) -> Void) {
        shops = []
        database.child("shops").observeSingleEvent(of: .value, with: { [weak self] snapshot in
            let dispatchGroup = DispatchGroup() 
            guard let self = self else { return }
            for child in snapshot.children {
                dispatchGroup.enter()
                if let childSnapshot = child as? DataSnapshot,
                   let productDict = childSnapshot.value as? [String: Any] {
                    
                    let name = productDict["name"] as? String ?? ""
                    let address = productDict["address"] as? String ?? ""
                    let city = productDict["city"] as? String ?? ""
                    let number = productDict["number"] as? String ?? ""
                    let latitude = productDict["latitude"] as? Double ?? 0.0
                    let longitude = productDict["longitude"] as? Double ?? 0.0
                    
                    let shop = ShopModel(
                        name: name,
                        address: address,
                        city: city,
                        number: number,
                        latitude: latitude,
                        longitude: longitude
                    )
                    self.shops.append(shop)
                    
                    let shopRM = ShopRM(name: name, address: address, city: city, number: number, latitude: latitude, longitude: longitude)
                    self.realmManager.create(shopRM)
                    
                    dispatchGroup.leave()
                }
            }
                completion(self.shops)
            
        })
    }
    
    func fetchShopFromRealm(completion: @escaping ([ShopModel]) -> Void) {
        let results: Results<ShopRM> = realmManager.fetchCollection(ShopRM.self)
        let shops: [ShopModel] = results.map { shopRM in
            ShopModel(
                name: shopRM.name,
                address: shopRM.address,
                city: shopRM.city,
                number: shopRM.number,
                latitude: shopRM.latitude,
                longitude: shopRM.longitude
            )
        }
        completion(shops)
    }
}

extension ShopUseCaseImplementation: ShopUseCase { }

