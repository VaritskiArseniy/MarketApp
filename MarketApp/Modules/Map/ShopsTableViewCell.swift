//
//  ShopsTableViewCell.swift
//  AppTest
//
//  Created by Арсений Варицкий on 31.05.24.
//

import UIKit

class ShopsTableViewCell: UITableViewCell {
    
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
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
    
    
    private func setup() {
        stackView.addArrangedSubviews([nameLabel, addressLabel, cityLabel, phoneLabel])
        contentView.addSubviews([stackView])
        
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.trailing.equalToSuperview()
        }
    }
}
