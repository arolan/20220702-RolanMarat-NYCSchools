//
//  SchoolDetailsMapCollectionViewCell.swift
//  20220702-RolanMarat-NYCSchools
//
//  Created by Rolan on 7/3/22.
//

import Foundation
import UIKit
import MapKit

class SchoolDetailsMapCollectionViewCell: UICollectionViewCell {
    private var school: School?
    
    private struct Constants {
        static let leftInset: CGFloat = 10
        static let topInset: CGFloat = 10
        static let rightInset: CGFloat = 10
        static let bottomInset: CGFloat = 10
        static let borderWidth: CGFloat = 0.5
        static let cornerRadius: CGFloat = 10.0
        static let wrapperViewInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
    }
    
    private var mapView: MKMapView = {
        let mapView = MKMapView()
        return mapView
    }()
    
    private var wrapperView: UIView = {
        let view = UIView(forAutoLayout: ())
        view.layer.borderColor = UIColor.gray.cgColor
        view.layer.borderWidth = Constants.borderWidth
        view.layer.cornerRadius = Constants.cornerRadius
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupWrapperView() {
        addSubview(wrapperView)
        wrapperView.autoPinEdgesToSuperviewEdges(with: Constants.wrapperViewInsets)
    }
    
    private func setupViews() {
        backgroundColor = .white
        setupWrapperView()
        
        wrapperView.addSubview(mapView)
        mapView.autoPinEdgesToSuperviewEdges()
        mapView.delegate = self
        wrapperView.clipsToBounds = true
    }
    
    func populate(school: School) {
        self.school = school
        
        updateMap()
    }
    
    private func updateMap() {
        if let longitude = school?.longitude,
           let longitudeDouble = Double(longitude),
           let latitude = school?.latitude,
           let latitudeDouble = Double(latitude) {
            let coordinates = CLLocationCoordinate2D(latitude: latitudeDouble,
                                                     longitude: longitudeDouble)
            let annotation = SchoolMapAnnotation(title: school?.schoolName ?? "",
                                                 coordinate: coordinates,
                                                 subtitle: school?.primaryAddressLine ?? "")
            mapView.addAnnotation(annotation)
            
            if let regionMeters = CLLocationDistance(exactly: 5000) {
                let region = MKCoordinateRegion(center: coordinates,
                                                latitudinalMeters: regionMeters,
                                                longitudinalMeters: regionMeters)
                mapView.setRegion(mapView.regionThatFits(region),
                                  animated: true)
            }
        }
    }
}

extension SchoolDetailsMapCollectionViewCell: MKMapViewDelegate {
    
}

