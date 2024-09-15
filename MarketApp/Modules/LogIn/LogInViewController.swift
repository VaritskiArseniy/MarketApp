//
//  ViewController.swift
//  AppTest
//
//  Created by Арсений Варицкий on 13.12.23.
//

import UIKit
import SafariServices
import WebKit

private enum Constants {
    static var black: UIColor? { R.color.c000000() }
    static var systemBlue: UIColor? { R.color.c007AFF() }
    static var systemMint: UIColor? { R.color.c00C7BE() }
    static var backgroundColor: UIColor? { R.color.cFEFFFF() }
    static var logo: UIImage? { R.image.logo() }
    static var close: String { "Закрыть" }
    static var logInButtonText: String { "Войти" }
    static var signUpButtonText: String { "Зарегистрироваться" }
    static var privacyPolicy: String { "Политика конфиденциальности" }
    static var termsOfUse: String { "Правила пользования" }
}

protocol LogInViewControllerInterface: AnyObject {
    func showError(_ message: String)
    func logInSuccess()
}

class LogInViewController: UIViewController {
    
    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.navigationDelegate = self
        return webView
    }()
    
    private lazy var closeButtonWebView: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Constants.close, for: .normal)
        button.tintColor = Constants.systemBlue
        button.addTarget(self, action: #selector(closeWebView), for: .touchUpInside)
        return button
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private lazy var logoImageView: UIImageView = {
        let image = UIImageView()
        image.image = Constants.logo
        image.center = view.center
        image.contentMode = .scaleAspectFill
        return image
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

    private lazy var signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle(Constants.signUpButtonText, for: .normal)
        button.layer.cornerRadius = 12
        button.backgroundColor = Constants.systemBlue
        button.addTarget(self, action: #selector(signUpButtonPress), for: .touchUpInside)
        return button
    }()
    
    private lazy var logInButton: UIButton = {
        let button = UIButton()
        button.setTitle(Constants.logInButtonText, for: .normal)
        button.layer.cornerRadius = 12
        button.backgroundColor = Constants.systemMint
        button.addTarget(self, action:  #selector(logInButtonPress), for: .touchUpInside)
        return button
    }()
    
    private lazy var privacyPolicyTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = Constants.black
        textView.font = .systemFont(ofSize: 12)

        let attributedString = NSMutableAttributedString(string: Constants.privacyPolicy)
        attributedString.addAttribute(
            .underlineStyle,
            value: NSUnderlineStyle.single.rawValue,
            range: NSRange(location: 0, length: attributedString.length)
        )
        
        textView.attributedText = attributedString
        textView.textAlignment = .center
        textView.textContainerInset = UIEdgeInsets.zero

        textView.textContainerInset = UIEdgeInsets.zero
        textView.isEditable = false
        textView.isSelectable = false
        textView.isScrollEnabled = false
        
        textView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openPrivacyPolicy)))
        
        return textView
    }()

    private lazy var termsOfUseTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = Constants.black
        textView.font = .systemFont(ofSize: 12)
        
        let attributedString = NSMutableAttributedString(string: Constants.termsOfUse)
        attributedString.addAttribute(
            .underlineStyle,
            value: NSUnderlineStyle.single.rawValue,
            range: NSRange(location: 0, length: attributedString.length)
        )
        
        textView.attributedText = attributedString
        textView.textAlignment = .center
        
        textView.textContainerInset = UIEdgeInsets.zero
        textView.isEditable = false
        textView.isSelectable = false
        textView.isScrollEnabled = false
        
        textView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openTermsOfView)))
        
        return textView
    }()

    private let viewModel: LogInViewModel
    
    init(viewModel: LogInViewModel) {
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
        
        registerForKeyboardNotification()
    }
    
    private func setupUI() {
        view.backgroundColor = Constants.backgroundColor
        view.addSubview(scrollView)
        [
            logoImageView, emailTextField, passwordTextField, signUpButton,
            logInButton, privacyPolicyTextView, termsOfUseTextView, webView
        ].forEach {
            scrollView.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        
        let textFieldWidth = view.frame.width - 48
        scrollView.frame = UIScreen.main.bounds
        
        let logoX = view.center.x - 100
        let logoY = view.frame.minY
        logoImageView.frame = .init(x: logoX, y: logoY, width: view.frame.width/2, height: view.frame.width/2)
        
        let loginY = logoImageView.frame.maxY - 10
        let passwordY = loginY + 80
        emailTextField.frame = .init(x: 24, y: loginY, width: textFieldWidth, height: 56)
        passwordTextField.frame = .init(x: 24, y: passwordY, width: textFieldWidth, height: 56)
        
        let termsOfUseY = view.bounds.maxY - 160
        let privacyPolicyY = termsOfUseY - 30
        let signUpButtonY = privacyPolicyY - 70
        let logInButtonY = signUpButtonY - 70
        logInButton.frame = .init(x: 24, y: logInButtonY, width: textFieldWidth, height: 40)
        signUpButton.frame = .init(x: 24, y: signUpButtonY, width: textFieldWidth, height: 40)
        privacyPolicyTextView.frame = .init(
            x: view.center.x - 195,
            y: privacyPolicyY,
            width: 390,
            height: 12
        )
        termsOfUseTextView.frame = .init(
            x: view.center.x - 135,
            y: termsOfUseY,
            width: 270,
            height: 12
        )
        
        scrollView.contentSize = CGSize(width: view.frame.width, height: logInButton.frame.maxY)
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
    
    @objc
    private func keyboardWillShow(notification: Notification) {
        guard
            let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        else { return }
        let contentInsets = UIEdgeInsets(top: .zero, left: .zero, bottom: keyboardSize.height, right: .zero)
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
        viewModel.showSignUp()
    }
    
    @objc
    private func openPrivacyPolicy() {
        guard let url = URL(string: "https://www.google.com") else { return }
            let safariViewController = SFSafariViewController(url: url)
            present(safariViewController, animated: true, completion: nil)
    }
    
    @objc
    private func openTermsOfView() {
        let screenHeight = view.frame.height
        let safeAreaTop = view.safeAreaInsets.top
        let safeAreaBottom = view.safeAreaInsets.bottom

        let webViewHeight = screenHeight - safeAreaTop - safeAreaBottom
        let webViewRect = CGRect(
            x: 0,
            y: view.safeAreaInsets.top,
            width: view.frame.width,
            height: webViewHeight
        )

        webView.frame = webViewRect
        view.addSubview(webView)
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: Constants.close,
            style: .plain,
            target: self,
            action: #selector(closeWebView)
        )
        guard let url = URL(string: "https://www.apple.com") else { return }
            webView.load(URLRequest(url: url))
            webView.allowsBackForwardNavigationGestures = true
    }

    @objc
    private func logInButtonPress() {
        let email = emailTextField.getText() ?? ""
        let password = passwordTextField.getText() ?? ""
        
        if email.isEmpty || password.isEmpty {
            showError("Заполните все поля")
            return
        }
        
        viewModel.logIn(withEmail: email, password: password)
    }
    
    @objc
    private func closeWebView() {
        webView.stopLoading()
        webView.removeFromSuperview()
        navigationItem.rightBarButtonItem = nil
    }
}

extension LogInViewController: LogInViewControllerInterface {
    func showError(_ message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func logInSuccess() {
        viewModel.showMain()
    }
}

extension LogInViewController: WKNavigationDelegate {}

extension LogInViewController: MainTextFieldDelegate {

    func shouldReturn(_ mainTextField: MainTextField) {
        switch mainTextField.getTextField() {
        case emailTextField.getTextField():
            passwordTextField.getTextField().becomeFirstResponder()
            
        case passwordTextField.getTextField():
            passwordTextField.getTextField().resignFirstResponder()
            
        default:
            passwordTextField.getTextField().resignFirstResponder()
        }
    }
    
    func didTapDoneButton(_ mainTextField: MainTextField) {}
}
