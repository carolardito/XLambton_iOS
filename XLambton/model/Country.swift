//
//  Country.swift
//  XLambton
//
//  Created by user143339 on 8/17/18.
//  Copyright © 2018 user143339. All rights reserved.
//

import Foundation

struct Country {
    var id: Int
    var name: String
    var longitude: Double
    var latitude: Double
}

public func loadImages() -> [[String]]{
    var image: [[String]] = []
    
    var brazil: [String] = ["brasil", "https://www.intrepidtravel.com/adventures/wp-content/uploads/2017/06/Iguazu-Falls-Argentina-or-Brazil-1.jpg"]
    var canada: [String] = ["canada",  "https://1.bp.blogspot.com/-nszqKsv1q4A/WDYrO57bzZI/AAAAAAAAEKc/us9fY6woe34Ixuc2xUTaYfwadmXIAmATgCEw/s1600/Lago-Moraine-Canad%25C3%25A1.jpg"]
    var denmark: [String] = ["denmark", "https://www.seriousfacts.com/wp-content/uploads/2017/08/Denmark-758x505.jpg"]
    var england: [String] = ["england",  "https://dynaimage.cdn.cnn.com/cnn/q_auto,w_900,c_fill,g_auto,h_506,ar_16:9/http%3A%2F%2Fcdn.cnn.com%2Fcnnnext%2Fdam%2Fassets%2F160418173456-beautiful-england-18-london-england.jpg"]
    var france: [String] = ["france", "https://study-eu.s3.amazonaws.com/uploads/image/path/97/wide_fullhd_france-paris-eiffel-tower.jpg"]
    var japan: [String] = ["japan", "https://dynaimage.cdn.cnn.com/cnn/q_auto,w_1024,c_fill,g_auto,h_576,ar_16:9/http%3A%2F%2Fcdn.cnn.com%2Fcnnnext%2Fdam%2Fassets%2F170606121226-japan---travel-destination---shutterstock-230107657.jpg"]
    
    image.append(brazil)
    image.append(canada)
    image.append(denmark)
    image.append(england)
    image.append(france)
    image.append(japan)
    return image
}
