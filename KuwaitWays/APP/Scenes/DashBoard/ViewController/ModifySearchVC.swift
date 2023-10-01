//
//  ModifySearchVC.swift
//  KuwaitWays
//
//  Created by FCI on 25/04/23.
//

import UIKit

class ModifySearchVC: BaseTableVC {
    
    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var buttonsView: UIView!
    @IBOutlet weak var oneWayView: UIView!
    @IBOutlet weak var oneWaylbl: UILabel!
    @IBOutlet weak var oneWayBtn: UIButton!
    @IBOutlet weak var roundTripView: UIView!
    @IBOutlet weak var roundTriplbl: UILabel!
    @IBOutlet weak var roundTripBtn: UIButton!
    @IBOutlet weak var multicityView: UIView!
    @IBOutlet weak var multicitylbl: UILabel!
    @IBOutlet weak var multicityBtn: UIButton!
    @IBOutlet weak var btnsHolderiew: UIStackView!
    @IBOutlet weak var closeBrtn: UIButton!
    
    
    var payload = [String:Any]()
    var payload1 = [String:Any]()
    var payload2 = [String:Any]()
    var isVcFrom = String()
    var tablerow = [TableRow]()
    var finalInputArray = [[String:Any]]()
    static var newInstance: ModifySearchVC? {
        let storyboard = UIStoryboard(name: Storyboard.Main.name,
                                      bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: self.className()) as? ModifySearchVC
        return vc
    }
    
  
    
    override func viewWillAppear(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(reload(notification:)), name: NSNotification.Name("calreloadTV"), object: nil)
    }
    
    
    @objc func reload(notification: NSNotification){
        commonTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupUI()
    }
    
    func setupUI() {
        
        self.view.backgroundColor = .black.withAlphaComponent(0.50)
        self.holderView.backgroundColor = .black.withAlphaComponent(0.50)
        closeBrtn.addTarget(self, action: #selector(closeBtnAction(_:)), for: .touchUpInside)
        closeBrtn.setTitle("", for: .normal)
        
        btnsHolderiew.addCornerRadiusWithShadow(color: .clear, borderColor: .AppBorderColor, cornerRadius: 20)
        buttonsView.backgroundColor = .WhiteColor
        //  setupViews(v: buttonsView, radius: 20, color: .WhiteColor)
        setupViews(v: oneWayView, radius: 18, color: .AppJournyTabSelectColor)
        setupViews(v: roundTripView, radius: 18, color: .WhiteColor)
        setupViews(v: multicityView, radius: 18, color: .WhiteColor)
        multicityView.isHidden = true
        
        setupLabels(lbl: oneWaylbl, text: "One Way", textcolor: .WhiteColor, font: .OpenSansRegular(size: 16))
        setupLabels(lbl: roundTriplbl, text: "Round Trip", textcolor: .SubTitleColor, font: .OpenSansRegular(size: 16))
        setupLabels(lbl: multicitylbl, text: "Multicity", textcolor: .SubTitleColor, font: .OpenSansRegular(size: 16))
        
        
        oneWayBtn.setTitle("", for: .normal)
        roundTripBtn.setTitle("", for: .normal)
        multicityBtn.setTitle("", for: .normal)
        
        buttonsView.layer.cornerRadius = 8
        buttonsView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        buttonsView.clipsToBounds = true
        
        
        commonTableView.isScrollEnabled = false
        commonTableView.registerTVCells(["EmptyTVCell",
                                         "SearchFlightTVCell",
                                         "LabelTVCell",
                                         "HotelDealsTVCell",
                                         "MultiCityTripTVCell"])
        
        appendTvcells(str: "oneway")
        if let selectedJourneyType = defaults.string(forKey: UserDefaultsKeys.journeyType) {
            if selectedJourneyType == "multicity" {
                setupMulticity()
            }else if selectedJourneyType == "circle" {
                setupRoundTrip()
            }else {
                setupOneWay()
            }
        }
        
        
        
    }
    
    
    @objc func closeBtnAction(_ sender:UIButton) {
        dismiss(animated: true)
    }
    
    
    func appendTvcells(str:String) {
        tablerow.removeAll()
        
        tablerow.append(TableRow(key:str,cellType:.SearchFlightTVCell))
        tablerow.append(TableRow(height:10,bgColor: .AppBGcolor,cellType:.EmptyTVCell))
        tablerow.append(TableRow(height:500,bgColor: .AppBGcolor,cellType:.EmptyTVCell))
        
        commonTVData = tablerow
        commonTableView.reloadData()
        
    }
    
    
    func appendMulticityTvcells() {
        tablerow.removeAll()
        
        tablerow.append(TableRow(cellType:.MultiCityTripTVCell))
        tablerow.append(TableRow(height:10,bgColor: .AppBGcolor,cellType:.EmptyTVCell))
        tablerow.append(TableRow(height:500,bgColor: .WhiteColor,cellType:.EmptyTVCell))
        
        
        commonTVData = tablerow
        commonTableView.reloadData()
        
    }
    
    
    
    
    @objc func backbtnAction(_ sender:UIButton) {
        dismiss(animated: false)
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
    
    
    
    @IBAction func didTapOnOneWayBtn(_ sender: Any) {
        setupOneWay()
    }
    
    @IBAction func didTapOnRoundTripBtn(_ sender: Any) {
        setupRoundTrip()
    }
    
    
    @IBAction func didTapOnMulticityBtn(_ sender: Any) {
        setupMulticity()
    }
    
    func setupOneWay() {
        oneWaylbl.textColor = .WhiteColor
        roundTriplbl.textColor = .SubTitleColor
        multicitylbl.textColor = .SubTitleColor
        
        oneWayView.backgroundColor = .AppJournyTabSelectColor
        roundTripView.backgroundColor = .WhiteColor
        multicityView.backgroundColor = .WhiteColor
        
        defaults.set("oneway", forKey: UserDefaultsKeys.journeyType)
        appendTvcells(str: "oneway")
    }
    
    
    func setupRoundTrip() {
        oneWaylbl.textColor = .SubTitleColor
        roundTriplbl.textColor = .WhiteColor
        multicitylbl.textColor = .SubTitleColor
        
        oneWayView.backgroundColor = .WhiteColor
        roundTripView.backgroundColor = .AppJournyTabSelectColor
        multicityView.backgroundColor = .WhiteColor
        
        defaults.set("circle", forKey: UserDefaultsKeys.journeyType)
        NotificationCenter.default.post(name: Notification.Name("reload"), object: nil)
        appendTvcells(str: "roundtrip")
    }
    
    
    func setupMulticity() {
        oneWaylbl.textColor = .SubTitleColor
        roundTriplbl.textColor = .SubTitleColor
        multicitylbl.textColor = .WhiteColor
        
        oneWayView.backgroundColor = .WhiteColor
        roundTripView.backgroundColor = .WhiteColor
        multicityView.backgroundColor = .AppJournyTabSelectColor
        
        defaults.set("multicity", forKey: UserDefaultsKeys.journeyType)
        appendMulticityTvcells()
    }
    
    
    
    override func didTapOnFromCity(cell: HolderViewTVCell) {
        gotoSelectCityVC(str: "From", tokey: "Tooo")
    }
    
    override func didTapOnToCity(cell: HolderViewTVCell) {
        gotoSelectCityVC(str: "To", tokey: "frommm")
    }
    
    override func didTapOnSelectDepDateBtn(cell: DualViewTVCell) {
        gotoCalenderVC()
    }
    override func didTapOnSelectRepDateBtn(cell: DualViewTVCell) {
        gotoCalenderVC()
    }
    
    
    override func didTapOnAddTravelerEconomy(cell:HolderViewTVCell){
        gotoAddTravelerVC()
    }
    
    func gotoSelectCityVC(str:String,tokey:String) {
        guard let vc = SelectFromCityVC.newInstance.self else {return}
        vc.modalPresentationStyle = .fullScreen
        vc.titleStr = str
        vc.keyStr = "flight"
        vc.tokey = tokey
        self.present(vc, animated: true)
    }
    
    func gotoCalenderVC() {
        guard let vc = Calvc.newInstance.self else {return}
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: false)
    }
    
    func gotoAddTravelerVC() {
        guard let vc = TravellerEconomyVC.newInstance.self else {return}
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    
    func gotoSearchFlightResultVC(input:[String:Any]) {
        guard let vc = SearchFlightResultVC.newInstance.self else {return}
        vc.modalPresentationStyle = .fullScreen
        callapibool = true
        loderBool = true
        vc.payload = input
        self.present(vc, animated: true)
    }
    
    
    override func didTapOnSearchFlightsBtn(cell:SearchFlightTVCell) {
        
        payload.removeAll()
        
        let journyType = defaults.string(forKey: UserDefaultsKeys.journeyType)
        if journyType == "oneway" {
            
            payload["trip_type"] = defaults.string(forKey: UserDefaultsKeys.journeyType)
            payload["adult"] = defaults.string(forKey: UserDefaultsKeys.adultCount)
            payload["child"] = defaults.string(forKey: UserDefaultsKeys.childCount)
            payload["infant"] = defaults.string(forKey: UserDefaultsKeys.infantsCount)
            payload["sector_type"] = "international"
            payload["from"] = defaults.string(forKey: UserDefaultsKeys.fromCity)
            payload["from_loc_id"] = defaults.string(forKey: UserDefaultsKeys.fromlocid)
            payload["to"] = defaults.string(forKey: UserDefaultsKeys.toCity)
            payload["to_loc_id"] = defaults.string(forKey: UserDefaultsKeys.tolocid)
            payload["depature"] = defaults.string(forKey: UserDefaultsKeys.calDepDate)
            payload["return"] = ""
            payload["carrier"] = ""
            payload["psscarrier"] = "ALL"
            payload["v_class"] = defaults.string(forKey: UserDefaultsKeys.selectClass) ?? "Economy"
            payload["search_flight"] = "Search"
            payload["search_source"] = "search"
            payload["user_id"] = defaults.string(forKey: UserDefaultsKeys.userid) ?? "0"
            payload["currency"] = defaults.string(forKey: UserDefaultsKeys.selectedCurrency) ?? "AED"

            
            if defaults.string(forKey:UserDefaultsKeys.fromCity) == "" {
                showToast(message: "Please Select From City")
            }else if defaults.string(forKey:UserDefaultsKeys.toCity) == "" {
                showToast(message: "Please Select To City")
            }else if defaults.string(forKey:UserDefaultsKeys.toCity) == defaults.string(forKey:UserDefaultsKeys.fromCity) {
                showToast(message: "Please Select Different Citys")
            }else if defaults.string(forKey:UserDefaultsKeys.calDepDate) == "" {
                showToast(message: "Please Select Departure Date")
            }else if defaults.string(forKey:UserDefaultsKeys.travellerDetails) == "Add Details" {
                showToast(message: "Add Traveller")
            }else if defaults.string(forKey:UserDefaultsKeys.selectClass) == "Add Details" {
                showToast(message: "Add Class")
            }else if checkDepartureAndReturnDates1(payload, p1: "depature") == false {
                showToast(message: "Invalid Date")
            }else{
                gotoSearchFlightResultVC(input: payload)
            }
        }else if journyType == "circle"{
            
            
            payload["trip_type"] = defaults.string(forKey: UserDefaultsKeys.journeyType)
            payload["adult"] = defaults.string(forKey: UserDefaultsKeys.radultCount)
            payload["child"] = defaults.string(forKey: UserDefaultsKeys.rchildCount)
            payload["infant"] = defaults.string(forKey: UserDefaultsKeys.rinfantsCount)
            payload["sector_type"] = "international"
            payload["from"] = defaults.string(forKey: UserDefaultsKeys.rfromCity)
            payload["from_loc_id"] = defaults.string(forKey: UserDefaultsKeys.rfromlocid)
            payload["to"] = defaults.string(forKey: UserDefaultsKeys.rtoCity)
            payload["to_loc_id"] = defaults.string(forKey: UserDefaultsKeys.rtolocid)
            payload["depature"] = defaults.string(forKey: UserDefaultsKeys.rcalDepDate)
            payload["return"] = defaults.string(forKey: UserDefaultsKeys.rcalRetDate)
            payload["carrier"] = ""
            payload["psscarrier"] = "ALL"
            payload["v_class"] = defaults.string(forKey: UserDefaultsKeys.selectClass) ?? "Economy"
            payload["search_flight"] = "Search"
            payload["search_source"] = "search"
            payload["user_id"] = defaults.string(forKey: UserDefaultsKeys.userid) ?? "0"
            payload["currency"] = defaults.string(forKey: UserDefaultsKeys.selectedCurrency) ?? "AED"

            if defaults.string(forKey:UserDefaultsKeys.rfromCity) == "" {
                showToast(message: "Please Select From City")
            }else if defaults.string(forKey:UserDefaultsKeys.rtoCity) == "" {
                showToast(message: "Please Select To City")
            }else if defaults.string(forKey:UserDefaultsKeys.rtoCity) == defaults.string(forKey:UserDefaultsKeys.rfromCity) {
                showToast(message: "Please Select Different Citys")
            }else if defaults.string(forKey:UserDefaultsKeys.rcalDepDate) == "" {
                showToast(message: "Please Select Departure Date")
            }else if defaults.string(forKey:UserDefaultsKeys.rcalRetDate) == "" {
                showToast(message: "Please Select Departure Date")
            }else if defaults.string(forKey:UserDefaultsKeys.travellerDetails) == "Add Details" {
                showToast(message: "Add Traveller")
            }else if defaults.string(forKey:UserDefaultsKeys.selectClass) == "Add Details" {
                showToast(message: "Add Class")
            }else if checkDepartureAndReturnDates(payload, p1: "depature", p2: "return") == false {
                showToast(message: "Invalid Date")
            }else{
                gotoSearchFlightResultVC(input: payload)
            }
        }else {
            
        }
        
    }
    
    
    
    override func didTapOnFromBtn(cell:MulticityFromToTVCell){
        gotoSelectCityVC(str: "From", tokey: "")
    }
    override func didTapOnToBtn(cell:MulticityFromToTVCell){
        gotoSelectCityVC(str: "To", tokey: "")
    }
    override func didTapOndateBtn(cell:MulticityFromToTVCell){
        gotoCalenderVC()
    }
    override func didTapOnCloseBtn(cell:MulticityFromToTVCell){
        print("didTapOnCloseBtn")
    }
    override func didTapOnAddTravellerEconomy(cell:HolderViewTVCell){
        gotoAddTravelerVC()
    }
    
    override func didTapOnMultiCityTripSearchFlight(cell:ButtonTVCell){
        payload.removeAll()
        payload1.removeAll()
        payload2.removeAll()
        finalInputArray.removeAll()
        for (index,_) in fromCityNameArray.enumerated() {
            
            payload2["from"] = fromCityNameArray[index]
            payload2["from_loc_id"] = fromlocidArray[index]
            payload2["to"] = toCityNameArray[index]
            payload2["to_loc_id"] = tolocidArray[index]
            payload2["depature"] = depatureDatesArray[index]
            
            finalInputArray.append(payload2)
            
        }
        
        payload["sector_type"] = "international"
        payload["trip_type"] = defaults.string(forKey:UserDefaultsKeys.journeyType)
        payload["adult"] = defaults.string(forKey: UserDefaultsKeys.madultCount)
        payload["child"] = defaults.string(forKey: UserDefaultsKeys.mchildCount)
        payload["infant"] = defaults.string(forKey: UserDefaultsKeys.minfantsCount)
        payload["checkbox-group"] = "on"
        payload["search_flight"] = "Search"
        payload["anNonstopflight"] = "1"
        payload["carrier"] = ""
        payload["psscarrier"] = "ALL"
        payload["remngwd"] = defaults.string(forKey: UserDefaultsKeys.mselectClass)
        payload["v_class"] = defaults.string(forKey: UserDefaultsKeys.mselectClass)
        payload["user_id"] = "0"
        payload["selectedCurrency"] = defaults.string(forKey: UserDefaultsKeys.selectedCurrency) ?? "AED"
        payload["placeDetails"] = finalInputArray
        
        
        var showToastMessage: String? = nil
        
        for cityName in fromCityNameArray {
            if cityName == "From" {
                showToastMessage = "Please Select Origin"
                break
            }
        }
        
        if showToastMessage == nil {
            for cityName in toCityNameArray {
                if cityName == "To" {
                    showToastMessage = "Please Select Destination"
                    break
                }
            }
        }
        
        if showToastMessage == nil {
            for date in depatureDatesArray {
                if date == "Date" {
                    showToastMessage = "Please Select Date"
                    break
                }
            }
        }
        
        
        
        if showToastMessage == nil {
            if depatureDatesArray != depatureDatesArray.sorted() {
                showToastMessage = "Please Select Dates in Ascending Order"
            } else if depatureDatesArray.count == 2 && depatureDatesArray[0] == depatureDatesArray[1] {
                showToastMessage = "Please Select Different Dates"
            }
        }
        
        
        
        if let message = showToastMessage {
            showToast(message: message)
        } else {
            gotoSearchFlightResultVC(input: payload)
        }
        
        
    }
}
