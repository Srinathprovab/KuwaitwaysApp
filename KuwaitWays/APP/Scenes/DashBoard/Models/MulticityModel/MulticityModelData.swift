//
//  MulticityModelData.swift
//  KuwaitWays
//
//  Created by FCI on 12/07/23.
//

import Foundation

struct MulticityModelData : Codable {
    
    let attr : Attr?
    let search_id : Int?
    let pxtrip_type : String?
    let journey_id : Int?
    let booking_source : String?
    let flightCount : Int?
    let col_2x_result : Bool?
    let booking_url : String?
    let j_flight_list : [[J_flight_list]]?
    let search_params : MSearch_params?
    let booking_source_key : String?

    enum CodingKeys: String, CodingKey {

        case attr = "attr"
        case search_id = "search_id"
        case pxtrip_type = "pxtrip_type"
        case journey_id = "journey_id"
        case booking_source = "booking_source"
        case flightCount = "flightCount"
        case col_2x_result = "col_2x_result"
        case booking_url = "booking_url"
        case j_flight_list = "j_flight_list"
        case search_params = "search_params"
        case booking_source_key = "booking_source_key"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        attr = try values.decodeIfPresent(Attr.self, forKey: .attr)
        search_id = try values.decodeIfPresent(Int.self, forKey: .search_id)
        pxtrip_type = try values.decodeIfPresent(String.self, forKey: .pxtrip_type)
        journey_id = try values.decodeIfPresent(Int.self, forKey: .journey_id)
        booking_source = try values.decodeIfPresent(String.self, forKey: .booking_source)
        flightCount = try values.decodeIfPresent(Int.self, forKey: .flightCount)
        col_2x_result = try values.decodeIfPresent(Bool.self, forKey: .col_2x_result)
        booking_url = try values.decodeIfPresent(String.self, forKey: .booking_url)
        j_flight_list = try values.decodeIfPresent([[J_flight_list]].self, forKey: .j_flight_list)
        search_params = try values.decodeIfPresent(MSearch_params.self, forKey: .search_params)
        booking_source_key = try values.decodeIfPresent(String.self, forKey: .booking_source_key)
    }

}
