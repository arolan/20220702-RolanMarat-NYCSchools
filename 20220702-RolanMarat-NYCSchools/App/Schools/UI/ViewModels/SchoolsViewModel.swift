//
//  SchoolsViewModel.swift
//  20220702-RolanMarat-NYCSchools
//
//  Created by Rolan on 7/3/22.
//

import Foundation
import Combine

class SchoolsViewModel {
    @Published var schools: [School]?
    @Published var schoolSATs: [SchoolSAT]?
    @Published var error: DataError?
    
    private(set) var schoolSATDictionary: [String: SchoolSAT] = [:]
    
    private var schoolAPI: SchoolAPILogic
    
    init(schoolAPI: SchoolAPILogic = SchoolAPI()) {
        self.schoolAPI = schoolAPI
    }
    
    func getSchools() {
        schools?.removeAll()
        schoolAPI.getSchools { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let schools):
                self.schools = schools
            case .failure(let error):
                self.error = error
            }
        }
    }
    
    func getSchoolSATs() {
        schoolSATs?.removeAll()
        schoolAPI.getSchoolSATResults { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let schoolSATResults):
                self.schoolSATs = schoolSATResults
                
                for sat in schoolSATResults {
                    self.schoolSATDictionary[sat.dbn] = sat
                }
            case .failure(let error):
                self.error = error
            }
        }
    }
}
