//
//  PayNowVC.swift
//  BeeoonsApp
//
//  Created by MA673 on 18/08/22.
//

import UIKit

class PayNowVC: BaseTableVC, PreProcessBookingViewModelDelegate, GetMealsListViewModelDelegate, TimerManagerDelegate {
    
    
    
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
    var vm2:GetMealsListViewModel?
    var positionsCount = 0
    var searchTextArray = [String]()
    
    var callpaymentbool = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        TimerManager.shared.delegate = self
        vm = PreProcessBookingViewModel(self)
        vm1 = HotelMBViewModel(self)
        vm2 = GetMealsListViewModel(self)
    }
    
    
    
    @objc func offline(notificatio:UNNotification) {
        callapibool = true
        guard let vc = NoInternetConnectionVC.newInstance.self else {return}
        vc.modalPresentationStyle = .fullScreen
        vc.key = "offline"
        self.present(vc, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        searchTextArray.removeAll()
        
        addObserver()
        DispatchQueue.main.async {[self] in
            callAPI1()
        }
        
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
    
    
    func callAPI1() {
        DispatchQueue.main.async {[self] in
            vm2?.CALL_GET_MEAL_LIST_API(dictParam: [:])
        }
    }
    
    
    func mealList(response: GetMealsListModel) {
        meallist = response.meal ?? []
        DispatchQueue.main.async {[self] in
            vm2?.CALL_GET_special_Assistance_list_API(dictParam: [:])
        }
    }
    
    func specialAssistancelist(response: GetMealsListModel) {
        specialAssistancelist1 = response.meal ?? []
    }
    

    
    
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
            DispatchQueue.main.async {[self] in
                callMobileBookingAPI(res: response)
            }
        }else {
            gotoNoInternetConnectionVC(key: "noresult", titleStr: "NO AVAILABILITY FOR THIS REQUEST")
        }
    }
    
    //MARK: - CALL_MOBILE_BOOKING_API
    func callMobileBookingAPI(res:PreProcessBookingModel) {
        tmpFlightPreBookingId = res.form_params?.booking_id ?? ""
        tokenkey1 = res.form_params?.token_key ?? ""
        
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
            DispatchQueue.main.async {[self] in
                setupTVCells()
            }
        }else {
            gotoNoInternetConnectionVC(key: "noresult", titleStr: "NO AVAILABILITY FOR THIS REQUEST")
        }
    }
    
    
    func setupUI() {
        
        if screenHeight > 835 {
            navHeight.constant = 180
        }else {
            navHeight.constant = 130
        }
        
        holderView.backgroundColor = .WhiteColor
        nav.titlelbl.text = ""
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
            positionsCount = 1
        }
        
        
        
        tablerow.append(TableRow(height:20, bgColor:.AppBGcolor,cellType:.EmptyTVCell))
        
        
        for i in 1...adultsCount {
            positionsCount += 1
            let travellerCell = TableRow(title: "Adult \(i)", key: "adult", characterLimit: positionsCount, cellType: .AddDeatilsOfTravellerTVCell)
            searchTextArray.append("Adult \(i)")
            tablerow.append(travellerCell)
            
        }
        
        
        if childCount != 0 {
            for i in 1...childCount {
                positionsCount += 1
                tablerow.append(TableRow(title:"Child \(i)",key:"child",characterLimit: positionsCount,cellType:.AddDeatilsOfTravellerTVCell))
                searchTextArray.append("Child \(i)")
            }
        }
        
        if infantsCount != 0 {
            for i in 1...infantsCount {
                positionsCount += 1
                tablerow.append(TableRow(title:"Infant \(i)",key:"infant",characterLimit: positionsCount,cellType:.AddDeatilsOfTravellerTVCell))
                searchTextArray.append("Infant \(i)")
            }
        }
        
        tablerow.append(TableRow(height:10,cellType:.EmptyTVCell))
        tablerow.append(TableRow(cellType:.BillingAddressTVCell))
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
        vc.modalPresentationStyle = .fullScreen
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
    
    override func didTapOnAddAdultBtn(cell: AddAdultTravellerTVCell) {
        ageCategory = AgeCategory.adult
        goToSaveTravellersDetailsVC(ptitle: "Adult", keyStr: "add", pid: "")
    }
    
    override func didTapOnAddChildBtn(cell: AddChildTravellerTVCell) {
        ageCategory = AgeCategory.child
        goToSaveTravellersDetailsVC(ptitle: "Child", keyStr: "add", pid: "")
    }
    
    override func didTapOnAddInfantaBtn(cell: AddInfantaTravellerTVCell) {
        ageCategory = AgeCategory.infant
        goToSaveTravellersDetailsVC(ptitle: "Infanta", keyStr: "add", pid: "")
    }
    
    override func didTapOnEditTraveller(cell: AddAdultsOrGuestTVCell) {
        goToSaveTravellersDetailsVC(ptitle: cell.passengerType, keyStr: "edit", pid: cell.travellerId)
    }
    
    override func didTapOndeleteTravellerBtnAction(cell: AddAdultsOrGuestTVCell) {
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
        vc.modalPresentationStyle = .fullScreen
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


//MARK: - Did Tap On Flight Pay Now Button API Calls
extension PayNowVC {
    
    func tapOnPayNow() {
        
        payload.removeAll()
        payload1.removeAll()
        
        var textfilldshouldmorethan3lettersBool = true
        // Assuming you have a positionsCount variable that holds the number of cells in the table view
        let positionsCount = commonTableView.numberOfRows(inSection: 0)
        
        for position in 0..<positionsCount {
            // Fetch the cell for the given position
            if let cell = commonTableView.cellForRow(at: IndexPath(row: position, section: 0)) as? AddDeatilsOfTravellerTVCell {
                
                if cell.titleTF.text?.isEmpty == true {
                    // Textfield is empty
                    cell.titleView.layer.borderColor = UIColor.red.cgColor
                    callpaymentbool = false
                    
                } else {
                    // Textfield is not empty
                    callpaymentbool = true
                }
                
                if cell.fnameTF.text?.isEmpty == true{
                    // Textfield is empty
                    cell.fnameView.layer.borderColor = UIColor.red.cgColor
                    cell.callpaymentbool = false
                }else if ((cell.fnameTF.text?.count ?? 0) <= 3) {
                    // Textfield is empty
                    showToast(message: "Enter More Than 3 Chars")
                    cell.fnameView.layer.borderColor = UIColor.red.cgColor
                    textfilldshouldmorethan3lettersBool = false
                    callpaymentbool = false
                }else {
                    // Textfield is not empty
                    callpaymentbool = true
                }
                
                if cell.lnameTF.text?.isEmpty == true {
                    // Textfield is empty
                    cell.lnameView.layer.borderColor = UIColor.red.cgColor
                    callpaymentbool = false
                } else if ((cell.lnameTF.text?.count ?? 0) <= 3) {
                    // Textfield is empty
                    showToast(message: "Enter More Than 3 Chars")
                    cell.lnameView.layer.borderColor = UIColor.red.cgColor
                    textfilldshouldmorethan3lettersBool = false
                    cell.callpaymentbool = false
                }else {
                    // Textfield is not empty
                    callpaymentbool = true
                }
                
                
                if cell.dobTF.text?.isEmpty == true {
                    // Textfield is empty
                    cell.dobView.layer.borderColor = UIColor.red.cgColor
                    callpaymentbool = false
                } else {
                    // Textfield is not empty
                    callpaymentbool = true
                }
                
                
                if cell.passportnoTF.text?.isEmpty == true {
                    // Textfield is empty
                    cell.passportnoView.layer.borderColor = UIColor.red.cgColor
                    callpaymentbool = false
                } else {
                    // Textfield is not empty
                    callpaymentbool = true
                }
                
                
                if cell.passportIssuingCountryTF.text?.isEmpty == true {
                    // Textfield is empty
                    cell.issuecountryView.layer.borderColor = UIColor.red.cgColor
                    callpaymentbool = false
                } else {
                    // Textfield is not empty
                    callpaymentbool = true
                }
                
                
                if cell.passportExpireDateTF.text?.isEmpty == true {
                    // Textfield is empty
                    cell.passportexpireView.layer.borderColor = UIColor.red.cgColor
                    callpaymentbool = false
                } else {
                    // Textfield is not empty
                    callpaymentbool = true
                }
                
                
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
        let nationalityArray = travelerArray.compactMap({$0.nationality})
        let passportIssuingCountryArray = travelerArray.compactMap({$0.passportIssuingCountry})
        let passportExpireDateArray = travelerArray.compactMap({$0.passportExpireDate})
        let frequentFlyrNoArray = travelerArray.compactMap({$0.frequentFlyrNo})
        let mealNameArray = travelerArray.compactMap({$0.meal})
        let specialAssicintenceArray = travelerArray.compactMap({$0.specialAssicintence})
        
        
        payload["search_id"] = searchid
        payload["tmp_flight_pre_booking_id"] = tmpFlightPreBookingId
        payload["access_key_tp"] =  accesskey
        payload["token_key"] = tokenkey1
        payload["access_key"] =  accesskey
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
        
        payload["passenger_type"] = passengertypeArray
        payload["lead_passenger"] = laedpassengerArray
        payload["gender"] = genderArray
     //   payload["passenger_nationality"] = nationalityArray
        payload["name_title"] =  mrtitleArray
        payload["first_name"] =  firstnameArray
        payload["middle_name"] =  middlenameArray
        payload["last_name"] =  lastNameArray
        payload["date_of_birth"] =  dobArray
        payload["passenger_passport_number"] =  passportnoArray
        payload["passenger_passport_issuing_country"] =  passportIssuingCountryArray
        payload["passenger_passport_expiry"] =  passportExpireDateArray
        payload["Frequent"] = [["Select"]]
        payload["ff_no"] = [[""]]
        payload["payment_method"] =  "PNHB1"
        
        payload["address2"] = ""
        payload["billing_address_1"] = ""
        payload["billing_state"] = ""
        payload["billing_city"] = ""
        payload["billing_zipcode"] = ""
        payload["billing_email"] = email
        payload["passenger_contact"] = mobile
        payload["billing_country"] = billingCountryName
        payload["country_mobile_code"] = billingCountryCode
        payload["insurance"] = "1"
        payload["tc"] = "on"
        payload["booking_step"] = "book"
        payload["selectedCurrency"] = defaults.string(forKey: UserDefaultsKeys.selectedCurrency) ?? "KWD"
        payload["user_id"] = defaults.string(forKey: UserDefaultsKeys.userid) ?? "0"
  
        do{
            
            let jsonData = try JSONSerialization.data(withJSONObject: payload, options: JSONSerialization.WritingOptions.prettyPrinted)
            let jsonStringData =  NSString(data: jsonData as Data, encoding: NSUTF8StringEncoding)! as String
            
            if textfilldshouldmorethan3lettersBool == false {
                showToast(message: "Enter More Than 3 Chars")
            }else if callpaymentbool == false {
                showToast(message: "Add Details")
                
            }else if checkTermsAndCondationStatus == false {
                showToast(message: "Please Accept T&C and Privacy Policy")
            }else {
                print(jsonStringData)
                payload1["passenger_request"] = jsonStringData
                vm?.CALL_PROCESS_PASSENGER_DETAIL_API(dictParam: payload, key: tmpFlightPreBookingId)
                
            }
            
        }catch{
            print(error.localizedDescription)
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
        
        
        for i in 1...adultsCount {
            positionsCount += 1
            let travellerCell = TableRow(title: "Adult \(i)", key: "adult", characterLimit: positionsCount, cellType: .AddDeatilsOfGuestTVCell)
            searchTextArray.append("Adult \(i)")
            tablerow.append(travellerCell)
            
        }
        
        
        if childCount != 0 {
            for i in 1...childCount {
                positionsCount += 1
                tablerow.append(TableRow(title:"Child \(i)",key:"child",characterLimit: positionsCount,cellType:.AddDeatilsOfGuestTVCell))
                searchTextArray.append("Child \(i)")
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
                                 questionType: "KWD:30.00",
                                 TotalQuestions:grandTotal,
                                 cellType:.HotelPurchaseSummaryTVCell,
                                 questionBase: "KWD:150.00"))
        tablerow.append(TableRow(title:"I Accept T&C and Privacy Policy",cellType:.AcceptTermsAndConditionTVCell))
        tablerow.append(TableRow(height:30, bgColor:.AppBGcolor,cellType:.EmptyTVCell))
        
        commonTVData = tablerow
        commonTableView.reloadData()
    }
    
    
    
    
    
    
    
    //MARK: - callHotelMobileBookingAPI
    func callHotelMobileBookingAPI() {
        payload.removeAll()
        payload["search_id"] = hsearch_id
        payload["booking_source"] = hbooking_source
        payload["token"] = htoken
        payload["token_key"] = htokenkey
        payload["rateKey"] = ratekeyArray
        payload["user_id"] = defaults.string(forKey: UserDefaultsKeys.userid) ?? "0"
        
        
        vm1?.CALL_GET_HOTEL_MOBILE_BOOKING_DETAILS_API(dictParam: payload)
    }
    
    
    //MARK: - hotelMBDetails
    func hotelMBDetails(response: HotelMBModel) {
        
        checkTermsAndCondationStatus = false
        holderView.isHidden = false
        hbookingToken = response.data?.token ?? ""
        hbooking_source = response.data?.booking_source ?? ""
        
        
        DispatchQueue.main.async {[self] in
            setupHotelTVCells()
        }
        
    }
    
    func hotelTapPayNow() {
        
        
        payload.removeAll()
        payload1.removeAll()
        
        
        
        
        var callpaymenthotelbool = true
        var matchingCells: [AddDeatilsOfGuestTVCell] = []
        // Replace with the desired search texts
        
        for case let cell as AddDeatilsOfGuestTVCell in commonTableView.visibleCells {
            if let cellText = cell.titlelbl.text, searchTextArray.contains(cellText) {
                matchingCells.append(cell)
            }
        }
        
        for cell in matchingCells {
            
            if cell.titleTF.text?.isEmpty == true {
                // Textfield is empty
                cell.titleView.layer.borderColor = UIColor.red.cgColor
                callpaymenthotelbool = false
                
            } else {
                // Textfield is not empty
            }
            
            if cell.fnameTF.text?.isEmpty == true {
                // Textfield is empty
                cell.fnameView.layer.borderColor = UIColor.red.cgColor
                callpaymenthotelbool = false
            } else {
                // Textfield is not empty
            }
            
            if cell.lnameTF.text?.isEmpty == true {
                // Textfield is empty
                cell.lnameView.layer.borderColor = UIColor.red.cgColor
                callpaymenthotelbool = false
            } else {
                // Textfield is not empty
            }
            
        }
        
        
        let mrtitleArray = travelerArray.compactMap({$0.mrtitle})
        let passengertypeArray = travelerArray.compactMap({$0.passengertype})
        let firstnameArray = travelerArray.compactMap({$0.firstName})
        let lastNameArray = travelerArray.compactMap({$0.lastName})
        
        
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
        payload["first_name"] =  firstnameArray
        payload["last_name"] =  lastNameArray
        payload["name_title"] =  mrtitleArray
        payload["billing_country"] = billingCountryCode
        payload["country_code"] = countryCode
        payload["passenger_type"] = passengertypeArray
        
        if billingCountryCode == "" {
            showToast(message: "Enter Country Code")
        }else if callpaymenthotelbool == false{
            showToast(message: "Add Details")
        }else if checkTermsAndCondationStatus == false {
            showToast(message: "Please Accept T&C and Privacy Policy")
        }else {
            vm1?.CALL_GET_HOTEL_MOBILE_PRE_BOOKING_DETAILS_API(dictParam: payload)
        }
        
    }
    
    
    func hotelMobilePreBookingDetails(response: HMPreBookingModel) {
        BASE_URL = ""
        secureapidonebool = true
        vm1?.CALL_GET_HOTEL_SECURE_BOOKING_API(dictParam: [:], urlstr: response.data?.post_data?.url ?? "")
    }
    
    
    func hotelSecureBookingDetails(response: HotelSecureBookingModel) {
        BASE_URL = BASE_URL1
        
        if response.status == 1 {
            print(response.url)
            gotoLoadWebViewVC(url: response.url ?? "")
        }
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
