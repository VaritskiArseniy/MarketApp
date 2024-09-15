//
//  PinAnnitationView.swift
//  AppTest
//
//  Created by Арсений Варицкий on 6.06.24.
//

import UIKit

class PinAnotationView: UIView {

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()
    
    private lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        return label
    }()
    
    private lazy var cityLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .thin)
        return label
    }()

    private lazy var phoneLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .thin)
        return label
    }()
    

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
        setupConstraints()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with model: ShopModel) {
        nameLabel.text = model.name
        addressLabel.text = model.address
        cityLabel.text = model.city
        phoneLabel.text = model.number
    }
    
    
    private func setupUI() {
        backgroundColor = .white
        layer.cornerRadius = 22
        stackView.addArrangedSubviews([nameLabel, addressLabel, cityLabel, phoneLabel])
        addSubviews([stackView])
    }
    
    private func setupConstraints() {
        stackView.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview().offset(16)
        }
    }
}
