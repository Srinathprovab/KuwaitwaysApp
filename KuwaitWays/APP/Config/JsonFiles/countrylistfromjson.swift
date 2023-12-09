//
//  countrylistfromjson.swift
//  KuwaitWays
//
//  Created by FCI on 09/12/23.
//

import Foundation


struct Country: Codable {
    let origin: String
    let apiContinentListFK: String
    let name: String
    let countryCode: String
    let isoCountryCode: String

    enum CodingKeys: String, CodingKey {
        case origin
        case apiContinentListFK = "api_continent_list_fk"
        case name
        case countryCode = "country_code"
        case isoCountryCode = "iso_country_code"
    }
}





