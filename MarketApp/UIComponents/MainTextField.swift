//
//  MainTextField.swift
//  AppTest
//
//  Created by Арсений Варицкий on 14.12.23.
//

import Foundation
import UIKit

private enum Constants {
    static var textFieldText: UIColor? { R.color.c949494() }
    static var textFieldBackground: UIColor? { R.color.cF2F2F2() }
}

protocol MainTextFieldDelegate: AnyObject {
    func shouldReturn(_ mainTextField: MainTextField)
    func didTapDoneButton(_ mainTextField: MainTextField)
}

final class MainTextField: UIView {
    
    weak var delegate: MainTextFieldDelegate?
    
    private var type: TextFieldType
    
    private var selectedGender: Gender?
    
    private let toolbar = UIToolbar()
    
    private let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction))
    
    private let flexSpace = UIBarButtonItem(
        barButtonSystemItem: .flexibleSpace,
        target: nil,
        action: nil)
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        return textField
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = Constants.textFieldText
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private let pickerView = UIPickerView()
    
    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.maximumDate = Date()
        picker.addTarget(self, action: #selector(datePickerTapped), for: .valueChanged)
        return picker
    }()
    
    init(isSecureTextEntry: Bool = false, type: TextFieldType) {
        self.type = type
        super.init(frame: .zero)
        textField.keyboardType = type.keyboardType
        setup()
        setupUI()
        layoutSubviews()
        
        textField.isSecureTextEntry = isSecureTextEntry
        textField.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
    }
    
    private func setupConstraints() {
        textField.frame = CGRect(x: 16, y: 28, width: bounds.width - 32, height: 20)
        label.frame = CGRect(x: 16, y: 4, width: bounds.width - 32, height: 20)
        toolbar.sizeToFit()
    }
    
    private func setup() {
        label.text = type.label
        backgroundColor = Constants.textFieldBackground
        layer.cornerRadius = 12
    }
    
    private func setupUI() {
        layer.borderColor = R.color.cFF2600()?.cgColor
        addSubview(textField)
        addSubview(label)
    }
    
    func setupKeyboardType(type: UIKeyboardType) {
        textField.keyboardType = type
    }
    
    func getText() -> String? {
        return textField.text
    }
    
    func getTextField() -> UITextField {
        return textField
    }
    
    private func formatPhoneNumber(_ phoneNumber: String) -> String {
        let numbers = phoneNumber.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var formattedPhoneNumber = ""
        var index = numbers.startIndex
        
        for char in "+XXX (XX) XXX-XX-XX" where index < numbers.endIndex {
            if char == "X" {
                formattedPhoneNumber.append(numbers[index])
                index = numbers.index(after: index)
            } else {
                formattedPhoneNumber.append(char)
            }
        }
        return formattedPhoneNumber
    }
    
    private func formatPhoneNumberField(
        _ textField: UITextField,range: NSRange,
        replacementString string: String) -> Bool {
            guard let text = textField.text as NSString? else {
                return true
            }
            
            let newText = text.replacingCharacters(in: range, with: string)
            let formattedText = formatPhoneNumber(newText)
            
            textField.text = formattedText
            
            if let newPosition = textField.position(from: textField.beginningOfDocument, offset: formattedText.count) {
                textField.selectedTextRange = textField.textRange(from: newPosition, to: newPosition)
            }
            return false
        }
    
    private func validateEmail(email: String) -> Bool {
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}")
        return emailPredicate.evaluate(with: email)
    }
    
    private func checkAndPrintEmailValidity(_ email: String) {
        self.layer.borderWidth = validateEmail(email: email) ? 0 : 1
    }
    
    private func validatePassword(password: String) -> Bool {
        let proposedLength = password.count
        return proposedLength >= 8
    }
    
    private func checkAndPrintPasswordValidity(_ password: String) {
        self.layer.borderWidth = validatePassword(password: password) ? 0 : 1
    }
    
    @objc
    private func doneAction() {
        switch type {
        case .birthday:
            let ageComponents = Calendar.current.dateComponents([.year], from: datePicker.date, to: Date())
            if let age = ageComponents.year, age <= 12 {
                layer.borderColor = R.color.cFF2600()?.cgColor
                layer.borderWidth = 1
            } else {
                layer.borderWidth = 0
            }
            delegate?.didTapDoneButton(self)
            
        case .gender:
            textField.text = selectedGender?.gender
            delegate?.didTapDoneButton(self)
            
        case .phoneNumber:
            delegate?.didTapDoneButton(self)
            
        default:
            textField.resignFirstResponder()
        }
    }
    
    @objc
    private func datePickerTapped() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        textField.text = dateFormatter.string(from: datePicker.date)
    }
}

extension MainTextField: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.shouldReturn(self)
        return true
    }
    
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String) -> Bool {
            switch type {
            case .phoneNumber:
                toolbar.items = [flexSpace, doneButton]
                textField.inputAccessoryView = toolbar
                return formatPhoneNumberField(textField, range: range, replacementString: string)
            default:
                return true
            }
        }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.becomeFirstResponder()
        switch type {
        case .birthday:
            textField.inputView = datePicker
            textField.inputAccessoryView = toolbar
            toolbar.items = [flexSpace, doneButton]
            textField.inputAccessoryView = toolbar
        case .gender:
            textField.inputView = pickerView
            textField.inputAccessoryView = toolbar
            toolbar.items = [flexSpace, doneButton]
            textField.inputAccessoryView = toolbar
            pickerView.dataSource = self
            pickerView.delegate = self
        case .phoneNumber:
            textField.inputAccessoryView = toolbar
        default:
            return
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch type {
        case .name:
            self.layer.borderWidth = textField.text?.isEmpty == true ? 1 : 0
            
        case .surname:
            self.layer.borderWidth = textField.text?.isEmpty == true ? 1 : 0
            
        case .phoneNumber:
            self.layer.borderWidth = (textField.text?.isEmpty == true || textField.text?.count ?? 0 < 12) ? 1 : 0
            
        case .email:
            checkAndPrintEmailValidity(textField.text ?? "")
            
        case .password:
            self.layer.borderWidth = textField.text?.isEmpty == true ? 1 : 0
            
        case .repeatPassword:
            self.layer.borderWidth = textField.text?.isEmpty == true ? 1 : 0
            
        default:
            return
        }
    }
}

extension MainTextField: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedGender = Gender.allCases[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        Gender.allCases[row].gender
    }
}

extension MainTextField: UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        Gender.allCases.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
}
