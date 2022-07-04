//
//  SchoolSAT.swift
//  20220702-RolanMarat-NYCSchools
//
//  Created by Rolan on 7/3/22.
//

import Foundation

struct SchoolSAT: Decodable {
    let dbn: String
    let schoolName: String?
    let numberOfSATTestTakers: String?
    let criticalReadingAVGScore: String?
    let mathAVGScore: String?
    let writingAVGScore: String?
    
    enum CodingKeys: String, CodingKey {
        case dbn
        case schoolName = "school_name"
        case numberOfSATTestTakers = "num_of_sat_test_takers"
        case criticalReadingAVGScore = "sat_critical_reading_avg_score"
        case mathAVGScore = "sat_math_avg_score"
        case writingAVGScore = "sat_writing_avg_score"
    }
}
