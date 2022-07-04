//
//  SchoolSection.swift
//  20220702-RolanMarat-NYCSchools
//
//  Created by Rolan on 7/3/22.
//

import Foundation

/// Model to represent school section in the collection view of schools
/// displayed to the user. The goal of the school section is to group school
struct SchoolSection {
    let city: String
    var schools: [School]
}
