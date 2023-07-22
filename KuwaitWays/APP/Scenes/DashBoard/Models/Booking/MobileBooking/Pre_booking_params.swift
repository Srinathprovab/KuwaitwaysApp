/* 
Copyright (c) 2023 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct Pre_booking_params : Codable {
	let search_id : String?
	let booking_source : String?
	let promocode_val : String?
	let access_key : String?
	let booking_id : String?

	enum CodingKeys: String, CodingKey {

		case search_id = "search_id"
		case booking_source = "booking_source"
		case promocode_val = "promocode_val"
		case access_key = "access_key"
		case booking_id = "booking_id"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		search_id = try values.decodeIfPresent(String.self, forKey: .search_id)
		booking_source = try values.decodeIfPresent(String.self, forKey: .booking_source)
		promocode_val = try values.decodeIfPresent(String.self, forKey: .promocode_val)
		access_key = try values.decodeIfPresent(String.self, forKey: .access_key)
		booking_id = try values.decodeIfPresent(String.self, forKey: .booking_id)
	}

}
