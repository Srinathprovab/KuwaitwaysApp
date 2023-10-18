//
//  PayNowVC.swift
//  BeeoonsApp
//
//  Created by MA673 on 18/08/22.
//

import UIKit

class PayNowVC: BaseTableVC, PreProcessBookingViewModelDelegate, TimerManagerDelegate {
    
    
    
    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var nav: NavBar!
    @IBOutlet weak var navHeight: NSLayoutConstraint!
    @IBOutlet weak var viewFlightsBtnView: UIView!
    @IBOutlet weak var viewFlightlbl: UILabel!
    @IBOutlet weak var viewFlightsBtn: UIButton!
    @IBOutlet weak var bookNowHolderView: UIView!
    @IBOutlet weak var titlelbl: UILabel!
    @IBOutlet weak var bookNowView: UIView!
    @IBOutlet weak var bookNowlbl: UILabel!
    @IBOutlet weak var bookNowBtn: UIButton!
    
    static var newInstance: PayNowVC? {
        let storyboard = UIStoryboard(name: Storyboard.Main.name,
                                      bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: self.className()) as? PayNowVC
        return vc
    }
    
    var tmpFlightPreBookingId = String()
    var fnameA = [String]()
    var passengertypeA = [String]()
    var title2A = [String]()
    var mnameA = [String]()
    var lnameA = [String]()
    var dobA = [String]()
    var passportNoA = [String]()
    var countryCodeA = [String]()
    var genderA = [String]()
    var passportexpiryA = [String]()
    var passportissuingcountryA = [String]()
    var middleNameA = [String]()
    var leadPassengerA = [String]()
    var activepaymentoptions = String()
    var tokenkey1 = String()
    var callpaymenthotelbool = true
    var tokenkey = String()
    let datePicker = UIDatePicker()
    var tablerow = [TableRow]()
    var bool = true
    var name = String()
    var flighttotelCount = 0
    var hoteltotelCount = 0
    var adultsCount = Int()
    var childCount = Int()
    var infantsCount = Int()
    var payload = [String:Any]()
    var payload1 = [String:Any]()
    var secureapidonebool = false
    var hbookingToken = String()
    var vm:PreProcessBookingViewModel?
    var vm1:HotelMBViewModel?
    var positionsCount = 0
    var callpaymentbool = Bool()
    
    // Initialize an array to store the validation state for each cell
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        TimerManager.shared.delegate = self
        vm = PreProcessBookingViewModel(self)
        vm1 = HotelMBViewModel(self)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        addObserver()
        
        
        if let journeyType = defaults.string(forKey: UserDefaultsKeys.tabselect) {
            if journeyType == "Flight" {
                DispatchQueue.main.async {[self] in
                    holderView.isHidden = true
                    viewFlightlbl.text = "View Flight Details"
                    nav.citylbl.text = defaults.string(forKey: UserDefaultsKeys.journeyCitys) ?? ""
                    nav.datelbl.text = defaults.string(forKey: UserDefaultsKeys.journeyDates) ?? ""
                    
                    
                    if let journeyType = defaults.string(forKey: UserDefaultsKeys.journeyType) {
                        if journeyType == "oneway" {
                            nav.travellerlbl.text = defaults.string(forKey: UserDefaultsKeys.travellerDetails) ?? ""
                            
                            adultsCount = Int(defaults.string(forKey: UserDefaultsKeys.adultCount) ?? "1") ?? 0
                            childCount = Int(defaults.string(forKey: UserDefaultsKeys.childCount) ?? "0") ?? 0
                            infantsCount = Int(defaults.string(forKey: UserDefaultsKeys.infantsCount) ?? "0") ?? 0
                            flighttotelCount = (adultsCount + childCount + infantsCount)
                            
                            
                        }else if journeyType == "circle"{
                            nav.travellerlbl.text = defaults.string(forKey: UserDefaultsKeys.rtravellerDetails) ?? ""
                            
                            adultsCount = Int(defaults.string(forKey: UserDefaultsKeys.radultCount) ?? "1") ?? 0
                            childCount = Int(defaults.string(forKey: UserDefaultsKeys.rchildCount) ?? "0") ?? 0
                            infantsCount = Int(defaults.string(forKey: UserDefaultsKeys.rinfantsCount) ?? "0") ?? 0
                            flighttotelCount = (adultsCount + childCount + infantsCount)
                        }else {
                            nav.travellerlbl.text = defaults.string(forKey: UserDefaultsKeys.mtravellerDetails) ?? ""
                            
                            adultsCount = Int(defaults.string(forKey: UserDefaultsKeys.madultCount) ?? "1") ?? 0
                            childCount = Int(defaults.string(forKey: UserDefaultsKeys.mchildCount) ?? "0") ?? 0
                            infantsCount = Int(defaults.string(forKey: UserDefaultsKeys.minfantsCount) ?? "0") ?? 0
                            flighttotelCount = (adultsCount + childCount + infantsCount)
                        }
                    }
                    
                    viewFlightsBtn.addTarget(self, action: #selector(didTapOnViewFlightDetails(_:)), for: .touchUpInside)
                    
                    if callapibool == true {
                        callAPI()
                    }
                }
            }else {
                DispatchQueue.main.async {[self] in
                    holderView.isHidden = true
                    viewFlightlbl.text = "View Hotel Details"
                    viewFlightsBtn.addTarget(self, action: #selector(didTapOnViewHotelDetails(_:)), for: .touchUpInside)
                    
                    adultsCount = Int(defaults.string(forKey: UserDefaultsKeys.hoteladultscount) ?? "1") ?? 0
                    childCount = Int(defaults.string(forKey: UserDefaultsKeys.hotelchildcount) ?? "0") ?? 0
                    nav.citylbl.text = "\(defaults.string(forKey: UserDefaultsKeys.locationcity) ?? "")"
                    nav.datelbl.text = "CheckIn - \(convertDateFormat(inputDate: defaults.string(forKey: UserDefaultsKeys.checkin) ?? "" , f1: "dd-MM-yyyy", f2: "dd MMM")) & CheckOut - \(convertDateFormat(inputDate: defaults.string(forKey: UserDefaultsKeys.checkout) ?? "", f1: "dd-MM-yyyy", f2: "dd MMM"))"
                    nav.travellerlbl.text = "Guests- \(defaults.string(forKey: UserDefaultsKeys.guestcount) ?? "1") / Room - \(defaults.string(forKey: UserDefaultsKeys.roomcount) ?? "")"
                    
                    
                    if callapibool == true {
                        callHotelMobileBookingAPI()
                    }
                }
            }
        }
        
    }
    
    
    
    
    
    
    func setupUI() {
        
        if screenHeight > 835 {
            navHeight.constant = 185
        }else {
            navHeight.constant = 145
        }
        
        holderView.backgroundColor = .WhiteColor
        nav.titlelbl.text = "Booking Details"
        nav.backBtn.addTarget(self, action: #selector(gotoBackScreen), for: .touchUpInside)
        nav.citylbl.isHidden = false
        nav.datelbl.isHidden = false
        nav.travellerlbl.isHidden = false
        
        
        viewFlightsBtnView.backgroundColor = .clear
        viewFlightsBtnView.addCornerRadiusWithShadow(color: .clear, borderColor: HexColor("#C5A47E"), cornerRadius: 15)
        viewFlightlbl.textColor = .WhiteColor
        viewFlightlbl.font = UIFont.poppinsRegular(size: 14)
        viewFlightsBtn.setTitle("", for: .normal)
        
        setupViews(v: bookNowHolderView, radius: 0, color: .AppJournyTabSelectColor)
        setupViews(v: bookNowView, radius: 6, color: .AppNavBackColor)
        bookNowView.layer.cornerRadius = 20
        bookNowView.clipsToBounds = true
        setupLabels(lbl: titlelbl, text: grandTotal, textcolor: .WhiteColor, font: .OpenSansMedium(size: 20))
        setupLabels(lbl: bookNowlbl, text: "PAY NOW", textcolor: .WhiteColor, font: .OpenSansMedium(size: 16))
        bookNowBtn.setTitle("", for: .normal)
        
        
        commonTableView.registerTVCells(["TDetailsLoginTVCell",
                                         "EmptyTVCell",
                                         "PromocodeTVCell",
                                         "PriceSummaryTVCell",
                                         "checkOptionsTVCell",
                                         "PriceLabelsTVCell",
                                         "AddDeatilsOfGuestTVCell",
                                         "AcceptTermsAndConditionTVCell",
                                         "HotelPurchaseSummaryTVCell",
                                         "AddDeatilsOfTravellerTVCell",
                                         "CommonTVAddTravellerTVCell",
                                         "BillingAddressTVCell",
                                         "TotalNoofTravellerTVCell",
                                         "AddInfantaTravellerTVCell"])
        
    }
    
    func setupViews(v:UIView,radius:CGFloat,color:UIColor) {
        v.backgroundColor = color
        v.layer.cornerRadius = radius
        v.clipsToBounds = true
        v.layer.borderWidth = 0.2
        v.layer.borderColor = UIColor.AppBorderColor.cgColor
    }
    
    func setupLabels(lbl:UILabel,text:String,textcolor:UIColor,font:UIFont) {
        lbl.text = text
        lbl.textColor = textcolor
        lbl.font = font
    }
    
    @objc func gotoBackScreen() {
        
        if secureapidonebool == true {
            guard let vc = DBTabbarController.newInstance.self else {return}
            vc.modalPresentationStyle = .fullScreen
            vc.selectedIndex = 0
            callapibool = true
            present(vc, animated: true)
        }else {
            NotificationCenter.default.post(name: NSNotification.Name("reloadTimer"), object: nil)
            callapibool = false
            dismiss(animated: true)
        }
        
    }
    
    
    override func didTapOnExpandAdultViewbtnAction(cell: AddDeatilsOfTravellerTVCell) {
        if cell.expandViewBool == true {
            
            cell.expandView()
            cell.expandViewBool = false
        }else {
            
            cell.collapsView()
            cell.expandViewBool = true
        }
        
        commonTableView.beginUpdates()
        commonTableView.endUpdates()
    }
    
    
    override func tfeditingChanged(tf:UITextField) {
        print(tf.tag)
    }
    
    
    
    override func donedatePicker(cell:AddDeatilsOfTravellerTVCell){
        self.view.endEditing(true)
    }
    
    override func cancelDatePicker(cell:AddDeatilsOfTravellerTVCell){
        self.view.endEditing(true)
    }
    
    
    
    
    //MARK: - setupTVCells
    func setupTVCells() {
        tablerow.removeAll()
        holderView.isHidden = false
        
        
        if defaults.bool(forKey: UserDefaultsKeys.loggedInStatus) == false {
            tablerow.append(TableRow(cellType:.TDetailsLoginTVCell))
        }
        
        
        
        passengertypeArray.removeAll()
        tablerow.append(TableRow(height:20, bgColor:.AppHolderViewColor,cellType:.EmptyTVCell))
        tablerow.append(TableRow(title:"Passenger Details",cellType:.TotalNoofTravellerTVCell))
        for i in 1...adultsCount {
            positionsCount += 1
            passengertypeArray.append("Adult")
            let travellerCell = TableRow(title: "Adult \(i)", key: "adult", headerText: "Mr",characterLimit: positionsCount, cellType: .AddDeatilsOfTravellerTVCell)
            tablerow.append(travellerCell)
            
        }
        
        
        if childCount != 0 {
            for i in 1...childCount {
                positionsCount += 1
                passengertypeArray.append("Child")
                tablerow.append(TableRow(title:"Child \(i)",key:"child",headerText: "Master",characterLimit: positionsCount,cellType:.AddDeatilsOfTravellerTVCell))
            }
        }
        
        if infantsCount != 0 {
            for i in 1...infantsCount {
                positionsCount += 1
                passengertypeArray.append("Infant")
                tablerow.append(TableRow(title:"Infant \(i)",key:"infant",headerText: "Master",characterLimit: positionsCount,cellType:.AddDeatilsOfTravellerTVCell))
            }
        }
        
       
        //   tablerow.append(TableRow(cellType:.BillingAddressTVCell))
        tablerow.append(TableRow(cellType:.PromocodeTVCell))
        tablerow.append(TableRow(cellType:.PriceSummaryTVCell))
        tablerow.append(TableRow(title:"I Accept T&C and Privacy Policy",cellType:.AcceptTermsAndConditionTVCell))
        tablerow.append(TableRow(height:30, bgColor:.AppBGcolor,cellType:.EmptyTVCell))
        
        
        commonTVData = tablerow
        commonTableView.reloadData()
    }
    
    
    
    
    
    
    
    //MARK: - didTapOnViewFlightDetails
    @objc func didTapOnViewFlightDetails(_ sender:UIButton) {
        guard let vc = ViewFlightDetailsVC.newInstance.self else {return}
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    
    //MARK: - didTapOnViewHotelDetails
    @objc func didTapOnViewHotelDetails(_ sender:UIButton) {
        guard let vc = ViewHotelDetailsVC.newInstance.self else {return}
        vc.modalPresentationStyle = .overCurrentContext
        isFromVCBool = true
        self.present(vc, animated: true)
    }
    
    
    override func didTapOnLoginBtn(cell: TDetailsLoginTVCell) {
        guard let vc = LoginVC.newInstance.self else {return}
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    override func didTapOnApplyBtn(cell:PromocodeTVCell){
        print("didTapOnApplyBtn")
    }
    
    override func didTapOnRefundBtn(cell: PriceSummaryTVCell) {
        commonTableView.reloadData()
    }
    
    
    
    override func didTapOnSelectAdultTraveller(Cell: AddAdultsOrGuestTVCell) {
        
    }
    
    func goToSaveTravellersDetailsVC(ptitle:String,keyStr:String,pid:String) {
        guard let vc = SaveTravellersDetailsVC.newInstance.self else {return}
        vc.modalPresentationStyle = .fullScreen
        vc.ptitle = ptitle
        vc.keyStr = keyStr
        vc.id = pid
        self.present(vc, animated: true)
    }
    
    
    override func didTapOnTAndCAction(cell: AcceptTermsAndConditionTVCell) {
        gotoAboutUsVC(keystr: "terms")
    }
    
    override func didTapOnPrivacyPolicyAction(cell: AcceptTermsAndConditionTVCell) {
        gotoAboutUsVC(keystr: "aboutus")
    }
    
    func gotoAboutUsVC(keystr:String) {
        guard let vc = AboutUsVC.newInstance.self else {return}
        vc.modalPresentationStyle = .overCurrentContext
        vc.keystr = keystr
        present(vc, animated: true)
    }
    
    override func editingMDCOutlinedTextField(tf:UITextField){
        
    }
    
    
    @IBAction func didTapOPayNowBtn(_ sender: Any) {
        if let journeyType = defaults.string(forKey: UserDefaultsKeys.tabselect) {
            if journeyType == "Flight" {
                tapOnPayNow()
            }else {
                hotelTapPayNow()
            }
        }
    }
    
    
    
    override func didTapOnExpandAdultViewbtnAction(cell: AddDeatilsOfGuestTVCell){
        if cell.expandViewBool == true {
            
            cell.expandView()
            cell.expandViewBool = false
        }else {
            
            cell.collapsView()
            cell.expandViewBool = true
        }
        
        commonTableView.beginUpdates()
        commonTableView.endUpdates()
    }
    
    
    //MARK: - BillingAddressTVCell didTapOnBillingAddressDropDownBtnAction
    override func didTapOnBillingAddressDropDownBtnAction(cell: BillingAddressTVCell) {
        if cell.expandViewBool == true {
            
            cell.expandView()
            cell.expandViewBool = false
        }else {
            
            cell.collapsView()
            cell.expandViewBool = true
        }
        
        commonTableView.beginUpdates()
        commonTableView.endUpdates()
    }
    
    
}

extension PayNowVC {
    
    //MARK: - CALL_PRE_PROCESS_BOOKING_API
    func callAPI() {
        payload.removeAll()
        payload["search_id"] = searchid
        payload["booking_source"] = bookingsourcekey
        payload["access_key"] = accesskey
        payload["user_id"] = defaults.string(forKey: UserDefaultsKeys.userid)
        vm?.CALL_PRE_PROCESS_BOOKING_API(dictParam: payload)
    }
    
    func preProcessBookingDetails(response: PreProcessBookingModel) {
        
        if response.status == true{
            tokenkey1 = response.form_params?.token_key ?? ""
            
            DispatchQueue.main.async {[self] in
                callMobileBookingAPI(res: response)
            }
        }else {
            gotoNoInternetConnectionVC(key: "noresult", titleStr: "NO AVAILABILITY FOR THIS REQUEST")
        }
    }
    
    //MARK: - CALL_MOBILE_BOOKING_API
    func callMobileBookingAPI(res:PreProcessBookingModel) {
        
        
        payload.removeAll()
        payload["search_id"] = searchid
        payload["booking_source"] = bookingsourcekey
        payload["promocode_val"] = ""
        payload["access_key"] = accesskey
        payload["booking_id"] = res.form_params?.booking_id
        
        
        vm?.CALL_MOBILE_BOOKING_API(dictParam: payload)
    }
    
    
    func mobileBookingDetails(response: MobileBookingModel) {
        if response.status == 1 {
            
            activepaymentoptions = response.active_payment_options?[0] ?? ""
            tmpFlightPreBookingId = response.tmp_flight_pre_booking_id ?? ""
            accesskey = response.access_key_tp ?? ""
            bookingsource = response.booking_source ?? ""
            
            specialAssistancelist1 = response.special_allowance ?? []
            meallist = response.meal_list ?? []
            travelerArray.removeAll()
            
            DispatchQueue.main.async {[self] in
                setupTVCells()
            }
        }else {
            gotoNoInternetConnectionVC(key: "noresult", titleStr: "NO AVAILABILITY FOR THIS REQUEST")
        }
    }
    
    
    
}



//MARK: - Did Tap On Flight Pay Now Button API Calls
extension PayNowVC {
    
    
    
    func tapOnPayNow() {
        
        payload.removeAll()
        payload1.removeAll()
        
        
        var callpaymentbool = true
        var fnameCharBool = true
        var lnameCharBool = true
        
        
        
        for traveler in travelerArray {
            
            if traveler.firstName == nil  || traveler.firstName?.isEmpty == true{
                callpaymentbool = false
                
            }
            
            if (traveler.firstName?.count ?? 0) <= 3 {
                fnameCharBool = false
            }
            
            if traveler.lastName == nil || traveler.firstName?.isEmpty == true{
                callpaymentbool = false
            }
            
            if (traveler.lastName?.count ?? 0) <= 3 {
                lnameCharBool = false
            }
            
            if traveler.dob == nil || traveler.dob?.isEmpty == true{
                callpaymentbool = false
            }
           
            if traveler.passportno == nil || traveler.passportno?.isEmpty == true{
                callpaymentbool = false
            }
            
            if traveler.passportIssuingCountry == nil || traveler.passportIssuingCountry?.isEmpty == true{
                callpaymentbool = false
            }
            
            if traveler.passportExpireDate == nil || traveler.passportExpireDate?.isEmpty == true{
                callpaymentbool = false
            }
            
            
            // Continue checking other fields
        }
        
        
        
        
        // Create an array to store validation results for each cell
        var validationResults: [Bool] = []
        
        let positionsCount = commonTableView.numberOfRows(inSection: 0)
        for position in 0..<positionsCount {
            
            
            if let cell = commonTableView.cellForRow(at: IndexPath(row: position, section: 0)) as? AddDeatilsOfTravellerTVCell {
                
                var cellValidationResult = true
                
                if cell.titleTF.text?.isEmpty == true {
                    cell.titleView.layer.borderColor = UIColor.red.cgColor
                    callpaymentbool = false
                    cellValidationResult = false
                }
                
                if cell.fnameTF.text?.isEmpty == true {
                    cell.fnameView.layer.borderColor = UIColor.red.cgColor
                    callpaymentbool = false
                    cellValidationResult = false
                } else if (cell.fnameTF.text?.count ?? 0) <= 3 {
                    cell.fnameView.layer.borderColor = UIColor.red.cgColor
                    fnameCharBool = false
                    cellValidationResult = false
                }
                
                if cell.lnameTF.text?.isEmpty == true {
                    cell.lnameView.layer.borderColor = UIColor.red.cgColor
                    callpaymentbool = false
                    cellValidationResult = false
                } else if (cell.lnameTF.text?.count ?? 0) <= 3 {
                    cell.lnameView.layer.borderColor = UIColor.red.cgColor
                    lnameCharBool = false
                    cellValidationResult = false
                    
                }
                
                if cell.dobTF.text?.isEmpty == true {
                    // Textfield is empty
                    cell.dobView.layer.borderColor = UIColor.red.cgColor
                    callpaymentbool = false
                    cellValidationResult = false
                }
                
                
                if cell.passportnoTF.text?.isEmpty == true {
                    // Textfield is empty
                    cell.passportnoView.layer.borderColor = UIColor.red.cgColor
                    callpaymentbool = false
                    cellValidationResult = false
                }
                
                
                if cell.passportIssuingCountryTF.text?.isEmpty == true {
                    // Textfield is empty
                    cell.issuecountryView.layer.borderColor = UIColor.red.cgColor
                    callpaymentbool = false
                    cellValidationResult = false
                }
                
                
                if cell.passportExpireDateTF.text?.isEmpty == true {
                    // Textfield is empty
                    cell.passportexpireView.layer.borderColor = UIColor.red.cgColor
                    callpaymentbool = false
                    cellValidationResult = false
                }
                
                
                validationResults.append(cellValidationResult)
            }
        }
        
        
        let mrtitleArray = travelerArray.compactMap({$0.mrtitle})
        let laedpassengerArray = travelerArray.compactMap({$0.laedpassenger})
        let middlenameArray = travelerArray.compactMap({$0.middlename})
        let passengertypeArray = travelerArray.compactMap({$0.passengertype})
        let genderArray = travelerArray.compactMap({$0.gender})
        let firstnameArray = travelerArray.compactMap({$0.firstName})
        let lastNameArray = travelerArray.compactMap({$0.lastName})
        let dobArray = travelerArray.compactMap({$0.dob})
        let passportnoArray = travelerArray.compactMap({$0.passportno})
        let passportIssuingCountryArray = travelerArray.compactMap({$0.passportIssuingCountry})
        let passportExpireDateArray = travelerArray.compactMap({$0.passportExpireDate})
        //        let frequentFlyrNoArray = travelerArray.compactMap({$0.frequentFlyrNo})
        //        let mealNameArray = travelerArray.compactMap({$0.meal})
        //        let specialAssicintenceArray = travelerArray.compactMap({$0.specialAssicintence})
        //        let nationalityArray = travelerArray.compactMap({$0.nationality})
        
        
        // Convert arrays to string representations
        let laedpassengerString = "[\"" + laedpassengerArray.joined(separator: "\",\"") + "\"]"
        let genderString = "[\"" + genderArray.joined(separator: "\",\"") + "\"]"
        let mrtitleString = "[\"" + mrtitleArray.joined(separator: "\",\"") + "\"]"
        let firstnameString = "[\"" + firstnameArray.joined(separator: "\",\"") + "\"]"
        let middlenameString = "[\"" + middlenameArray.joined(separator: "\",\"") + "\"]"
        let lastNameString = "[\"" + lastNameArray.joined(separator: "\",\"") + "\"]"
        let dobString = "[\"" + dobArray.joined(separator: "\",\"") + "\"]"
        let passportnoString = "[\"" + passportnoArray.joined(separator: "\",\"") + "\"]"
        let passportIssuingCountryString = "[\"" + passportIssuingCountryArray.joined(separator: "\",\"") + "\"]"
        let passportExpireDateString = "[\"" + passportExpireDateArray.joined(separator: "\",\"") + "\"]"
        let passengertypeArrayString = "[\"" + passengertypeArray.joined(separator: "\",\"") + "\"]"
        
        
        payload["search_id"] = searchid
        payload["tmp_flight_pre_booking_id"] = tmpFlightPreBookingId
        payload["token_key"] = tokenkey1
        payload["access_key"] =  accesskey
        payload["access_key_tp"] =  accesskey
        payload["insurance_policy_type"] = "0"
        payload["insurance_policy_option"] = "0"
        payload["insurance_policy_cover_type"] = "0"
        payload["insurance_policy_duration"] = "0"
        payload["isInsurance"] = "0"
        payload["redeem_points_post"] = "1"
        payload["booking_source"] = bookingsourcekey
        payload["promocode_val"] = ""
        payload["promocode_code"] = ""
        payload["mealsAmount"] = "0"
        payload["baggageAmount"] = "0"
        
        
        payload["passenger_type"] = passengertypeArrayString
        payload["lead_passenger"] = laedpassengerString
        payload["gender"] = genderString
        payload["name_title"] =  mrtitleString
        payload["first_name"] =  firstnameString
        payload["middle_name"] =  middlenameString
        payload["last_name"] =  lastNameString
        payload["date_of_birth"] =  dobString
        payload["passenger_passport_number"] =  passportnoString
        payload["passenger_passport_issuing_country"] =  passportIssuingCountryString
        payload["passenger_nationality"] = passportIssuingCountryString
        payload["passenger_passport_expiry"] =  passportExpireDateString
        payload["Frequent"] = "\([["Select"]])"
        payload["ff_no"] = "\([[""]])"
        payload["payment_method"] =  "PNHB1"
        
        //        payload["address2"] = ""
        //        payload["billing_address_1"] = ""
        //        payload["billing_state"] = ""
        //        payload["billing_city"] = ""
        //        payload["billing_zipcode"] = ""
        payload["billing_email"] = email
        payload["passenger_contact"] = mobile
        payload["country_mobile_code"] = countryCode
        payload["insurance"] = "1"
        payload["tc"] = "on"
        payload["booking_step"] = "book"
        payload["selectedCurrency"] = defaults.string(forKey: UserDefaultsKeys.selectedCurrency) ?? "KWD"
        payload["user_id"] = defaults.string(forKey: UserDefaultsKeys.userid) ?? "0"
        
        
        
        // Check additional conditions
            if !callpaymentbool {
                showToast(message: "Add Details")
            } else if !fnameCharBool {
                showToast(message: "First name should have more than 3 characters")
            } else if !lnameCharBool {
                showToast(message: "Last name should have more than 3 characters")
            } else if checkTermsAndCondationStatus == false {
                showToast(message: "Please Accept T&C and Privacy Policy")
            } else {
                vm?.CALL_PROCESS_PASSENGER_DETAIL_API(dictParam: payload)
            }
        
        
    }
    
    
    
    
    func processPassengerDetails(response: ProcessPassangerDetailModel) {
        secureapidonebool = true
        DispatchQueue.main.async {[self] in
            payload.removeAll()
            payload["app_reference"] = tmpFlightPreBookingId
            payload["search_id"] = searchid
            payload["promocode_val"] = ""
            vm?.CALL_PRE_FLIGHT_BOOKING_API(dictParam: payload, key: searchid)
        }
    }
    
    
    func preFlightBookingDetails(response: ProcessPassangerDetailModel) {
        
        DispatchQueue.main.async {[self] in
            payload.removeAll()
            payload["app_reference"] = tmpFlightPreBookingId
            payload["user_id"] = defaults.string(forKey: UserDefaultsKeys.userid) ?? "0"
            
            vm?.CALL_FLIGHT_PRE_CONF_PAYMENT_API(dictParam: payload, key: "\(searchid)")
        }
    }
    
    
    func flightPrePaymentDetails(response: PrePaymentConfModel) {
        
        DispatchQueue.main.async {[self] in
            payload.removeAll()
            payload["extra_price"] = "0"
            payload["promocode_val"] = "0"
            vm?.CALL_SENDTO_PAYMENT_API(dictParam: payload, key: "\(tmpFlightPreBookingId)/\(searchid)")
        }
    }
    
    
    
    func sendtoPaymentDetails(response: sendToPaymentModel) {
        
        DispatchQueue.main.async {[self] in
            payload.removeAll()
            vm?.CALL_SECURE_BOOKING_API(dictParam: [:], key: "\(tmpFlightPreBookingId)")
        }
    }
    
    
    func secureBookingDetails(response: sendToPaymentModel) {
        
        if response.status == true {
            gotoLoadWebViewVC(url: response.form_url ?? "")
        }else {
            showToast(message: response.msg ?? "")
        }
        
    }
    
    func gotoLoadWebViewVC(url:String) {
        guard let vc = LoadWebViewVC.newInstance.self else {return}
        vc.modalPresentationStyle = .fullScreen
        vc.urlString = url
        present(vc, animated: true)
    }
}


//MARK: - Did Tap On Hotel Pay Now Button API Calls
extension PayNowVC:HotelMBViewModelDelegate {
    
    
    //MARK: - setupHotelTVCells
    func setupHotelTVCells() {
        tablerow.removeAll()
        holderView.isHidden = false
        
        
        if defaults.bool(forKey: UserDefaultsKeys.loggedInStatus) == false {
            tablerow.append(TableRow(cellType:.TDetailsLoginTVCell))
        }
        
        tablerow.append(TableRow(title:"Guest Details",cellType:.TotalNoofTravellerTVCell))
        for i in 1...adultsCount {
            positionsCount += 1
            let travellerCell = TableRow(title: "Adult \(i)", key: "adult", characterLimit: positionsCount, cellType: .AddDeatilsOfGuestTVCell)
            
            tablerow.append(travellerCell)
            
        }
        
        
        if childCount != 0 {
            for i in 1...childCount {
                positionsCount += 1
                tablerow.append(TableRow(title:"Child \(i)",key:"child",characterLimit: positionsCount,cellType:.AddDeatilsOfGuestTVCell))
                
            }
        }
        
        
        tablerow.append(TableRow(cellType:.PromocodeTVCell))
        tablerow.append(TableRow(title:"Purchase Summary",
                                 subTitle: defaults.string(forKey: UserDefaultsKeys.roomType),
                                 key:defaults.string(forKey: UserDefaultsKeys.checkout),
                                 text: defaults.string(forKey: UserDefaultsKeys.hoteladultscount),
                                 headerText: defaults.string(forKey: UserDefaultsKeys.hoteladultscount),
                                 buttonTitle: defaults.string(forKey: UserDefaultsKeys.checkin),
                                 key1: defaults.string(forKey: UserDefaultsKeys.refundtype),
                                 questionType: "KWD:00.00",
                                 TotalQuestions:grandTotal,
                                 cellType:.HotelPurchaseSummaryTVCell,
                                 questionBase: "\(grandTotal)"))
        tablerow.append(TableRow(title:"I Accept T&C and Privacy Policy",cellType:.AcceptTermsAndConditionTVCell))
        tablerow.append(TableRow(height:30, bgColor:.AppBGcolor,cellType:.EmptyTVCell))
        
        commonTVData = tablerow
        commonTableView.reloadData()
    }
    
    
    
    
    
    
    
    //MARK: - callHotelMobileBookingAPI
    func callHotelMobileBookingAPI() {
        
        let ratekeyArrayString = "[\"" + ratekeyArray.joined(separator: "\",\"") + "\"]"
        
        payload.removeAll()
        payload["search_id"] = hsearch_id
        payload["booking_source"] = hbooking_source
        payload["token"] = htoken
        payload["token_key"] = htokenkey
        payload["rateKey"] = ratekeyArrayString
        payload["user_id"] = defaults.string(forKey: UserDefaultsKeys.userid) ?? "0"
        
        
        vm1?.CALL_GET_HOTEL_MOBILE_BOOKING_DETAILS_API(dictParam: payload)
    }
    
    
    //MARK: - hotelMBDetails
    func hotelMBDetails(response: HotelMBModel) {
        
        checkTermsAndCondationStatus = false
        holderView.isHidden = false
        hbookingToken = response.data?.token ?? ""
        hbooking_source = response.data?.booking_source ?? ""
        travelerArray.removeAll()
        
        DispatchQueue.main.async {[self] in
            setupHotelTVCells()
        }
        
    }
    
    
    
    func hotelTapPayNow() {
        
        
        payload.removeAll()
        payload1.removeAll()
        
        var callpaymenthotelbool = true
        var fnameCharBool = true
        var lnameCharBool = true
        
        
        for traveler in travelerArray {
            
            if traveler.firstName == nil  || traveler.firstName?.isEmpty == true{
                callpaymentbool = false
                
            }
            
            if (traveler.firstName?.count ?? 0) <= 3 {
                fnameCharBool = false
            }
            
            if traveler.lastName == nil || traveler.firstName?.isEmpty == true{
                callpaymentbool = false
            }
            
            if (traveler.lastName?.count ?? 0) <= 3 {
                lnameCharBool = false
            }
            
            
            // Continue checking other fields
        }
        
        
       
        let positionsCount = commonTableView.numberOfRows(inSection: 0)
        for position in 0..<positionsCount {
            // Fetch the cell for the given position
            if let cell = commonTableView.cellForRow(at: IndexPath(row: position, section: 0)) as? AddDeatilsOfGuestTVCell {
                
                if cell.titleTF.text?.isEmpty == true {
                    // Textfield is empty
                    cell.titleView.layer.borderColor = UIColor.red.cgColor
                    callpaymenthotelbool = false
                    
                }
                
                if cell.fnameTF.text?.isEmpty == true {
                    // Textfield is empty
                    cell.fnameView.layer.borderColor = UIColor.red.cgColor
                    callpaymenthotelbool = false
                }else if (cell.fnameTF.text?.count ?? 0) <= 3{
                    cell.fnameView.layer.borderColor = UIColor.red.cgColor
                    fnameCharBool = false
                }else {
                    fnameCharBool = true
                }
                
                if cell.lnameTF.text?.isEmpty == true {
                    // Textfield is empty
                    cell.lnameView.layer.borderColor = UIColor.red.cgColor
                    callpaymenthotelbool = false
                }else if (cell.lnameTF.text?.count ?? 0) <= 3{
                    cell.lnameView.layer.borderColor = UIColor.red.cgColor
                    lnameCharBool = false
                } else {
                    // Textfield is not empty
                    lnameCharBool = true
                }
                
                
            }
        }
        
        
        let mrtitleArray = travelerArray.compactMap({$0.mrtitle})
        let passengertypeArray = travelerArray.compactMap({$0.passengertype})
        let firstnameArray = travelerArray.compactMap({$0.firstName})
        let lastNameArray = travelerArray.compactMap({$0.lastName})
        
        
        let mrtitleString = "[\"" + mrtitleArray.joined(separator: "\",\"") + "\"]"
        let firstnameString = "[\"" + firstnameArray.joined(separator: "\",\"") + "\"]"
        let lastNameString = "[\"" + lastNameArray.joined(separator: "\",\"") + "\"]"
        let passengertypeString = "[\"" + passengertypeArray.joined(separator: "\",\"") + "\"]"
        
        
        payload["search_id"] = hsearch_id
        payload["booking_source"] = hbooking_source
        payload["promo_code"] = ""
        payload["token"] = hbookingToken
        payload["redeem_points_post"] = "0"
        payload["reducing_amount"] = "0"
        payload["reward_usable"] = "0"
        payload["reward_earned"] = "0"
        payload["billing_email"] = email
        payload["passenger_contact"] = mobile
        payload["first_name"] =  firstnameString
        payload["last_name"] =  lastNameString
        payload["name_title"] =  mrtitleString
        payload["billing_country"] = billingCountryCode
        payload["country_code"] = countryCode
        payload["passenger_type"] = passengertypeString
        
         if callpaymenthotelbool == false{
            showToast(message: "Add Details")
        }else if fnameCharBool == false{
            showToast(message: "More Than 3 Char")
        }else if lnameCharBool == false{
            showToast(message: "More Than 3 Char")
        }else if checkTermsAndCondationStatus == false {
            showToast(message: "Please Accept T&C and Privacy Policy")
        }else {
            vm1?.CALL_GET_HOTEL_MOBILE_PRE_BOOKING_DETAILS_API(dictParam: payload)
        }
    }
    
    
    func hotelMobilePreBookingDetails(response: HMPreBookingModel) {
        BASE_URL = ""
        secureapidonebool = true
        gotoLoadWebViewVC(url: response.form_url ?? "")
    }
    
    
    
}




extension PayNowVC {
    
    func addObserver() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(nointernet), name: Notification.Name("offline"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: NSNotification.Name("reloadTV"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(resultnil), name: NSNotification.Name("resultnil"), object: nil)
        
    }
    
    @objc func nointernet(){
        gotoNoInternetConnectionVC(key: "nointernet", titleStr: "")
    }
    
    @objc func resultnil(){
        gotoNoInternetConnectionVC(key: "noresult", titleStr: "NO AVAILABILITY FOR THIS REQUEST")
    }
    
    @objc func reload(){
        DispatchQueue.main.async {[self] in
            callAPI()
        }
    }
    
    
    func gotoNoInternetConnectionVC(key:String,titleStr:String) {
        guard let vc = NoInternetConnectionVC.newInstance.self else {return}
        vc.modalPresentationStyle = .overCurrentContext
        vc.key = key
        vc.titleStr = titleStr
        self.present(vc, animated: false)
    }
    
    
    func timerDidFinish() {
        guard let vc = PopupVC.newInstance.self else {return}
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: false)
    }
    
    func updateTimer() {
        
    }
    
}
