//
//  SchoolsDirectoryAPI.swift
//  20220702-RolanMarat-NYCSchools
//
//  Created by Rolan on 7/2/22.
//

import Foundation
import Alamofire

typealias SchoolsListAPIResponse = ((Swift.Result<[School], DataError>) -> Void)
typealias SchoolsSATAPIResponse = ((Swift.Result<[SchoolSAT], DataError>) -> Void)

/// API interface to retrieve schools
protocol SchoolAPILogic {
    func getSchools(completion: @escaping(SchoolsListAPIResponse))
    func getSchoolSATResults(completion: @escaping(SchoolsSATAPIResponse))
}

class SchoolAPI: SchoolAPILogic {
    struct Constants {
        /// NYC School API URL returning list of schools with details
        static let schoolsListURL = "https://data.cityofnewyork.us/resource/s3k6-pzi2.json?$$app_token=L1KwLSwm1yz1N7aWqFCF4dLmM"
        static let schoolsSATURL = "https://data.cityofnewyork.us/resource/f9bf-2cp4.json?$$app_token=L1KwLSwm1yz1N7aWqFCF4dLmM"
    }
    
    func getSchools(completion: @escaping(SchoolsListAPIResponse)) {
        // this prevents AF retrieving cached responses
        URLCache.shared.removeAllCachedResponses()
        
        AF.request(Constants.schoolsListURL)
            .validate()
            .responseDecodable(of: [School].self) { response in
                switch response.result {
                case .failure(let error):
                    completion(.failure(.networkingError(error.localizedDescription)))
                case .success(let schools):
                    completion(.success(schools))
                }
            }
    }
    
    func getSchoolSATResults(completion: @escaping(SchoolsSATAPIResponse)) {
        // this prevents AF retrieving cached responses
        URLCache.shared.removeAllCachedResponses()
        
        AF.request(Constants.schoolsSATURL)
            .validate()
            .responseDecodable(of: [SchoolSAT].self) { response in
                switch response.result {
                case .failure(let error):
                    completion(.failure(.networkingError(error.localizedDescription)))
                case .success(let schoolSATs):
                    completion(.success(schoolSATs))
                }
            }
    }
}
