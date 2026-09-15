//
//  LocationHelper.swift
//  Hello-Maps
//
//  Created by Kit Sitou on 9/12/26.
//

import MapKit

//to parse address to readable format address
struct LocationHelper{
    static func formatAddress(_ placemark: MKPlacemark)->String{
        let addressParts = [
            placemark.subThoroughfare,
            placemark.thoroughfare,
            placemark.locality,
            placemark.administrativeArea,
            placemark.postalCode

        ]
            .compactMap{ $0 }
        return addressParts.joined(separator: ",")
    }
}
