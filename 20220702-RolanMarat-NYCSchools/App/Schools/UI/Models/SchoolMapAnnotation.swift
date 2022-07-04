//
//  SchoolMapAnnotation.swift
//  20220702-RolanMarat-NYCSchools
//
//  Created by Rolan on 7/3/22.
//

import Foundation
import MapKit
import UIKit

class SchoolMapAnnotation: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var subtitle: String?

    init(title: String,
         coordinate: CLLocationCoordinate2D,
         subtitle: String) {
        self.title = title
        self.coordinate = coordinate
        self.subtitle = subtitle
    }
}
