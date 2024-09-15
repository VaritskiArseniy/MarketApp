//
//  ProfileViewModel.swift
//  AppTest
//
//  Created by Арсений Варицкий on 13.01.24.
//

import Foundation

protocol ProfileViewModelInterface {
    var dataSourse: [ProfileTableViewCellModel] { get }
    var userPhotoModel: UserPhotoViewModel { get }
    func updateData()
}

class ProfileViewModel {
    weak var view: ProfileViewControllerInterface?
    private weak var output: ProfileOutput?
    private let userUsecase: UserUseCase
    
    var dataSourse: [ProfileTableViewCellModel] {
        return userUsecase.dataSourse
    }
    
    var userPhotoModel: UserPhotoViewModel {
        let user = userUsecase.fetchUser()
        return UserPhotoViewModel(name: user.name, surname: user.surname)
    }
    
    var nameText = String()
    var initialsText = String()
    
    init(
        output: ProfileOutput,
        userUsecase: UserUseCase
    ) {
        self.output = output
        self.userUsecase = userUsecase
        NotificationCenter.default.addObserver(self, selector: #selector(updateData), name: .dataDidUpdate, object: nil)
    }
    
    @objc func updateData() {
        view?.updateNameLabel(name: userUsecase.fetchUser().name, surname: userUsecase.fetchUser().surname)
        view?.updateTableView()
    }
}

extension ProfileViewModel: ProfileViewModelInterface { }
