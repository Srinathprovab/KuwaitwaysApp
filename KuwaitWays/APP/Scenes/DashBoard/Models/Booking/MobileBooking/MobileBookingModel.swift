//
//  MobileBookingModel.swift
//  KuwaitWays
//
//  Created by FCI on 25/04/23.
//

import Foundation



struct MobileBookingModel : Codable {
    let access_key_tp : String?
    // let flight_data : [Flight_data]?
    let active_payment_options : [String]?
    let booking_source : String?
    let tmp_flight_pre_booking_id : String?
    //  let pre_booking_params : Pre_booking_params?
    //    let country_list : Country_list?
    //    let form_params : Form_params?
    //    let search_data : Search_data?
    //    let pax_details : Bool?
    //    let travel_date_diff : String?
    //    let session_expiry_details : Session_expiry_details?
    //    let converted_currency_rate : Int?
    //    let flight_terms_cancellation_policy : String?
    //    let convenience_fees : Int?
    //    let total_price : Double?
    //    let reward_usable : Int?
    //    let reward_earned : Int?
    //    let total_price_with_rewards : Int?
    let status : Int?
    let msg : String?
    
    enum CodingKeys: String, CodingKey {
        
        case access_key_tp = "access_key_tp"
        //    case flight_data = "flight_data"
        case active_payment_options = "active_payment_options"
        case booking_source = "booking_source"
        case tmp_flight_pre_booking_id = "tmp_flight_pre_booking_id"
        //        case pre_booking_params = "pre_booking_params"
        //        case country_list = "country_list"
        //        case form_params = "form_params"
        //        case search_data = "search_data"
        //        case pax_details = "pax_details"
        //        case travel_date_diff = "travel_date_diff"
        //        case session_expiry_details = "session_expiry_details"
        //        case converted_currency_rate = "converted_currency_rate"
        //        case flight_terms_cancellation_policy = "flight_terms_cancellation_policy"
        //        case convenience_fees = "convenience_fees"
        //        case total_price = "total_price"
        //        case reward_usable = "reward_usable"
        //        case reward_earned = "reward_earned"
        //        case total_price_with_rewards = "total_price_with_rewards"
        case status = "status"
        case msg = "msg"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        access_key_tp = try values.decodeIfPresent(String.self, forKey: .access_key_tp)
        //    flight_data = try values.decodeIfPresent([Flight_data].self, forKey: .flight_data)
        active_payment_options = try values.decodeIfPresent([String].self, forKey: .active_payment_options)
        booking_source = try values.decodeIfPresent(String.self, forKey: .booking_source)
        tmp_flight_pre_booking_id = try values.decodeIfPresent(String.self, forKey: .tmp_flight_pre_booking_id)
        //        pre_booking_params = try values.decodeIfPresent(Pre_booking_params.self, forKey: .pre_booking_params)
        //         country_list = try values.decodeIfPresent(Country_list.self, forKey: .country_list)
        //        form_params = try values.decodeIfPresent(Form_params.self, forKey: .form_params)
        //        search_data = try values.decodeIfPresent(Search_data.self, forKey: .search_data)
        //        pax_details = try values.decodeIfPresent(Bool.self, forKey: .pax_details)
        //        travel_date_diff = try values.decodeIfPresent(String.self, forKey: .travel_date_diff)
        //        session_expiry_details = try values.decodeIfPresent(Session_expiry_details.self, forKey: .session_expiry_details)
        //        converted_currency_rate = try values.decodeIfPresent(Int.self, forKey: .converted_currency_rate)
        //        flight_terms_cancellation_policy = try values.decodeIfPresent(String.self, forKey: .flight_terms_cancellation_policy)
        //        convenience_fees = try values.decodeIfPresent(Int.self, forKey: .convenience_fees)
        //        total_price = try values.decodeIfPresent(Double.self, forKey: .total_price)
        //        reward_usable = try values.decodeIfPresent(Int.self, forKey: .reward_usable)
        //        reward_earned = try values.decodeIfPresent(Int.self, forKey: .reward_earned)
        //        total_price_with_rewards = try values.decodeIfPresent(Int.self, forKey: .total_price_with_rewards)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        msg = try values.decodeIfPresent(String.self, forKey: .msg)
    }
    
}
