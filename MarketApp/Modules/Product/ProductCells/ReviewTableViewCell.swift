//
//  ReviewTableViewCell.swift
//  AppTest
//
//  Created by Арсений Варицкий on 19.05.24.
//

import UIKit

class ReviewTableViewCell: UITableViewCell {

    private enum Constants {
        static var personImage = { UIImage(systemName: "person") }
        static var white = { R.color.cFEFFFF() }
        static var lightGray = { R.color.cC8C7CC() }
        static var gray = { R.color.c686868() }
        static var starIcon = { R.image.starIcon() }
    }
    
    private lazy var userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Constants.personImage()
        imageView.layer.cornerRadius = 16
        imageView.tintColor = Constants.white()
        imageView.backgroundColor = Constants.lightGray()
        return imageView
    }()
    
    private lazy var nameDateStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var markStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        return stackView
    }()
    
    private lazy var starImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Constants.starIcon()
        imageView.tintColor = Constants.gray()
        return imageView
    }()
    
    private lazy var markLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = Constants.gray()
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 17)
        return label
    }()
    
    private lazy var reviewLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
        
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with model: ReviewModel) {
        if model.userPhoto != nil {
            userImageView.image = model.userPhoto
        }
        userNameLabel.text = model.userName
        dateLabel.text = DateFormatter.reviewDateFormatter.string(from: model.date)
        markLabel.text = String(model.mark)
        titleLabel.text = model.title
        reviewLabel.text = model.review
    }
    
    
    private func setup() {
        nameDateStackView.addArrangedSubviews([userNameLabel, dateLabel])
        markStackView.addArrangedSubviews([markLabel, starImageView])
        contentView.addSubviews([userImageView, nameDateStackView, markStackView, titleLabel, reviewLabel])
        
        userImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.leading.equalToSuperview().offset(8)
            $0.height.width.equalTo(62)
        }
        
        nameDateStackView.snp.makeConstraints {
            $0.top.equalTo(userImageView)
            $0.leading.equalTo(userImageView.snp.trailing).offset(16)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        userNameLabel.snp.makeConstraints {
            $0.height.equalTo(24)
        }
        
        dateLabel.snp.makeConstraints {
            $0.height.equalTo(20)
        }
        
        markStackView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(userNameLabel.snp.bottom)
            $0.height.equalTo(24)
            $0.width.equalTo(52)
        }
        
        starImageView.snp.makeConstraints {
            $0.width.height.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(userImageView.snp.bottom).offset(8)
            $0.leading.equalTo(userImageView)
            $0.width.equalToSuperview().dividedBy(1.04)
            $0.height.equalTo(24)
        }
        
        reviewLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.equalTo(titleLabel)
            $0.width.equalToSuperview().dividedBy(1.05)
            
        }
    }

}
