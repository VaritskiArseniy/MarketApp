//
//  SignUpViewModel.swift
//  AppTest
//
//  Created by Арсений Варицкий on 14.12.23.
//

import Foundation

protocol SignUpViewModelInterface {
    func showMain()
}

class SignUpViewModel {
    
    weak var view: SignUpViewControllerInterface?
    private weak var output: SignUpOutput?
    
    init(output: SignUpOutput) {
        self.output = output
    }
    
    func validateRepeatPassword(repeatPasswordTextField: MainTextField, passwordTextField: MainTextField) -> Bool {
        let repeatPassword = repeatPasswordTextField.getTextField().text
        let password = passwordTextField.getTextField().text
        if repeatPassword != password {
            return true
        } else {
            return false
        }
    }
    
    func showMain() {
        UserDefaults.standard.set(true, forKey: UserDefaultsKeys.isLaunchedBefore)
        output?.showMain()
    }
}

extension SignUpViewModel: SignUpViewModelInterface {}
