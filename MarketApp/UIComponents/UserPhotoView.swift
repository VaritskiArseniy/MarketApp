//
//  ProfileImageView.swift
//  AppTest
//
//  Created by Арсений Варицкий on 3.02.24.
//

import Foundation
import UIKit
import SnapKit

private enum Constants {
    static var profileImageColor: UIColor? { R.color.c62B6B6() }
}

struct UserPhotoViewModel {
    let name: String
    let surname: String
    
    var initials: String {
        "\(name.first?.uppercased() ?? "") \(surname.first?.uppercased() ?? "")"
    }
}

class UserPhotoView: UIView {
    private lazy var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = Constants.profileImageColor
        imageView.layer.cornerRadius = 75
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var initialsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 36)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubviews([photoImageView, nameLabel])
        photoImageView.addSubview(initialsLabel)
    }
 
    private func setupConstraints() {
        photoImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(150)
        }

        initialsLabel.snp.makeConstraints {
            $0.centerX.centerY.equalTo(photoImageView)
            $0.width.height.equalTo(100)
        }
        
        nameLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(photoImageView).offset(160)
            $0.height.equalTo(28)
            $0.width.equalToSuperview()
        }
    }
    
    func configure(with model: UserPhotoViewModel) {
        nameLabel.text = "\(model.name) \(model.surname)"
        initialsLabel.text = model.initials
    }
}

