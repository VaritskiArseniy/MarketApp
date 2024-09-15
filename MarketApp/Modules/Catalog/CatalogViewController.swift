//
//  CatalogViewController.swift
//  AppTest
//
//  Created by Арсений Варицкий on 8.02.24.
//

import UIKit
import SnapKit

private enum Constants {
    static var backgroundColor: UIColor? { R.color.cFEFFFF() }
    static var topNavigationBarColor: UIColor? { R.color.cF2F2F2() }
    static var searchHolderText: String { "Поиск" }
    static var collectionCellIdentifier: String { "collectionCellIdentifier" }
    static var adBannerCellIdentifier: String { "adBannerCellIdentifier" }
    static var topProductCellIdentifier: String { "topProductCellIdentifier" }
    static var topProductLabel: String { "Топ товаров" }
    static var price: String { "Цена" }
    static var mark: String { "Рейтинг" }
    static var purchases: String { "Заказы" }
    static var microphoneImage: UIImage { UIImage(systemName: "mic.fill")! }
    static var itemWidthTopProduct: CGFloat { 110 }
    static var itemHeightTopProduct: CGFloat { 214 }
    static var itemWidthBanner: CGFloat { UIScreen.main.bounds.width - 32 }
    static var itemHeightBanner: CGFloat { 94 }
    static var selectedPage: UIColor? { R.color.c000000() }
    static var unselectedPage: UIColor? { R.color.cC8C7CC() }
}

class CatalogViewController: UIViewController {
    
    private let viewModel: CatalogViewModel
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = Constants.searchHolderText
        searchBar.showsBookmarkButton = true
        searchBar.setImage(Constants.microphoneImage, for: .bookmark, state: .normal)
        return searchBar
    }()
    
    private var bannerImages: [UIImage] = []
    
    var searchActive: Bool = false
    
    var segmentedControl = UISegmentedControl()
    
    var currentSegment: Int = .zero
    
    let segmentedControlItems = [Constants.price, Constants.mark, Constants.purchases]
    
    private let pageControl = UIPageControl()
    
    private var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private lazy var topProductLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.topProductLabel
        return label
    }()
    
    private let catalogCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    lazy var filteredData: [ProductModel] = []
    lazy var productsData: [ProductModel] = []
    lazy var topProductsData: [ProductModel] = []
    
    init(viewModel: CatalogViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.titleView = searchBar
        setupUI()
        setupConstraints()
        endEditingSearchBar()
        setupPageControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    private func setupUI() {
        getProducts()
        getTopProducts()
        getBannerImages()
        setupCollectionView()
        view.backgroundColor = Constants.backgroundColor
        setupSegmentedControl()
        view.addSubview(scrollView)
        scrollView.addSubviews([
            segmentedControl,
            topProductLabel,
            catalogCollection
        ])
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        segmentedControl.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(scrollView.snp.top).offset(8)
            $0.height.equalTo(32)
            $0.width.equalToSuperview().offset(-32)
        }
        
        topProductLabel.snp.makeConstraints {
            $0.top.equalTo(segmentedControl.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(24)
        }
        
        catalogCollection.snp.makeConstraints {
            $0.top.equalTo(topProductLabel.snp.bottom).offset(8)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.width.equalTo(view.snp.width)
            $0.height.equalTo(calculatedHeight())
        }
    }
    
    func updateData() {
        catalogCollection.reloadData()
        catalogCollection.snp.updateConstraints {
            $0.height.equalTo(self.calculatedHeight())
        }
    }
    
    private func setupSegmentedControl() {
        segmentedControl = UISegmentedControl(items: segmentedControlItems)
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0
    }
    
    @objc
    private func segmentedControlValueChanged() {
        updateDataForSegment(segmentedControl.selectedSegmentIndex)
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        catalogCollection.collectionViewLayout = layout
        
        
        catalogCollection.register(
            TopProductCollectionViewCell.self,
            forCellWithReuseIdentifier: Constants.topProductCellIdentifier
        )
        catalogCollection.register(
            AdBannerCollectionViewCell.self,
            forCellWithReuseIdentifier: Constants.adBannerCellIdentifier
        )
        catalogCollection.register(
            CatalogCollectionViewCell.self,
            forCellWithReuseIdentifier: Constants.collectionCellIdentifier
        )
        catalogCollection.dataSource = self
        catalogCollection.delegate = self
        catalogCollection.showsHorizontalScrollIndicator = false
        catalogCollection.isScrollEnabled = false
        catalogCollection.collectionViewLayout = createLayout()
    }
    
    private func calculatedHeight() -> CGFloat {
        var count: Int
        
        count = searchActive ? filteredData.count : productsData.count
        
        let rows = Int(ceil(Double(count) / 2.0))
        
        let height = CGFloat(214 + 8 + 94 + 24 + rows * (300 + 12))
        
        return height
    }
    
    private func getBannerImages() {
        viewModel.fetchBanners { [weak self] in
            guard let self = self else { return }
            self.bannerImages = self.viewModel.bannerImages
            setupPageControl()
            self.catalogCollection.reloadData()
            
        }
    }
    
    private func getProducts() {
        viewModel.fetchProducts { [weak self] products in
            self?.productsData = products
            DispatchQueue.main.async {
                self?.catalogCollection.reloadData()
                self?.catalogCollection.snp.updateConstraints {
                    $0.height.equalTo(self?.calculatedHeight() ?? 0)
                }
            }
        }
    }
    
    private func getTopProducts() {
        viewModel.fetchTopProducts { [weak self] products in
            self?.topProductsData = products
            DispatchQueue.main.async {
                self?.catalogCollection.reloadData()
                self?.catalogCollection.snp.updateConstraints {
                    $0.height.equalTo(self?.calculatedHeight() ?? 0)
                }
            }
        }
    }
    
    private func setupPageControl() {
        pageControl.numberOfPages = self.bannerImages.count
        pageControl.currentPage = .zero
        pageControl.pageIndicatorTintColor = Constants.unselectedPage
        pageControl.currentPageIndicatorTintColor = Constants.selectedPage
        pageControl.hidesForSinglePage = true
        
        view.addSubview(pageControl)
        
        pageControl.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(catalogCollection.snp.top).offset(295)
        }
    }
    
    private func updateDataForSegment(_ segmentIndex: Int) {
        currentSegment = segmentIndex
        catalogCollection.reloadData()
    }
    
    private func endEditingSearchBar() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapOutsiteKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc
    private func tapOutsiteKeyboard() {
        searchBar.resignFirstResponder()
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            guard let self = self else  { return nil }
            switch sectionIndex {
            case 0:
                return createTopProductSection()
            case 1:
                return createBannerSection()
            case 2:
                return createCatalogSection()
            default:
                let defaultItemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)
                )
                let defaultItem = NSCollectionLayoutItem(layoutSize: defaultItemSize)
                let defaultGroup = NSCollectionLayoutGroup.horizontal(layoutSize: defaultItemSize, subitem: defaultItem, count: 1)
                return NSCollectionLayoutSection(group: defaultGroup)
            }
        }
    }
    
    private func createLayoutSection(
        group: NSCollectionLayoutGroup,
        behavior: UICollectionLayoutSectionOrthogonalScrollingBehavior,
        interGroupSpacing: CGFloat,
        supplementaryItems: [NSCollectionLayoutBoundarySupplementaryItem]
        
    ) -> NSCollectionLayoutSection {
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = behavior
        section.interGroupSpacing = interGroupSpacing
        section.boundarySupplementaryItems = supplementaryItems
        return section
    }
    
    private func createTopProductSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        ))
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(Constants.itemWidthTopProduct),
            heightDimension: .absolute(Constants.itemHeightTopProduct)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = createLayoutSection(
            group: group,
            behavior: .continuousGroupLeadingBoundary,
            interGroupSpacing: 16,
            supplementaryItems: []
        )
        section.contentInsets = .init(top: .zero, leading: 16, bottom: .zero, trailing: .zero)
        return section
    }
    
    private func createBannerSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        ))
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(Constants.itemWidthBanner),
            heightDimension: .absolute(Constants.itemHeightBanner)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = createLayoutSection(
            group: group,
            behavior: .groupPagingCentered,
            interGroupSpacing: 32,
            supplementaryItems: []
        )
        section.contentInsets = .init(top: 12, leading: .zero, bottom: .zero, trailing: .zero)
        return section
    }
    
    private func createCatalogSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .fractionalHeight(1)
        ))
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(300)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        group.interItemSpacing = .flexible(30)
        
        let section = createLayoutSection(
            group: group,
            behavior: .none,
            interGroupSpacing: 12,
            supplementaryItems: []
        )
        section.contentInsets = .init(top: 20, leading: 16, bottom: .zero, trailing: 16)
        return section
    }
}

extension CatalogViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        
        var filteredProducts = viewModel.filterProduct(searchText: searchText)
        
        self.filteredData = filteredProducts.isEmpty ? [] : filteredProducts
        
        searchActive = !searchText.isEmpty
        
        DispatchQueue.main.async {
            self.catalogCollection.reloadData()
            self.catalogCollection.snp.updateConstraints {
                $0.height.equalTo(self.calculatedHeight())
            }
        }
    }
}


extension CatalogViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay celCollectionViewCell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        switch indexPath.section {
        case 1:
            pageControl.currentPage = indexPath.item
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedProduct: ProductModel
        switch indexPath.section {
        case 0:
            selectedProduct = topProductsData[indexPath.item]
        case 2:
            switch currentSegment {
            case 0:
                selectedProduct = viewModel.sortProductByPrice(
                    products: searchActive ? filteredData : productsData
                )[indexPath.item]
            case 1:
                selectedProduct = viewModel.sortProductByMark(
                    products: searchActive ? filteredData : productsData
                )[indexPath.item]
            case 2:
                selectedProduct = viewModel.sortProductByPurchase(products: searchActive ? filteredData : productsData)[indexPath.item]
            default:
                selectedProduct = (searchActive ? filteredData : productsData)[indexPath.item]
            }
        default:
            return
        }
        
        let productVC = ProductViewController(viewModel: ProductViewModel())
        productVC.productModel = selectedProduct
        productVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(productVC, animated: true)
        
    }
}

extension CatalogViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return topProductsData.count
            
        case 1:
            return bannerImages.count
            
        case 2:            
            return (searchActive ? filteredData.count : productsData.count)
            
        default:
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: Constants.topProductCellIdentifier,
                for: indexPath
            ) as? TopProductCollectionViewCell else {
                return UICollectionViewCell()
            }
            let product = topProductsData[indexPath.item]
            cell.configure(with: product)
            return cell
            
        case 1:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: Constants.adBannerCellIdentifier,
                for: indexPath
            ) as? AdBannerCollectionViewCell else {
                return UICollectionViewCell()
            }
            let banner = bannerImages[indexPath.item]
            cell.configure(with: banner)
            return cell
            
        case 2:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: Constants.collectionCellIdentifier,
                for: indexPath
            ) as? CatalogCollectionViewCell else {
                return UICollectionViewCell()
            }
            let product: ProductModel
            switch currentSegment {
            case 0:
                product = viewModel.sortProductByPrice(products: searchActive ? filteredData : productsData)[indexPath.item]
            case 1:
                product = viewModel.sortProductByMark(products: searchActive ? filteredData : productsData)[indexPath.item]
            case 2:
                product = viewModel.sortProductByPurchase(products: searchActive ? filteredData : productsData)[indexPath.item]
            default:
                product = (searchActive ? filteredData : productsData)[indexPath.item]
            }
            cell.configure(with: product)
            return cell
            
        default:
            return UICollectionViewCell()
        }
    }
}

extension CatalogViewController: CatalogOutput {}
