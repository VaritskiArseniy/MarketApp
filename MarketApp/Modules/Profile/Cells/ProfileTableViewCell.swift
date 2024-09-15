//
//  MainTableViewCell.swift
//  AppTest
//
//  Created by Арсений Варицкий on 18.01.24.
//

import UIKit

private enum Constants {
    static var black: UIColor? { R.color.c000000() }
    static var titleColor: UIColor? { R.color.c98989D() }
}

struct ProfileTableViewCellModel {
    var type: TableViewTitles
    var description: String
}

class ProfileTableViewCell: UITableViewCell {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Constants.titleColor
        return label
    }()
    
    let descriptionLabel = UILabel()
    
    private lazy var separatorView: UIView = {
        let separator = UIView()
        separator.backgroundColor = Constants.black
        return separator
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with model: ProfileTableViewCellModel) {
        titleLabel.text = model.type.title
        descriptionLabel.text = model.description
    }
    
    private func setup() {
        contentView.addSubviews([titleLabel, descriptionLabel, separatorView])
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(10)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(24)
            $0.width.equalToSuperview().dividedBy(2)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.trailing).inset(10)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(24)
            $0.width.equalToSuperview().dividedBy(2)
        }
        
        separatorView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(1)
            $0.height.equalTo(0.5)
            $0.width.equalToSuperview().inset(16)
        }
    }
}
