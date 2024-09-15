//
//  UserUseCase.swift
//  AppTest
//
//  Created by Арсений Варицкий on 12.02.24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

protocol UserUseCase {
    var dataSourse: [ProfileTableViewCellModel] { get }
    func fetchUser() -> UserModel
    func fetchData()
}

class UserUseCaseImplementation: UserUseCase {
    
    var dataSourse: [ProfileTableViewCellModel] = []
    private var user: UserModel?
    private let db = Firestore.firestore()
    
    init() {
        fetchData()
    }
    
    func fetchData() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let docRef = db.collection("users").document(userId)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                let name = data?["name"] as? String ?? ""
                let surname = data?["surname"] as? String ?? ""
                let phone = data?["phoneNumber"] as? String ?? ""
                let email = data?["email"] as? String ?? ""
                let birthday = data?["dateOfBirth"] as? String ?? ""
                let gender = data?["gender"] as? String ?? ""
                
                self.user = UserModel(name: name, surname: surname, gender: gender, dateBithday: birthday, phone: phone, email: email)

                self.dataSourse = [
                    ProfileTableViewCellModel(type: .name, description: name),
                    ProfileTableViewCellModel(type: .surname, description: surname),
                    ProfileTableViewCellModel(type: .phone, description: phone),
                    ProfileTableViewCellModel(type: .email, description: email),
                    ProfileTableViewCellModel(type: .birthday, description: birthday),
                    ProfileTableViewCellModel(type: .gender, description: gender)
                ]
                
                NotificationCenter.default.post(name: .dataDidUpdate, object: nil)
            } else {
                print("Document does not exist")
            }
        }
    }
    
    func fetchUser() -> UserModel {
        return user ?? UserModel(name: "", surname: "", gender: "", dateBithday: "", phone: "", email: "")
    }
}

extension Notification.Name {
    static let dataDidUpdate = Notification.Name("dataDidUpdate")
}
