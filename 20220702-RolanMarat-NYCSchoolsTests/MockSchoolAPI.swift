//
//  MockSchoolAPI.swift
//  20220702-RolanMarat-NYCSchoolsTests
//
//  Created by Rolan on 7/3/22.
//

import Foundation
@testable import _0220702_RolanMarat_NYCSchools

class MockSchoolAPI: SchoolAPILogic {
    var state: SchoolLoadState = .loaded
    
    func getSchools(completion: @escaping (SchoolsListAPIResponse)) {
        switch state {
        case .loaded:
            let mockSchool = School(dbn: "02M260",
                              schoolName: "Clinton School Writers & Artists, M.S. 260",
                              overviewParagraph: "Students who are prepared for college must have an education that encourages them to take...",
                              schoolEmail: "admissions@theclintonschool.net",
                              academicOpportunities1: "Free college courses at neighboring universities",
                              academicOpportunities2: "International Travel, Special Arts Programs, Music, Internships, College Mentoring English Language Learner Programs: English as a New Language",
                              neighborhood: "Chelsea-Union Sq",
                              phoneNumber: "212-524-4360",
                              website: "www.theclintonschool.net",
                              finalgrades: "6-12",
                              totalStudents: "376",
                              schoolSports: "Cross Country, Track and Field, Soccer, Flag Football, Basketball",
                              primaryAddressLine: "10 East 15th Street",
                              city: "Manhattan",
                              zip: "10003",
                              latitude: "40.73653",
                              longitude: "-73.9927")
            completion(.success([mockSchool]))
        case .error:
            completion(.failure(.networkingError("Could not fetch schools")))
        case .empty:
            completion(.success([]))
        }
    }
    
    func getSchoolSATResults(completion: @escaping (SchoolsSATAPIResponse)) {
        switch state {
        case .loaded:
            let mockSchoolSAT = SchoolSAT(dbn: "02M260",
                                          schoolName: "Clinton School Writers & Artists, M.S. 260",
                                          numberOfSATTestTakers: "123",
                                          criticalReadingAVGScore: "355",
                                          mathAVGScore: "404",
                                          writingAVGScore: "363")
            completion(.success([mockSchoolSAT]))
        case .error:
            completion(.failure(.networkingError("Could not fetch school SAT")))
        case .empty:
            completion(.success([]))
        }
    }
}
