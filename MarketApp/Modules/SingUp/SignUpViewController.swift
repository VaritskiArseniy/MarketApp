//
//  SignUpViewController.swift
//  AppTest
//
//  Created by Арсений Варицкий on 13.12.23.
//

import UIKit
import RswiftResources
import FirebaseAuth
import FirebaseFirestoreInternal

private enum Constants {
    static var black: UIColor? { R.color.c000000() }
    static var backgroundColor: UIColor? { R.color.cFEFFFF() }
    static var systemBlue: UIColor? { R.color.c007AFF() }
    static var logo: UIImage? { R.image.logo() }
    static var backButtonImage: UIImage? { R.image.backButtonImage() }
    static var textFieldHeight: CGFloat { 56 }
    static var signUpButtonText: String { "Зарегистрироваться" }
}

protocol SignUpViewControllerInterface: AnyObject {}

class SignUpViewController: UIViewController {
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private lazy var logoImageView: UIImageView = {
        let image = UIImageView()
        image.image = Constants.logo
        image.center = view.center
        return image
    }()
    
    private lazy var nameTextField: MainTextField = {
        let textField = MainTextField(type: .name)
        textField.delegate = self
        return textField
    }()
    
    private lazy var surnameTextField: MainTextField = {
        let textField = MainTextField(type: .surname)
        textField.delegate = self
        return textField
    }()
    
    private lazy var genderPickerView: MainTextField = {
        let textField = MainTextField(type: .gender)
        textField.delegate = self
        return textField
    }()
    
    private lazy var datePickerView: MainTextField = {
        let textField = MainTextField(type: .birthday)
        textField.delegate = self
        return textField
    }()
    
    private lazy var numberTextField: MainTextField = {
        let textField = MainTextField(type: .phoneNumber)
        textField.delegate = self
        return textField
    }()
    
    private lazy var emailTextField: MainTextField = {
        let textField = MainTextField(type: .email)
        textField.delegate = self
        return textField
    }()
    
    private lazy var passwordTextField: MainTextField = {
        let textField = MainTextField(isSecureTextEntry: true, type: .password)
        textField.delegate = self
        return textField
    }()
    
    private lazy var repeatPasswordTextField: MainTextField = {
        let textField = MainTextField(isSecureTextEntry: true, type: .repeatPassword)
        textField.delegate = self
        return textField
    }()
    
    private lazy var signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle(Constants.signUpButtonText, for: .normal)
        button.layer.cornerRadius = 12
        button.backgroundColor = Constants.systemBlue
        button.addTarget(self, action: #selector(signUpButtonPress), for: .touchUpInside)
        return button
    }()
    
    private let viewModel: SignUpViewModel
    
    init(viewModel: SignUpViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupCustomBackButton()
        
        registerForKeyboardNotification()
    }
    
    private func setupUI() {
        view.backgroundColor = Constants.backgroundColor
        view.addSubview(scrollView)
        scrollView.addSubviews([
            logoImageView,
            nameTextField,
            surnameTextField,
            genderPickerView,
            datePickerView,
            numberTextField,
            emailTextField,
            passwordTextField,
            repeatPasswordTextField,
            signUpButton
        ])
    }
    
    private func setupConstraints() {
        let logoX = view.center.x - 100
        let logoY = view.frame.minY
        let nameTfY = logoY + 200
        let surnameTfY = nameTfY + 80
        let gengerPvY = surnameTfY + 80
        let datePY = gengerPvY + 80
        let numberTFY = datePY + 80
        let emailTFY = numberTFY + 80
        let passwordTFY = emailTFY + 80
        let repeatPasswordTFY = passwordTFY + 80
        let signUpButtonY = repeatPasswordTFY + 110
        let textFieldWidth = view.frame.width - 48
        scrollView.frame = UIScreen.main.bounds
        logoImageView.frame = .init(x: logoX, y: logoY, width: 200, height: 200)
        nameTextField.frame = .init(
            x: 20,
            y: nameTfY,
            width: textFieldWidth,
            height: Constants.textFieldHeight
        )
        surnameTextField.frame = .init(
            x: 20,
            y: surnameTfY,
            width: textFieldWidth,
            height: Constants.textFieldHeight
        )
        genderPickerView.frame = .init(
            x: 20,
            y: gengerPvY,
            width: textFieldWidth,
            height: Constants.textFieldHeight
        )
        datePickerView.frame = .init(
            x: 20,
            y: datePY,
            width: textFieldWidth,
            height: Constants.textFieldHeight
        )
        numberTextField.frame = .init(
            x: 20,
            y: numberTFY,
            width: textFieldWidth,
            height: Constants.textFieldHeight
        )
        emailTextField.frame = .init(
            x: 20,
            y: emailTFY,
            width: textFieldWidth,
            height: Constants.textFieldHeight
        )
        passwordTextField.frame = .init(
            x: 20,
            y: passwordTFY,
            width: textFieldWidth,
            height: Constants.textFieldHeight
        )
        repeatPasswordTextField.frame = .init(
            x: 20,
            y: repeatPasswordTFY,
            width: textFieldWidth,
            height: Constants.textFieldHeight
        )
        signUpButton.frame = .init(x: 24, y: signUpButtonY, width: textFieldWidth, height: 40)
        
        scrollView.contentSize = CGSize(
            width: view.frame.width,
            height: signUpButton.frame.maxY + 20
        )
    }
    
    private func registerForKeyboardNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapOutsiteKeyboard))
        scrollView.addGestureRecognizer(tapGesture)
    }
    
    private func findActiveTextField() -> UIView? {
        for view in scrollView.subviews {
            if let textField = view as? UITextField, textField.isFirstResponder {
                return textField
            }
        }
        return nil
    }
    
    private func setupCustomBackButton() {
        let backImage = Constants.backButtonImage
        self.navigationController?.navigationBar.backIndicatorImage = backImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        self.navigationController?.navigationBar.tintColor = Constants.black
        self.navigationController?.navigationBar.topItem?.title = ""
    }
    
    @objc
    private func keyboardWillShow(notification: Notification) {
        guard
            let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        else { return }
        let contentInsets = UIEdgeInsets(
            top: .zero,
            left: .zero,
            bottom: keyboardSize.height,
            right: .zero
        )
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        
        guard let activeField = findActiveTextField() else { return }
        let textFieldFrame = activeField.convert(activeField.bounds, to: scrollView)
        let visibleRect = CGRect(
            x: .zero,
            y: textFieldFrame.origin.y,
            width: 1,
            height: textFieldFrame.size.height
        )
        scrollView.scrollRectToVisible(visibleRect, animated: true)
    }
    
    @objc
    private func keyboardWillHide(notification: Notification) {
        scrollView.contentInset = UIEdgeInsets.zero
        scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
    }
    
    @objc
    private func tapOutsiteKeyboard() {
        view.endEditing(true)
    }
    
    @objc
    private func signUpButtonPress() {
        guard let name = nameTextField.getTextField().text, !name.isEmpty,
              let surname = surnameTextField.getTextField().text, !surname.isEmpty,
              let gender = genderPickerView.getTextField().text, !gender.isEmpty,
              let date = datePickerView.getTextField().text, !date.isEmpty,
              let number = numberTextField.getTextField().text, !number.isEmpty,
              let email = emailTextField.getTextField().text, !email.isEmpty,
              let password = passwordTextField.getTextField().text, !password.isEmpty,
              let repeatPassword = repeatPasswordTextField.getTextField().text, !repeatPassword.isEmpty
        else {
            let alertController = UIAlertController(title: "Внимание", message: "Пожалуйста, заполните все поля", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
            return
        }
        
        let checkPassword = viewModel.validateRepeatPassword(
            repeatPasswordTextField: repeatPasswordTextField,
            passwordTextField: passwordTextField
        )
        repeatPasswordTextField.layer.borderWidth = checkPassword ? 1 : 0
        
        guard checkPassword == false else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                let alertController = UIAlertController(title: "Ошибка", message: error.localizedDescription, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
                return
            }
            
            let db = Firestore.firestore()
            let userID = Auth.auth().currentUser?.uid
            db.collection("users").document(userID!).setData([
                "name": name,
                "surname": surname,
                "gender": gender,
                "dateOfBirth": date,
                "phoneNumber": number,
                "email": email,
            ]) { error in
                if let error = error {
                    let alertController = UIAlertController(title: "Ошибка", message: error.localizedDescription, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                    return
                }
                
                self.viewModel.showMain()
            }
        }
        
    }
}

extension SignUpViewController:  ProfileOutput {}

extension SignUpViewController: SignUpViewControllerInterface {}

extension SignUpViewController: MainTextFieldDelegate {
    func shouldReturn(_ mainTextField: MainTextField) {
        switch mainTextField.getTextField() {
        case nameTextField.getTextField():
            surnameTextField.getTextField().becomeFirstResponder()
            
        case surnameTextField.getTextField():
            genderPickerView.getTextField().becomeFirstResponder()
            
        case numberTextField.getTextField():
            emailTextField.getTextField().becomeFirstResponder()
            
        case emailTextField.getTextField():
            passwordTextField.getTextField().becomeFirstResponder()
            
        case passwordTextField.getTextField():
            repeatPasswordTextField.getTextField().becomeFirstResponder()
            
        case repeatPasswordTextField.getTextField():
            repeatPasswordTextField.getTextField().resignFirstResponder()
            
        default:
            repeatPasswordTextField.getTextField().resignFirstResponder()
        }
    }
    
    func didTapDoneButton(_ mainTextField: MainTextField) {
        switch mainTextField.getTextField() {
        case genderPickerView.getTextField():
            datePickerView.getTextField().becomeFirstResponder()
            
        case datePickerView.getTextField():
            numberTextField.getTextField().becomeFirstResponder()
            
        case numberTextField.getTextField():
            emailTextField.getTextField().becomeFirstResponder()
            
        default:
            mainTextField.getTextField().resignFirstResponder()
        }
    }
}

