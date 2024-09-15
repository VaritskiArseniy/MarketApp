//
//  ProductViewController.swift
//  AppTest
//
//  Created by Арсений Варицкий on 13.05.24.
//

import UIKit

protocol ProductViewControllerInterface: AnyObject {
}

private enum Constants {
    static var backgroundColor = { R.color.cFEFFFF() }
    static var backButtonImage = { R.image.backButtonImage() }
    static var grayColor = { R.color.c98989D() }
    static var priceTitle = { "Цена" }
    static var collectionCellIdentifier = { "collectionCellIdentifier" }
    static var selectedPage = { R.color.c000000() }
    static var unselectedPage = { R.color.cC8C7CC() }
    static var tableCellIdentifier = { "tableCellIdentifier" }
}

class ProductViewController: UIViewController {
    
    private let viewModel: ProductViewModel
    
    var productModel: ProductModel?
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(Constants.backButtonImage(), for: .normal)
        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private let scrollView = UIScrollView()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    private lazy var imageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        return collectionView
    }()
    
    private let pageControl = UIPageControl()
    
    private lazy var productNameLabel: UILabel = {
        let label = UILabel()
        label.text = productModel?.name.uppercased()
        label.font = .boldSystemFont(ofSize: 24)
        return label
    }()
    
    private lazy var productCategoryLabel: UILabel = {
        let label = UILabel()
        label.text = productModel?.category
        label.textColor = Constants.grayColor()
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    private lazy var productDescriptionLabel: UILabel = {
       let label = UILabel()
        label.text = productModel?.description
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.textAlignment = .justified
        return label
    }()
    
    private lazy var priceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 36
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    private lazy var priceTitleLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.priceTitle()
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()
    
    private lazy var priceValueLabel: UILabel = {
        let label = UILabel()
        label.text = "\(productModel?.price ?? 0)р"
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()
    
    private lazy var reviewTableView: UITableView = {
        let tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.rowHeight = 175
        tableView.register(
            ReviewTableViewCell.self,
            forCellReuseIdentifier: Constants.tableCellIdentifier()
        )
        tableView.isScrollEnabled = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .singleLine
        return tableView
    }()
    
    init(viewModel: ProductViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }
    
    private func setupUI() {
        view.backgroundColor = Constants.backgroundColor()
        setupNavigationController()
        setupPageControl()
        setupCollectionView()
        view.addSubview(scrollView)
        priceStackView.addArrangedSubviews([priceTitleLabel, priceValueLabel])
        stackView.addArrangedSubviews([productNameLabel, productCategoryLabel, productDescriptionLabel, priceStackView])
        scrollView.addSubviews([imageCollectionView, pageControl, backButton, stackView, reviewTableView])
        
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        imageCollectionView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.equalTo(view.snp.width)
            $0.height.equalTo(imageCollectionView.snp.width).multipliedBy(1.27)
        }
        
        backButton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(21)
            $0.width.equalTo(14)
            $0.height.equalTo(36)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(imageCollectionView.snp.bottom).offset(24)
            $0.trailing.equalToSuperview().inset(16)
            $0.leading.equalToSuperview().offset(16)
        }
        
        productDescriptionLabel.snp.makeConstraints {
            $0.width.equalTo(view.bounds.width - 32)
        }
        
        priceTitleLabel.snp.makeConstraints {
            $0.width.equalTo(52)
        }
        
        pageControl.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(imageCollectionView.snp.bottom).inset(5)
        }
        
        reviewTableView.snp.makeConstraints {
            $0.top.equalTo(stackView.snp.bottom).offset(16)
            $0.trailing.leading.equalToSuperview()
            $0.height.equalTo(calculateTableHeight())
            $0.bottom.equalTo(scrollView.contentLayoutGuide.snp.bottom)
        }
    }
    
    
    private func setupNavigationController() {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @objc private func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        imageCollectionView.collectionViewLayout = createLayout()
        
        
        imageCollectionView.register(
            ImageCollectionViewCell.self,
            forCellWithReuseIdentifier: Constants.collectionCellIdentifier()
        )
        
        imageCollectionView.dataSource = self
        imageCollectionView.delegate = self
        imageCollectionView.showsHorizontalScrollIndicator = false
        imageCollectionView.isScrollEnabled = false
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] sectionIndex, layoutEnvironment in
            guard let self = self else { return nil }
            return self.createSection()
        }
    }
    
    private func createSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        return section
    }
    
    private func setupPageControl() {
        pageControl.numberOfPages = productModel?.image.count ?? 0
        pageControl.currentPage = .zero
        pageControl.pageIndicatorTintColor = Constants.unselectedPage()
        pageControl.currentPageIndicatorTintColor = Constants.selectedPage()
        pageControl.hidesForSinglePage = true
        pageControl.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
    }
    
    private func calculateTableHeight() -> Int {
        let count = productModel?.reviews.count
        let height = 175 * (count ?? 0)
        return height
    }
}

extension ProductViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay celCollectionViewCell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        pageControl.currentPage = indexPath.item
    }
}

extension ProductViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        productModel?.image.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: Constants.collectionCellIdentifier(),
            for: indexPath
        ) as? ImageCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        guard let image = productModel?.image[indexPath.item] else { return UICollectionViewCell() }
        cell.configure(with: image)
        return cell
    }
}

extension ProductViewController: UITableViewDelegate {
    
}

extension ProductViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productModel?.reviews.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.tableCellIdentifier(), for: indexPath)
                as? ReviewTableViewCell
        else { return UITableViewCell() }
        
        guard let review = productModel?.reviews[indexPath.row] else { return UITableViewCell() }
        cell.configure(with: review)
        return cell
    }
}

extension ProductViewController: ProductViewControllerInterface {}
