//
//  MapViewController.swift
//  AppTest
//
//  Created by Арсений Варицкий on 27.05.24.
//

import UIKit
import MapKit

private enum Constants {
    static var backgroundColor: UIColor? { R.color.cFEFFFF() }
    static var map: String { "Карта" }
    static var list: String { "Список" }
    static var cellIdentifier: String { "cellIdentifier" }
    static var unselectedPin: UIImage? { R.image.mapPin() }
    static var selectedPin: UIImage? { R.image.mapPinSelected() }
}

protocol MapViewControllerInterface: AnyObject {
    
}

class MapViewController: UIViewController {
    
    private let viewModel: MapViewModel
    
    var shopData: [ShopModel] = []
    
    private let mapView = MKMapView()
    
    var segmentedControl = UISegmentedControl()
        
    let segmentedControlItems = [Constants.map, Constants.list]
        
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: view.bounds, style: .plain)
        table.rowHeight = 160
        table.register(
            ShopsTableViewCell.self,
            forCellReuseIdentifier: Constants.cellIdentifier
        )
        table.dataSource = self
        table.delegate = self
        table.separatorStyle = .singleLine
        return table
    }()
    
    private let pinAnotationView = PinAnotationView()
    
    private var selectedPin: MKAnnotation?

    init(viewModel: MapViewModel) {
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
        mapView.delegate = self
    }
    
    private func setupUI() {
        view.backgroundColor = Constants.backgroundColor
        setupSegmentedControl()
        getShopsInfo()
        segmentedControlValueChanged()
        setInitialRegion()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubviews([mapView, tableView, pinAnotationView])
        pinAnotationView.isHidden = true
    }

    private func setupConstraints() {
        segmentedControl.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            $0.height.equalTo(32)
            $0.trailing.equalToSuperview().inset(16)
            $0.leading.equalToSuperview().offset(16)
        }
        
        mapView.snp.makeConstraints {
            $0.top.equalTo(segmentedControl.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        pinAnotationView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.height.equalTo(168)
            $0.width.equalTo(311)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(segmentedControl.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview()
        }
    }
    
    private func setupSegmentedControl() {
        segmentedControl = UISegmentedControl(items: segmentedControlItems)
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0
        view.addSubview(segmentedControl)
    }
    
    @objc
    private func segmentedControlValueChanged() {
        let isMapSelected = segmentedControl.selectedSegmentIndex == 0
        mapView.isHidden = !isMapSelected
        tableView.isHidden = isMapSelected
        pinAnotationView.isHidden = !isMapSelected || selectedPin == nil
    }

    private func getShopsInfo() {
        viewModel.fetchShopsFromRealm { [weak self] shopsRM in
            guard let self = self else { return }
            
            if !shopsRM.isEmpty {
                self.shopData = shopsRM
                self.addAnnotations()
                self.tableView.reloadData()
            } else {
                viewModel.fetchShops { [weak self] shops in
                    self?.shopData = shops
                    self?.addAnnotations()
                    self?.tableView.reloadData()
                }
            }
        }
    }
    
    private func addAnnotations() {
            for shop in self.shopData {
                let pin = MKPointAnnotation()
                pin.coordinate.latitude = shop.latitude
                pin.coordinate.longitude = shop.longitude
                mapView.addAnnotation(pin)
            }
    }
    
    private func setInitialRegion() {
        let initialCoordinate = CLLocationCoordinate2D(latitude: 52.09648257676331, longitude: 23.691619004365055)
        let regionRadius: CLLocationDistance = 10000
        let coordinateRegion = MKCoordinateRegion(center: initialCoordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
      let identifier = "ShopAnnotationView"
      var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

      if annotationView == nil {
        annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        annotationView?.canShowCallout = false
      } else {
        annotationView?.annotation = annotation
      }

        annotationView?.image = Constants.unselectedPin

      return annotationView
    }
    

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        view.image = Constants.selectedPin
        
        selectedPin = view.annotation
        
        guard let annotation = view.annotation as? MKPointAnnotation else { return }
        guard let shop = viewModel.shop(for: annotation) else { return }
        
        pinAnotationView.configure(with: shop)
        
        pinAnotationView.isHidden = false
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        view.image = Constants.unselectedPin
        
        selectedPin = nil
        
        pinAnotationView.isHidden = true
    }
 }

extension MapViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        false
    }
}

extension MapViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        shopData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath) as? ShopsTableViewCell
        else { return UITableViewCell() }
        cell.configure(with: shopData[indexPath.row])
        return cell
    }
}

extension MapViewController: MapViewControllerInterface { }
