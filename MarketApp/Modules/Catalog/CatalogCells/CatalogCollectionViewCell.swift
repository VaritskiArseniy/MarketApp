//
//  ProductCollectionViewCell.swift
//  AppTest
//
//  Created by Арсений Варицкий on 22.02.24.
//

import UIKit

private enum Constants {
    static var black: UIColor? { R.color.c000000() }
    static var categoryTextColor: UIColor? { R.color.c98989D() }
    static var fontBolt12: UIFont { .boldSystemFont(ofSize: 12) }
    static var fontBolt10: UIFont { .boldSystemFont(ofSize: 10) }
    static var font10: UIFont { .systemFont(ofSize: 10) }
}

class CatalogCollectionViewCell: UICollectionViewCell {
    
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
    
    private lazy var productPurchasesLabel: UILabel = {
        let label = UILabel()
        label.textColor = Constants.black
        label.font = .systemFont(ofSize: 9)
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
            productPurchasesLabel,
            productPriceLabel,
            ratingImageView,
            ratingLabel
        ])
    }
    
    private func setupConstraints() {
        productImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(211)
            $0.width.equalToSuperview()
        }
        
        productNameLabel.snp.makeConstraints {
            $0.top.equalTo(productImageView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview()
        }
        
        productCategoryLabel.snp.makeConstraints {
            $0.top.equalTo(productNameLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview()
        }
        
        productPurchasesLabel.snp.makeConstraints {
            $0.top.equalTo(productCategoryLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview()
        }
        
        productPriceLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.bottom.equalToSuperview().inset(4)
        }
        
        ratingImageView.snp.makeConstraints {
            $0.trailing.bottom.equalToSuperview()
            $0.size.equalTo(24)
        }
        
        ratingLabel.snp.makeConstraints {
            $0.trailing.equalTo(ratingImageView.snp.leading).offset(-4)
            $0.bottom.equalToSuperview().inset(4)
        }
    }
    
    func configure(with model: ProductModel) {
        productImageView.loadImageUsingCacheWithUrlString(urlString: model.image[0])
        productNameLabel.text = model.name.uppercased()
        productCategoryLabel.text = model.category
        productPurchasesLabel.text = "Покупок \(model.purchases)"
        productPriceLabel.text = "\(model.price) р."
        ratingLabel.text = "\(model.mark)"
    }
}

