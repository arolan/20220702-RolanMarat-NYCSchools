//
//  SchoolsCollectionViewController.swift
//  20220702-RolanMarat-NYCSchools
//
//  Created by Rolan on 7/3/22.
//

import Foundation
import UIKit
import PureLayout
import MBProgressHUD
import Combine

/// Implementation of school collection view to display school including
class SchoolsCollectionViewController: UIViewController {
    private var schoolSectionsList: [SchoolSection]?
    private var collectionView: UICollectionView?
    private var loadingHUD: MBProgressHUD?
    
    private var viewModel = SchoolsViewModel()
    
    private let refreshControl = UIRefreshControl()
    
    private var cancellables: Set<AnyCancellable> = []
    
    private struct Constants {
        static let cellIdentifier: String = "schoolCell"
        static let cellHeight: CGFloat = 100
        static let sectionHeaderIdentifier: String = "sectionHeader"
        static let sectionHeight: CGFloat = 50
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "schools.list.nav.title".localized()
        setupCollectionView()
        setupLoadingHUD()
        setupRefreshControl()
        setupBinders()
        retrieveSchoolData()
    }
    
    private func setupRefreshControl() {
        refreshControl.attributedTitle = NSAttributedString(string: "pull.to.refresh.title".localized())
        refreshControl.addTarget(self,
                                 action: #selector(refresh(_:)),
                                 for: .valueChanged)
        collectionView?.addSubview(refreshControl)
    }
    
    @objc private func refresh(_ sender: AnyObject) {
        removeStateView()
        retrieveSchoolData()
        refreshControl.endRefreshing()
    }
    
    private func setupBinders() {
        Publishers.Zip(viewModel.$schools, viewModel.$schoolSATs)
            .receive(on: RunLoop.main)
            .sink { [weak self] items in
                let schools = items.0
                let _ = items.1 // SATs
                
                guard let self = self,
                      let _ = schools else {
                    return
                }
                self.loadingHUD?.hide(animated: true)
                self.removeStateView()
                self.updateSchoolsCollection()
            }
            .store(in: &cancellables)
        
        viewModel.$error
            .receive(on: RunLoop.main)
            .sink { [weak self] error in
                guard let self = self else {
                    return
                }
                
                if let error = error {
                    self.loadingHUD?.hide(animated: true)
                    switch error {
                    case .networkingError(let errorMessage):
                        self.showErrorState(errorMessage)
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    private func setupLoadingHUD() {
        guard let collectionView = collectionView else {
            return
        }
        loadingHUD = MBProgressHUD.showAdded(to: collectionView,
                                             animated: true)
        loadingHUD?.label.text = "loading.hud.title".localized()
        loadingHUD?.isUserInteractionEnabled = false
        loadingHUD?.detailsLabel.text = "loading.hud.subtitle".localized()
    }
    
    private func setupCollectionView() {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.itemSize = CGSize(width: view.frame.size.width,
                                               height: Constants.cellHeight)
        collectionViewLayout.headerReferenceSize = CGSize(width: view.frame.size.width,
                                                          height: Constants.sectionHeight)
        collectionViewLayout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: view.frame,
                                          collectionViewLayout: collectionViewLayout)
        
        guard let collectionView = collectionView else {
            return
        }
        
        view.addSubview(collectionView)
        collectionView.autoPinEdgesToSuperviewEdges()
        collectionView.backgroundColor = .white
        collectionView.alwaysBounceVertical = true
        
        //setup & customize flow layout
        collectionView.register(SchoolCollectionViewCell.self,
                                forCellWithReuseIdentifier: Constants.cellIdentifier)
        collectionView.register(SchoolSectionHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: Constants.sectionHeaderIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    /// Fetches schools + SAT Results
    private func retrieveSchoolData() {
        removeStateView()
        loadingHUD?.show(animated: true)
        viewModel.getSchools()
        viewModel.getSchoolSATs()
    }
    
    /// Identifies list of sections based on the schools.
    /// Each section is represented by city where school is located.
    /// By grouping schools into sections we allow users to have
    /// organized view.
    private func updateSchoolsCollection() {
        guard let schools = viewModel.schools, !schools.isEmpty else {
            showEmptyState()
            return
        }
        var listOfSections = [SchoolSection]()
        var schoolDictionary = [String: SchoolSection]()
        
        for school in schools {
            if let city = school.city {
                if schoolDictionary[city] != nil {
                    schoolDictionary[city]?.schools.append(school)
                } else {
                    var newSection = SchoolSection(city: city,
                                                   schools: [])
                    newSection.schools.append(school)
                    schoolDictionary[city] = newSection
                }
            }
        }
        
        listOfSections = Array(schoolDictionary.values)
        listOfSections.sort {
            return $0.city < $1.city
        }
        schoolSectionsList = listOfSections
        collectionView?.reloadData()
    }
}

/// Implementation of data source delegate for collection view to help with displaying schools
extension SchoolsCollectionViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return schoolSectionsList?.count ?? 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return schoolSectionsList?[section].schools.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellIdentifier,
                                                      for: indexPath)
        
        guard let schoolCell = cell as? SchoolCollectionViewCell,
              let schoolSection = schoolSectionsList?[indexPath.section] else {
            return cell
        }
        let school = schoolSection.schools[indexPath.row]
        schoolCell.populate(school: school)
        
        return schoolCell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionHeader,
           let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                               withReuseIdentifier: Constants.sectionHeaderIdentifier,
                                                                               for: indexPath) as? SchoolSectionHeaderView  {
            sectionHeader.headerLabel.text = schoolSectionsList?[indexPath.section].city
            return sectionHeader
        }
        return UICollectionReusableView()
    }
}


extension SchoolsCollectionViewController {
    func showErrorState(_ errorMessage: String) {
        let errorStateView = SchoolsListStateView(forAutoLayout: ())
        errorStateView.update(for: .error)
        collectionView?.backgroundView = errorStateView
    }
    
    func removeStateView() {
        collectionView?.backgroundView = nil
    }
    
    func showEmptyState() {
        let emptyStateView = SchoolsListStateView(forAutoLayout: ())
        emptyStateView.update(for: .empty)
        collectionView?.backgroundView = emptyStateView
    }
}

extension SchoolsCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let section = schoolSectionsList?[indexPath.section] {
            let school = section.schools[indexPath.row]
            if let schoolSAT = viewModel.schoolSATDictionary[school.dbn] {
                let schoolDetailsVC = SchoolDetailsViewController()
                schoolDetailsVC.viewModel = SchoolDetailsViewModel(school: school,
                                                                   schoolSAT: schoolSAT)
                navigationController?.pushViewController(schoolDetailsVC,
                                                         animated: true)
            }
        }
    }
}
