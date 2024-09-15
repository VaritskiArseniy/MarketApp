//
//  TopProductCollectionViewCell.swift
//  AppTest
//
//  Created by Арсений Варицкий on 21.02.24.
//

import UIKit
import FirebaseStorage

private enum Constants {
    static var black: UIColor? { R.color.c000000() }
    static var categoryTextColor: UIColor? { R.color.c98989D() }
    static var fontBolt12: UIFont { .boldSystemFont(ofSize: 12) }
    static var fontBolt10: UIFont { .boldSystemFont(ofSize: 10) }
    static var font10: UIFont { .systemFont(ofSize: 10) }
}

class TopProductCollectionViewCell: UICollectionViewCell {
    
    private lazy var productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 6
        return imageView
    }()
    
    private lazy var productNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = Constants.black
        label.font = Constants.fontBolt12
        return label
    }()
    
    private lazy var productCategoryLabel: UILabel = {
        let label = UILabel()
        label.textColor = Constants.categoryTextColor
        label.font = Constants.font10
        return label
    }()
    
    private lazy var productPriceLabel: UILabel = {
        let label = UILabel()
        label.textColor = Constants.black
        label.font = Constants.fontBolt10
        return label
    }()
    
    private lazy var ratingImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "star.fill")
        imageView.tintColor = Constants.black
        return imageView
    }()

    private lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.textColor = Constants.black
        label.font = Constants.fontBolt10
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
        addSubviews([
            productImageView,
            productNameLabel,
            productCategoryLabel,
            productPriceLabel,
            ratingImageView,
            ratingLabel
        ])
    }
    
    private func setupConstraints() {
        productImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview()
            $0.top.equalToSuperview()
            $0.height.equalTo(146)
        }
        
        productNameLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(16)
            $0.top.equalTo(productImageView.snp.bottom).offset(12)
        }
        
        productCategoryLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(16)
            $0.top.equalTo(productNameLabel.snp.bottom)
        }
        
        productPriceLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.width.equalTo(56)
            $0.height.equalTo(24)
            $0.bottom.equalToSuperview()
        }
        
        ratingImageView.snp.makeConstraints {
            $0.width.height.equalTo(24)
            $0.bottom.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
        
        ratingLabel.snp.makeConstraints {
            $0.width.height.equalTo(24)
            $0.bottom.equalToSuperview()
            $0.trailing.equalTo(ratingImageView.snp.leading).offset(-4)
        }
    }
    
   func configure(with model: ProductModel) {
       productImageView.loadImageUsingCacheWithUrlString(urlString: model.image[0])
        productNameLabel.text = model.name.uppercased()
        productCategoryLabel.text = model.category
        productPriceLabel.text = "\(model.price) р."
        ratingLabel.text = "\(model.mark)"
    }
}
