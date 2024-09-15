//
//  ProfileViewController.swift
//  AppTest
//
//  Created by Арсений Варицкий on 13.01.24.
//

import UIKit
import SnapKit

private enum Constants {
    static var profileImageColor: UIColor? { R.color.c62B6B6() }
    static var backgroundColor: UIColor? { R.color.cFEFFFF() }
    static var black: UIColor? { R.color.c000000() }
    static var white: UIColor? { R.color.cFEFFFF() }
    static var cellIdentifier: String { "cellIdentifier" }
}

protocol ProfileViewControllerInterface: AnyObject {
    func updateNameLabel(name: String, surname: String)
    func updateTableView()
}

class ProfileViewController: UIViewController {
  
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: view.bounds, style: .plain)
        table.rowHeight = 56
        table.register(
            ProfileTableViewCell.self,
            forCellReuseIdentifier: Constants.cellIdentifier
        )
        table.dataSource = self
        table.delegate = self
        table.isUserInteractionEnabled = false
        table.separatorStyle = .none
        table.allowsSelectionDuringEditing = false
        return table
    }()
    
    private var photoImageView = UserPhotoView()
    
    private let viewModel: ProfileViewModel
    
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateTableView), name: .dataDidUpdate, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = Constants.backgroundColor
        view.addSubview(tableView)
    }
}

extension ProfileViewController: ProfileViewControllerInterface {
    @objc 
    func updateTableView() {
        tableView.reloadData()
         photoImageView.configure(with: viewModel.userPhotoModel)
    }
    
    func updateNameLabel(name: String, surname: String) {}
}

extension ProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = Constants.white
        photoImageView.configure(with: viewModel.userPhotoModel)
        
        headerView.addSubview(photoImageView)
        photoImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(headerView.safeAreaLayoutGuide).offset(20)
            $0.width.height.equalTo(150)
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 250
    }
}

extension ProfileViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataSourse.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath)
                as? ProfileTableViewCell
        else { return UITableViewCell() }
        cell.configure(with: viewModel.dataSourse[indexPath.row])
        return cell
    }
}
