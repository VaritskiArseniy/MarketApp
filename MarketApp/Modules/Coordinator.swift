//
//  Coordinator.swift
//  AppTest
//
//  Created by Арсений Варицкий on 14.12.23.
//

import Foundation
import UIKit

final class Coordinator {
    
    private let assembly: Assembly
    private var navigationController = UINavigationController()
        
    init(assembly: Assembly) {
        self.assembly = assembly
    }
    
    func startAuth(window: UIWindow) {
        let viewController = assembly.makeLogIn(output: self)
        navigationController = .init(rootViewController: viewController)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    func startMain(window: UIWindow) {
        let catalogViewController = assembly.makeCatalog(output: self)
        let mapViewController = assembly.makeMap(output: self)
        let profileViewController = assembly.makeProfile(output: self)
        
        let tabs: [TabBarItem] = [
            .init(
                item: .init(title: "Каталог", image: R.image.catalogTabBarIcon(), tag: .zero),
                viewController: catalogViewController
            ),
            .init(
                item: .init(title: "Магазины", image: R.image.mapTapBarIcon(), tag: 2),
                viewController: mapViewController),
            .init(
                item: .init(title: "Профиль", image: R.image.profileTabBarIcon(), tag: 1),
                viewController: profileViewController
            )
        ]
        
        let viewController = assembly.makeTabbar(tabs: tabs)
        
        window.rootViewController = viewController
        window.makeKeyAndVisible()
    }
}

// MARK: - AuthOutput

extension Coordinator: LogInOutput {
    func showSignUp() {
        let signUpView = assembly.makeSignUp(output: self)
        navigationController.pushViewController(signUpView, animated: true)
    }
    
    func showMain() {
        let catalogViewController = assembly.makeCatalog(output: self)
        let mapViewController = assembly.makeMap(output: self)
        let profileViewController = assembly.makeProfile(output: self)
        
        let tabs: [TabBarItem] = [
            .init(
                item: .init(title: "Каталог", image: R.image.catalogTabBarIcon(), tag: .zero),
                viewController: catalogViewController
            ),
            .init(
                item: .init(title: "Магазины", image: R.image.mapTapBarIcon(), tag: 2),
                viewController: mapViewController),
            .init(
                item: .init(title: "Профиль", image: R.image.profileTabBarIcon(), tag: 1),
                viewController: profileViewController
            )
        ]
        
        let viewController = assembly.makeTabbar(tabs: tabs)
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension Coordinator: SignUpOutput {}

extension Coordinator: CatalogOutput {}

extension Coordinator: ProfileOutput {}

extension Coordinator: MapOutput {}
