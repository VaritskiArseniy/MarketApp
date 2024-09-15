//
//  RealmManager.swift
//  AppTest
//
//  Created by Арсений Варицкий on 18.07.24.
//

import Foundation
import RealmSwift

protocol RealmManagerProtocol {
    func create(_ object: Object)
    func delete(_ object: Object)
    func write(completion: () -> Void)
    func fetchCollection<T: Object>(_ type: T.Type) -> Results<T>
}

final class RealmManager {
    let realm = try! Realm()
}

extension RealmManager: RealmManagerProtocol {
    func create(_ object: Object) {
        try? realm.write {
            realm.add(object)
        }
    }
    
    func write(completion: () -> Void) {
        try? realm.write {
            completion()
        }
    }
    
    func fetchCollection<T: Object>(_ type: T.Type) -> Results<T> {
        realm.objects(type)
    }
    
    func delete(_ object: Object) {
        try? realm.write {
            realm.delete(object)
        }
    }
}
