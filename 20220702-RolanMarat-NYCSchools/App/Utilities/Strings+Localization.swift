//
//  Strings+Localization.swift
//  20220702-RolanMarat-NYCSchools
//
//  Created by Rolan on 7/2/22.
//

import Foundation

extension String {
    func localized() -> String {
        return NSLocalizedString(self,
                                 comment: "")
    }
    
    func localized(params: CVarArg...) -> String {
        return String(format: localized(),
                      arguments: params)
    }
}
