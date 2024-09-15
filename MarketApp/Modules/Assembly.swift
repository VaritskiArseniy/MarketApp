//
//  Assembly.swift
//  AppTest
//
//  Created by Арсений Варицкий on 14.12.23.
//

import Foundation
import UIKit

final class Assembly {
    
    var realmManager: RealmManagerProtocol {
        RealmManager()
    }
    
    var userUsecase: UserUseCase {
        UserUseCaseImplementation()
    }
    
    var productUseCase: ProductUseCase {
        ProductUseCaseImplementation()
    }
    
    var adBannerUseCase: AdBannerUseCase {
        AdBannerUseCaseImplementation()
    }
    
    var shopUseCase: ShopUseCase {
        ShopUseCaseImplementation(realmManager: realmManager)
    }
    
    func makeLogIn(output: LogInOutput) -> UIViewController {
        let viewModel = LogInViewModel(output: output)
        let view = LogInViewController(viewModel: viewModel)
        viewModel.view = view
        return view
    }
    
    func makeSignUp(output: SignUpOutput) -> UIViewController {
        let viewModel = SignUpViewModel(output: output)
        let view = SignUpViewController(viewModel: viewModel)
        viewModel.view = view
        return view
    }
    
    func makeProfile(output: ProfileOutput) -> UIViewController {
        let viewModel = ProfileViewModel(output: output, userUsecase: userUsecase)
        let view = ProfileViewController(viewModel: viewModel)
        viewModel.view = view
        return view
    }
    
    func makeMap(output: MapOutput) -> UIViewController {
        let viewModel = MapViewModel(output: output, shopUseCase: shopUseCase)
        let view = MapViewController(viewModel: viewModel)
        viewModel.view = view
        return view
    }
    
    func makeCatalog(output: CatalogOutput) -> UIViewController {
        let viewModel = CatalogViewModel(output: output, productUseCase: productUseCase, adBannerUseCase: adBannerUseCase)
        let catalogViewController = CatalogViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: catalogViewController)
        
        return navigationController
    }
    
    func makeTabbar(tabs: [TabBarItem]) -> UIViewController {
        let controller = UITabBarController()
        controller.navigationItem.hidesBackButton = true
        controller.tabBar.tintColor = .c000000
        controller.tabBar.backgroundColor = .cF8F8F8
        controller.viewControllers = tabs.compactMap {
            let vc = $0.viewController
            vc.tabBarItem = $0.item
            return vc
        }
        return controller
    }
}
