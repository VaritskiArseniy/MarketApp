//
//  UIImage+Extension.swift
//  AppTest
//
//  Created by Арсений Варицкий on 24.07.24.
//

import Foundation
import UIKit
import FirebaseStorage

private let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    func loadImageUsingCacheWithUrlString(urlString: String) {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.hidesWhenStopped = true
        self.addSubview(activityIndicator)
        activityIndicator.center = self.center
        activityIndicator.startAnimating()
        
        
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            self.image = cachedImage
            activityIndicator.stopAnimating()
            return
        }
        guard urlString.isValidURL() else { return }
        Storage.storage().reference(forURL: urlString).getData(maxSize: 5 * 1024 * 1024) { data, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                guard let data = data else { return }
                DispatchQueue.main.async {
                    guard let downloadedImage = UIImage(data: data) else {
                        return
                    }
                    imageCache.setObject(downloadedImage, forKey: urlString as NSString)
                    activityIndicator.stopAnimating()
                    self.image = downloadedImage
                }
            }
        }
    }
}
