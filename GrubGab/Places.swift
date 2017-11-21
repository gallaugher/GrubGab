//
//  Places.swift
//  GrubGab
//
//  Created by John Gallaugher on 11/20/17.
//  Copyright © 2017 John Gallaugher. All rights reserved.
//

import Foundation
import CoreLocation

class Places {
    struct PlaceData {
        var placeName: String
        var coordinates: CLLocation
        var postedBy: String
    }
    var placeArray = [PlaceData]()
    
}
