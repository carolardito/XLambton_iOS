//
//  DetailsPinPoint.swift
//  PoolProject
//
//  Created by MacStudent on 2018-03-15.
//  Copyright © 2018 722713. All rights reserved.
//fazer uma barra que tenha save e a esquerda receba uma informacao pra saber quem passou os details e habilita a volta certa

import MapKit

class DetailsPinPoint: NSObject, MKAnnotation {
    let title: String?
    let locationName: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.coordinate = coordinate
        
        super.init()
    }
        
    var subtitle: String? {
        return "\(locationName)"
    }
}
