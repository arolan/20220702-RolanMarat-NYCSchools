//
//  SchoolDetailsViewModel.swift
//  20220702-RolanMarat-NYCSchools
//
//  Created by Rolan on 7/3/22.
//

import Foundation

class SchoolDetailsViewModel {
    private(set) var school: School
    private(set) var schoolSAT: SchoolSAT
    
    init(school: School,
         schoolSAT: SchoolSAT) {
        self.school = school
        self.schoolSAT = schoolSAT
    }
}
