//
//  DataError.swift
//  20220702-RolanMarat-NYCSchools
//
//  Created by Rolan on 7/2/22.
//

import Foundation

/// Models errors returned by API layer
enum DataError: Error {
    case networkingError(String)
}
