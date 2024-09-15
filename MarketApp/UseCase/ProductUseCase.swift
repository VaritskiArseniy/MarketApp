//
//  ProductUseCase.swift
//  AppTest
//
//  Created by Арсений Варицкий on 22.02.24.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage
import FirebaseFirestore

protocol ProductUseCase {
    func fetchProducts(completion: @escaping ([ProductModel]) -> Void)
    func fetchTopProducts(completion: @escaping ([ProductModel]) -> Void)
    var products: [ProductModel] { get }
    var topProducts: [ProductModel] { get }
    func addNewProduct(_ product: ProductModel)
}

class ProductUseCaseImplementation: ProductUseCase {
    
    private let database = Database.database().reference()
    private let storage = Storage.storage()
    
    var products: [ProductModel] = []
    
    var topProducts: [ProductModel] = []
    
    func addNewProduct(_ product: ProductModel) {
        products.append(product)
    }
    
    func fetchProducts(completion: @escaping ([ProductModel]) -> Void) {
        products = []
        let dispatchQueue = DispatchQueue(label: "product.fetching.queue", qos: .userInitiated)
        dispatchQueue.async {
            self.fetchProductData { productDicts in
                self.processProductData(productDicts) { products in
                    DispatchQueue.main.async {
                        completion(products)
                    }
                }
            }
        }
    }
    
    private func fetchProductData(completion: @escaping ([Dictionary<String, Any>]) -> Void) {
        var productDicts: [Dictionary<String, Any>] = []
        database.child("products").queryOrdered(byChild: "id").observeSingleEvent(of: .value, with: { [weak self] snapshot in
            guard let self = self else { return }
            
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                   let productDict = childSnapshot.value as? [String: Any] {
                    productDicts.append(productDict)
                }
            }
            completion(productDicts)
        })
    }
    
    private func processProductData(_ productDicts: [Dictionary<String, Any>], completion: @escaping ([ProductModel]) -> Void) {
        var completedProducts: [ProductModel] = []
        let productDispatchGroup = DispatchGroup()

        for productDict in productDicts {
            productDispatchGroup.enter()
            DispatchQueue.global(qos: .userInitiated).async {
                self.fetchProductReviews(productDict: productDict) { reviews in
                    let images = productDict["image"] as? [String] ?? []
                    let id = productDict["id"] as? Int ?? 0
                    let name = productDict["name"] as? String ?? ""
                    let category = productDict["category"] as? String ?? ""
                    let price = productDict["price"] as? Double ?? 0.0
                    let mark = productDict["mark"] as? Double ?? 0.0
                    let purchases = productDict["purchases"] as? Int ?? 0
                    let description = productDict["description"] as? String ?? ""

                    let product = ProductModel(id: id, image: images, name: name, category: category, price: price, mark: mark, purchases: purchases, description: description, reviews: reviews)
                    completedProducts.append(product)
                    productDispatchGroup.leave()
                }
            }
        }

        productDispatchGroup.notify(queue: .main) {
            completion(completedProducts)
        }
    }
    
    private func fetchProductReviews(productDict: [String: Any], completion: @escaping ([ReviewModel]) -> Void) {
        var reviews: [ReviewModel] = []
        let reviewDispatchGroup = DispatchGroup()

        if let reviewsDict = productDict["reviews"] as? [String: [String: Any]] {
            for (_, reviewData) in reviewsDict {
                reviewDispatchGroup.enter()
                if let id = reviewData["id"] as? Int,
                   let dateString = reviewData["date"] as? String,
                   let mark = reviewData["mark"] as? Float,
                   let review = reviewData["review"] as? String,
                   let title = reviewData["title"] as? String,
                   let userName = reviewData["userName"] as? String {

                    let userPhotoUrl = reviewData["userPhoto"] as? String ?? ""
                    fetchImage(from: userPhotoUrl) { userPhoto in
                        if let date = DateFormatter.reviewDateFormatter.date(from: dateString) {
                            let reviewModel = ReviewModel(id: id, userName: userName, userPhoto: userPhoto, date: date, mark: mark, title: title, review: review)
                            reviews.append(reviewModel)
                        }
                        reviewDispatchGroup.leave()
                    }
                } else {
                    reviewDispatchGroup.leave()
                }
            }
        }

        reviewDispatchGroup.notify(queue: .main) {
            completion(reviews)
        }
    }

    func fetchTopProducts(completion: @escaping ([ProductModel]) -> Void) {
        fetchProducts { [weak self] products in
            guard let self = self else { return }
            let sortedProducts = Array(Set(products.sorted { $0.id < $1.id }))
            self.topProducts = Array(sortedProducts.prefix(9))
            completion(self.topProducts)
        }
    }
    
    private func fetchImage(from url: String, completion: @escaping (UIImage?) -> Void) {
        
        guard url.hasPrefix("gs://") || url.hasPrefix("http://") || url.hasPrefix("https://") else {
            print("Invalid URL scheme: \(url)")
            completion(nil)
            return
        }
        
        let gsReference = storage.reference(forURL: url)
        let localURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        
        let downloadTask = gsReference.write(toFile: localURL) { url, error in
            if let error = error {
                print("Error fetching image: \(error.localizedDescription)")
                completion(nil)
            } else if let url = url {
                do {
                    let data = try Data(contentsOf: url)
                    let image = UIImage(data: data)
                    completion(image)
                } catch {
                    print("Error reading image data: \(error.localizedDescription)")
                    completion(nil)
                }
            } else {
                completion(nil)
            }
        }
        
        downloadTask.resume()
    }
}
