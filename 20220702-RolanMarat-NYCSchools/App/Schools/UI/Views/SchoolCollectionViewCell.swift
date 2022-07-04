//
//  SchoolCollectionViewCell.swift
//  20220702-RolanMarat-NYCSchools
//
//  Created by Rolan on 7/3/22.
//

import Foundation
import UIKit
import PureLayout

/// Collection view cell representing school details
class SchoolCollectionViewCell: UICollectionViewCell {
    private var school: School?
    
    private struct Constants {
        static let leftInset: CGFloat = 10
        static let topInset: CGFloat = 10
        static let rightInset: CGFloat = 10
        static let bottomInset: CGFloat = 10
        static let borderWidth: CGFloat = 0.5
        static let imageHeight: CGFloat = 80
        static let cornerRadius: CGFloat = 10.0
        static let wrapperViewInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
    }
    
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
        return label
    }()
    
    private var cityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 12)
        return label
    }()
    
    private var emailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 12)
        return label
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
    
    private func setupNameLabel() {
        wrapperView.addSubview(nameLabel)
        nameLabel.autoPinEdge(toSuperviewEdge: .leading,
                              withInset: Constants.leftInset)
        nameLabel.autoPinEdge(toSuperviewEdge: .top,
                              withInset: Constants.topInset)
        nameLabel.autoPinEdge(toSuperviewEdge: .top,
                              withInset: Constants.rightInset)
        nameLabel.autoPinEdge(toSuperviewEdge: .trailing,
                              withInset: Constants.rightInset)
    }
    
    private func setupCityLabel() {
        wrapperView.addSubview(cityLabel)
        cityLabel.autoPinEdge(toSuperviewEdge: .leading,
                              withInset: Constants.leftInset)
        cityLabel.autoPinEdge(.top,
                              to: .bottom,
                              of: nameLabel,
                              withOffset: Constants.topInset)
        cityLabel.autoPinEdge(toSuperviewEdge: .trailing,
                              withInset: Constants.rightInset)
    }
    
    private func setupEmailLabel() {
        wrapperView.addSubview(emailLabel)
        emailLabel.autoPinEdge(toSuperviewEdge: .leading,
                               withInset: Constants.leftInset)
        emailLabel.autoPinEdge(.top,
                               to: .bottom,
                               of: cityLabel,
                               withOffset: Constants.topInset)
        emailLabel.autoPinEdge(toSuperviewEdge: .trailing,
                               withInset: Constants.rightInset)
    }
    
    private func setupWrapperView() {
        addSubview(wrapperView)
        wrapperView.autoPinEdgesToSuperviewEdges(with: Constants.wrapperViewInsets)
    }
    
    private func setupViews() {
        backgroundColor = .white
        setupWrapperView()
        setupNameLabel()
        setupCityLabel()
        setupEmailLabel()
    }
    
    func populate(school: School) {
        self.school = school
        nameLabel.text = school.schoolName
        cityLabel.text = school.city ?? ""
        emailLabel.text = school.schoolEmail
    }
}
