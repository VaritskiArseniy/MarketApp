//
//  AdBannerUseCase.swift
//  AppTest
//
//  Created by Арсений Варицкий on 22.02.24.
//

import Foundation
import UIKit
import FirebaseStorage

protocol AdBannerUseCase {
    var adBanners: [UIImage] { get }
    func fetchBanners(completion: @escaping ([UIImage]) -> Void)
}

class AdBannerUseCaseImplementation: AdBannerUseCase {
    
    var adBanners: [UIImage] = []
    
    private let storage = Storage.storage()
    private let bannerPaths = [
        "gs://marketapp-a5587.appspot.com/banners/adBanner11.png",
        "gs://marketapp-a5587.appspot.com/banners/adBanner22.png",
        "gs://marketapp-a5587.appspot.com/banners/adBanner33.png"
    ]
    
       func fetchBanners(completion: @escaping ([UIImage]) -> Void) {
           var remainingPaths = bannerPaths.count
           
           for path in bannerPaths {
               let gsReference = storage.reference(forURL: path)
               
               gsReference.getData(maxSize: 2 * 1024 * 1024) { [weak self] data, error in
                   guard let self = self else { return }
                   
                   if let error = error {
                       print("Error fetching banner: \(error.localizedDescription)")
                   } else if let data = data, let image = UIImage(data: data) {
                       self.adBanners.append(image)
                   }
                   
                   remainingPaths -= 1
                   if remainingPaths == 0 {
                       completion(self.adBanners)
                   }
               }
           }
       }
   }

