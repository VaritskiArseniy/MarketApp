//
//  ImageCollectionViewCell.swift
//  AppTest
//
//  Created by Арсений Варицкий on 15.05.24.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    private lazy var productImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
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
        addSubview(productImageView)
    }
    
    private func setupConstraints() {
        productImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configure(with image: String) {
        productImageView.loadImageUsingCacheWithUrlString(urlString: image)
    }
}
