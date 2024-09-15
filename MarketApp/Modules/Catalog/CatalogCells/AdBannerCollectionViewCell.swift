//
//  TopProductCollectionViewCell.swift
//  AppTest
//
//  Created by Арсений Варицкий on 19.02.24.
//

import UIKit

class AdBannerCollectionViewCell: UICollectionViewCell {
    private lazy var adImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
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
        addSubview(adImageView)
    }
    
    private func setupConstraints() {
        adImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configure(with image: UIImage) {
        adImageView.image = image
    }
}
