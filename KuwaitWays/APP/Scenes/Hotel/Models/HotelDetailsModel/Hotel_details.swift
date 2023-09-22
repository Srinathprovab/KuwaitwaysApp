

import Foundation
struct Hotel_details : Codable {
    let format_desc : [Format_desc]?
    let booking_source : String?
    let currency : String?
    let city_code : String?
    let address : String?
    let location : String?
    let phone_number : String?
    let website : String?
    let country_name : String?
    let thumb_image : String?
    let email : String?
    let image : String?
    let maxRate : String?
    let checkIn : String?
    let rooms : [[Rooms]]?
    let name : String?
    let longitude : String?
    let accomodation_cstr : String?
    let facility_search : [String]?
    let star_rating : Int?
    let images : [Images]?
    let extra_details : String?
    let price : String?
    let facility_cstr : String?
    let token : String?
    let format_ame : [Format_ame]?
    let minRate : String?
    let hotel_code : Int?
    let country_code : String?
    let city_name : String?
    let fax : String?
    let checkOut : String?
    let facility : String?
    let refund : String?
    let tokenKey : String?
    let latitude : String?

    enum CodingKeys: String, CodingKey {

        case format_desc = "format_desc"
        case booking_source = "booking_source"
        case currency = "currency"
        case city_code = "city_code"
        case address = "address"
        case location = "location"
        case phone_number = "phone_number"
        case website = "website"
        case country_name = "country_name"
        case thumb_image = "thumb_image"
        case email = "email"
        case image = "image"
        case maxRate = "maxRate"
        case checkIn = "checkIn"
        case rooms = "rooms"
        case name = "name"
        case longitude = "longitude"
        case accomodation_cstr = "accomodation_cstr"
        case facility_search = "facility_search"
        case star_rating = "star_rating"
        case images = "images"
        case extra_details = "extra_details"
        case price = "price"
        case facility_cstr = "facility_cstr"
        case token = "Token"
        case format_ame = "format_ame"
        case minRate = "minRate"
        case hotel_code = "hotel_code"
        case country_code = "country_code"
        case city_name = "city_name"
        case fax = "fax"
        case checkOut = "checkOut"
        case facility = "facility"
        case refund = "refund"
        case tokenKey = "TokenKey"
        case latitude = "latitude"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        format_desc = try values.decodeIfPresent([Format_desc].self, forKey: .format_desc)
        booking_source = try values.decodeIfPresent(String.self, forKey: .booking_source)
        currency = try values.decodeIfPresent(String.self, forKey: .currency)
        city_code = try values.decodeIfPresent(String.self, forKey: .city_code)
        address = try values.decodeIfPresent(String.self, forKey: .address)
        location = try values.decodeIfPresent(String.self, forKey: .location)
        phone_number = try values.decodeIfPresent(String.self, forKey: .phone_number)
        website = try values.decodeIfPresent(String.self, forKey: .website)
        country_name = try values.decodeIfPresent(String.self, forKey: .country_name)
        thumb_image = try values.decodeIfPresent(String.self, forKey: .thumb_image)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        image = try values.decodeIfPresent(String.self, forKey: .image)
        maxRate = try values.decodeIfPresent(String.self, forKey: .maxRate)
        checkIn = try values.decodeIfPresent(String.self, forKey: .checkIn)
        rooms = try values.decodeIfPresent([[Rooms]].self, forKey: .rooms)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        longitude = try values.decodeIfPresent(String.self, forKey: .longitude)
        accomodation_cstr = try values.decodeIfPresent(String.self, forKey: .accomodation_cstr)
        facility_search = try values.decodeIfPresent([String].self, forKey: .facility_search)
        star_rating = try values.decodeIfPresent(Int.self, forKey: .star_rating)
        images = try values.decodeIfPresent([Images].self, forKey: .images)
        extra_details = try values.decodeIfPresent(String.self, forKey: .extra_details)
        price = try values.decodeIfPresent(String.self, forKey: .price)
        facility_cstr = try values.decodeIfPresent(String.self, forKey: .facility_cstr)
        token = try values.decodeIfPresent(String.self, forKey: .token)
        format_ame = try values.decodeIfPresent([Format_ame].self, forKey: .format_ame)
        minRate = try values.decodeIfPresent(String.self, forKey: .minRate)
        hotel_code = try values.decodeIfPresent(Int.self, forKey: .hotel_code)
        country_code = try values.decodeIfPresent(String.self, forKey: .country_code)
        city_name = try values.decodeIfPresent(String.self, forKey: .city_name)
        fax = try values.decodeIfPresent(String.self, forKey: .fax)
        checkOut = try values.decodeIfPresent(String.self, forKey: .checkOut)
        facility = try values.decodeIfPresent(String.self, forKey: .facility)
        refund = try values.decodeIfPresent(String.self, forKey: .refund)
        tokenKey = try values.decodeIfPresent(String.self, forKey: .tokenKey)
        latitude = try values.decodeIfPresent(String.self, forKey: .latitude)
    }

}
