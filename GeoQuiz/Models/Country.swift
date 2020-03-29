//
//  Country.swift
//  GeoQuiz
//
//  Created by Bartosz Bialecki on 29/03/2020.
//  Copyright © 2020 Bartosz Bialecki. All rights reserved.
//

import Foundation

struct Country: Codable {
    var countryCode: String?
    var countryName: String
    var capital: String?
}
