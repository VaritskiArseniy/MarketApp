//
//  LogInViewModel.swift
//  AppTest
//
//  Created by Арсений Варицкий on 14.12.23.
//

import Foundation
import FirebaseAuth

protocol LogInViewModelInterface {
    func showSignUp()
    func showMain()
}

class LogInViewModel {
    
    weak var view: LogInViewControllerInterface?
    private weak var output: LogInOutput?
    
    init(output: LogInOutput) {
        self.output = output
    }
}

extension LogInViewModel: LogInViewModelInterface {
    func showSignUp() {
        output?.showSignUp()
    }
    
    func showMain() {
        UserDefaults.standard.set(true, forKey: UserDefaultsKeys.isLaunchedBefore)
        output?.showMain()
    }
    
    func logIn(withEmail email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                self?.view?.showError(error.localizedDescription)
                return
            }
            self?.view?.logInSuccess()
        }
    }
}
