//
//  SearchFlightResultVC.swift
//  BeeoonsApp
//
//  Created by MA673 on 17/08/22.
//

import UIKit

class SearchFlightResultVC: BaseTableVC,TimerManagerDelegate {
    
    
    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var nav: NavBar!
    @IBOutlet weak var navHeight: NSLayoutConstraint!
    @IBOutlet weak var sessonlbl: UILabel!
    @IBOutlet weak var flightsFoundlbl: UILabel!
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var filterBtn: UIButton!
    
    
    static var newInstance: SearchFlightResultVC? {
        let storyboard = UIStoryboard(name: Storyboard.Main.name,
                                      bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: self.className()) as? SearchFlightResultVC
        return vc
    }
    var tablerow = [TableRow]()
    var payload = [String:Any]()
    var payload1 = [String:Any]()
    var payload2 = [String:Any]()
    var finalInputArray = [String:Any]()
    let refreshControl = UIRefreshControl()
    var vm:FlightListViewModel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        vm = FlightListViewModel(self)
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        TimerManager.shared.delegate = self
        addObserver()
        
        
        if callapibool == true {
            DispatchQueue.main.async {[self] in
                TimerManager.shared.sessionStop()
                callAPI()
            }
            
        }
        
    }
    
    
    
    
    @objc func offline(notificatio:UNNotification) {
        callapibool = true
        guard let vc = NoInternetConnectionVC.newInstance.self else {return}
        vc.modalPresentationStyle = .fullScreen
        vc.key = "noresult"
        self.present(vc, animated: false)
    }
    
    
    func callAPI() {
        
        let journyType = defaults.string(forKey: UserDefaultsKeys.journeyType)
        
        
        switch journyType {
        case "oneway":
            vm?.CALL_GET_FLIGHT_LIST_API(dictParam: payload)
            break
            
        case "circle":
            vm?.CALL_GET_FLIGHT_LIST_API(dictParam: payload)
            break
            
        case "multicity":
            
            do {
                let arrJson = try JSONSerialization.data(withJSONObject: payload, options: JSONSerialization.WritingOptions.prettyPrinted)
                let theJSONText = NSString(data: arrJson, encoding: String.Encoding.utf8.rawValue)
                print(theJSONText ?? "")
                
                payload1["search_params"] = theJSONText
                payload1["user_id"] = "0"
                vm?.CALL_GET_MULTICITY_FLIGHT_LIST_API(dictParam: payload1)
                
            }catch let error as NSError{
                print(error.description)
            }
            
            
            
            break
        default:
            break
        }
        
    }
    
    
    
    
    func setupUI() {
        if screenHeight > 835 {
            navHeight.constant = 190
        }else {
            navHeight.constant = 150
        }
        
        view.backgroundColor = HexColor("#CBE4FE")
        holderView.isHidden = true
        holderView.backgroundColor = .AppHolderViewColor
        nav.titlelbl.text = "Search Result"
        nav.backBtn.addTarget(self, action: #selector(gotoBackScreen), for: .touchUpInside)
        nav.citylbl.isHidden = false
        nav.datelbl.isHidden = false
        nav.travellerlbl.isHidden = false
        
        nav.editView.isHidden = false
        nav.editBtn.addTarget(self, action: #selector(didTapOnEditSearchFlight(_:)), for: .touchUpInside)
        
        sessonlbl.text = "Your Session Expires In: 14:15"
        sessonlbl.textColor = .AppLabelColor
        sessonlbl.font = UIFont.OpenSansRegular(size: 12)
        
        flightsFoundlbl.text = "25 Flights found"
        flightsFoundlbl.textColor = .AppLabelColor
        flightsFoundlbl.font = UIFont.OpenSansRegular(size: 12)
        
        filterView.addCornerRadiusWithShadow(color: .clear, borderColor: .clear, cornerRadius: 25)
        filterBtn.setTitle("", for: .normal)
        
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        commonTableView.refreshControl = refreshControl
        setupTV()
    }
    
    @objc func handleRefresh() {
        // Perform data fetching or reloading here
        let seconds = 2.0
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {[self] in
            // Put your code which should be executed with a delay here
            if let journyType = defaults.string(forKey: UserDefaultsKeys.journeyType) {
                if journyType == "oneway" {
                    setupTVCells(jfl: oneWayFlights)
                }else if journyType == "circle"{
                    setupRoundTripTVCells(jfl: oneWayFlights)
                }else {
                    setupMulticityTVCells(jfl: multicityFlights)
                }
            }
            commonTableView.refreshControl?.endRefreshing()
        }
    }
    
    
    
    func setupTV() {
        
        commonTableView.registerTVCells(["SearchFlightResultInfoTVCell",
                                         "RoundTripTVcell",
                                         "EmptyTVCell"])
        
        
        
    }
    
    @objc func gotoBackScreen() {
        TimerManager.shared.sessionStop()
        callapibool = false
        guard let vc = BookFlightVC.newInstance.self else {return}
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false)
    }
    
    
    
    override func didTapOnRefunduableBtn(cell: SearchFlightResultInfoTVCell) {
        print("didTapOnRefunduableBtn")
    }
    
    
    @objc func didTapOnEditSearchFlight(_ sender:UIButton) {
        guard let vc = ModifySearchVC.newInstance.self else {return}
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: false)
    }
    
    
    
    func goToFlightInfoVC() {
        guard let vc = SelectedFlightInfoVC.newInstance.self else {return}
        vc.modalPresentationStyle = .fullScreen
        callapibool = true
        self.present(vc, animated: false)
    }
    
    
    override func didTaponRoundTripCell(cell: RoundTripTVcell) {
        accesskey = cell.access_key1
        goToFlightInfoVC()
    }
    
    @IBAction func didTapOnFilterBtnAction(_ sender: Any) {
        guard let vc = FilterSearchVC.newInstance.self else {return}
        vc.modalPresentationStyle = .overCurrentContext
        vc.delegate = self
        vc.filterTapKey = "sort"
        self.present(vc, animated: false)
    }
    
}


extension SearchFlightResultVC {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? SearchFlightResultInfoTVCell {
            accesskey = cell.access_key1
            goToFlightInfoVC()
        }
    }
}




extension SearchFlightResultVC:FlightListViewModelDelegate {
    
    
    //MARK: - multicityFlightList
    func multicityFlightList(response: MulticityModel) {
        
        
        if response.status == 1 {
            
            view.backgroundColor = .WhiteColor
            loderBool = false
            searchid = "\(response.data?.search_id ?? 0)"
            bookingsource = response.data?.booking_source ?? ""
            bookingsourcekey = response.data?.booking_source_key ?? ""
            
            TimerManager.shared.totalTime = response.session_expiry_details?.session_start_time ?? 0
            TimerManager.shared.startTimer()
            
            
            nav.citylbl.text = "\(response.data?.search_params?.from_loc?.joined(separator: "-") ?? "")|\(response.data?.search_params?.to_loc?.joined(separator: "-") ?? "")"
            nav.datelbl.text = "\(response.data?.search_params?.depature?.joined(separator: ",") ?? "")"
            nav.travellerlbl.text = ""
            
            
            holderView.isHidden = false
            setuplabels(lbl: flightsFoundlbl, text: "\(response.data?.j_flight_list?.count ?? 0) Flights found", textcolor: .AppLabelColor, font: .OpenSansRegular(size: 12), align: .right)
            
            multicityFlights = response.data?.j_flight_list ?? []
            multicityFlights.forEach { j in
                
                prices.append(j.totalPrice ?? "")
                fareTypeA.append(j.fareType ?? "")
                j.flight_details?.summary?.forEach({ k in
                    
                    airlinesA.append(k.operator_name ?? "")
                    connectingFlightsA.append(k.destination?.loc ?? "")
                    connectingAirportA.append(k.operator_name ?? "")
                    
                    switch k.no_of_stops {
                    case 0:
                        noofStopsA.append("0 Stop")
                        break
                    case 1:
                        noofStopsA.append("1 Stop")
                        break
                    case 2:
                        noofStopsA.append("1+ Stop")
                        break
                    default:
                        break
                    }
                })
                
            }
            
            prices = Array(Set(prices))
            noofStopsA = Array(Set(noofStopsA))
            fareTypeA = Array(Set(fareTypeA))
            airlinesA = Array(Set(airlinesA.filter { isNonNullString($0) }))
            
            connectingFlightsA = Array(Set(connectingFlightsA))
            connectingAirportA = Array(Set(connectingAirportA))
            
            
            setupMulticityTVCells(jfl: response.data?.j_flight_list ?? [])
            
        }else {
            
            gotoNoInternetConnectionVC(key: "noresult", titleStr: "NO AVAILABILITY FOR THIS REQUEST")

        }
    }
    
    
    // Create a function to check if a string is not nil and not equal to "null"
    func isNonNullString(_ string: String?) -> Bool {
        if let nonNullString = string, nonNullString.lowercased() != "null" {
            return true
        }
        return false
    }
    
    
    //MARK: - oneway and roundtrip flightList
    func flightList(response: FlightListModel) {
        
        airlinesA.removeAll()
        
        
        if response.status == 1{
            
            view.backgroundColor = .WhiteColor
            loderBool = false
            searchid = "\(response.data?.search_id ?? 0)"
            bookingsource = response.data?.booking_source ?? ""
            bookingsourcekey = response.data?.booking_source_key ?? ""
            
            //   TimerManager.shared.totalTime = 20
            TimerManager.shared.totalTime = response.session_expiry_details?.session_start_time ?? 0
            TimerManager.shared.startTimer()
            
            
            holderView.isHidden = false
            setuplabels(lbl: flightsFoundlbl, text: "\(response.data?.j_flight_list?.count ?? 0) Flights found", textcolor: .AppLabelColor, font: .OpenSansRegular(size: 12), align: .right)
            
            
            
            
            
            oneWayFlights = response.data?.j_flight_list ?? [[]]
            oneWayFlights.forEach { i in
                i.forEach { j in
                    prices.append(j.totalPrice ?? "")
                    fareTypeA.append(j.fareType ?? "")
                    j.flight_details?.summary?.forEach({ k in
                        
                        airlinesA.append(k.operator_name ?? "")
                        connectingFlightsA.append(k.destination?.loc ?? "")
                        connectingAirportA.append(k.origin?.loc ?? "")
                        
                        switch k.no_of_stops {
                        case 0:
                            noofStopsA.append("0 Stop")
                            break
                        case 1:
                            noofStopsA.append("1 Stop")
                            break
                        case 2:
                            noofStopsA.append("1+ Stop")
                            break
                        default:
                            break
                        }
                    })
                }
            }
            
            prices = Array(Set(prices))
            noofStopsA = Array(Set(noofStopsA))
            fareTypeA = Array(Set(fareTypeA))
            airlinesA = Array(Set(airlinesA.compactMap { $0 }))
            connectingFlightsA = Array(Set(connectingFlightsA))
            connectingAirportA = Array(Set(connectingAirportA))
            
            
            let journyType = defaults.string(forKey: UserDefaultsKeys.journeyType)
            switch journyType {
                
            case "oneway":
                
                defaults.set("\(defaults.string(forKey: UserDefaultsKeys.fromcityname) ?? "") - \(defaults.string(forKey: UserDefaultsKeys.tocityname) ?? "")", forKey: UserDefaultsKeys.journeyCitys)
                defaults.set("\(convertDateFormat(inputDate: defaults.string(forKey: UserDefaultsKeys.calDepDate) ?? "", f1: "dd-MM-yyyy", f2: "EEE, d MMM"))", forKey: UserDefaultsKeys.journeyDates)
                
                nav.citylbl.text = defaults.string(forKey: UserDefaultsKeys.journeyCitys) ?? ""
                nav.datelbl.text = defaults.string(forKey: UserDefaultsKeys.journeyDates) ?? ""
                nav.travellerlbl.text = defaults.string(forKey: UserDefaultsKeys.travellerDetails)
                
                setupTVCells(jfl: response.data?.j_flight_list ?? [[]])
                break
                
            case "circle":
                
                defaults.set("\(defaults.string(forKey: UserDefaultsKeys.rfromcityname) ?? "") - \(defaults.string(forKey: UserDefaultsKeys.rtocityname) ?? "")", forKey: UserDefaultsKeys.journeyCitys)
                defaults.set("\(convertDateFormat(inputDate: defaults.string(forKey: UserDefaultsKeys.rcalDepDate) ?? "", f1: "dd-MM-yyyy", f2: "EEE, d MMM")) - \(convertDateFormat(inputDate: defaults.string(forKey: UserDefaultsKeys.rcalRetDate) ?? "", f1: "dd-MM-yyyy", f2: "EEE, d MMM"))", forKey: UserDefaultsKeys.journeyDates)
                
                nav.citylbl.text = defaults.string(forKey: UserDefaultsKeys.journeyCitys) ?? ""
                nav.datelbl.text = defaults.string(forKey: UserDefaultsKeys.journeyDates) ?? ""
                nav.travellerlbl.text = defaults.string(forKey: UserDefaultsKeys.rtravellerDetails)
                
                setupRoundTripTVCells(jfl: response.data?.j_flight_list ?? [[]])
                break
                
                
            default:
                break
            }
            
            
        }else {
            
            gotoNoInternetConnectionVC(key: "noresult", titleStr: "NO AVAILABILITY FOR THIS REQUEST")

        }
    }
    
    
    
    func setupTVCells(jfl:[[J_flight_list]]) {
        tablerow.removeAll()
        
        jfl.forEach { i in
            i.forEach { j in
                j.flight_details?.summary?.forEach({ k in
                    
                    
                    tablerow.append(TableRow(title:j.access_key,
                                             fromTime: k.origin?.time,
                                             toTime:k.destination?.time,
                                             fromCity: k.origin?.city,
                                             toCity: k.destination?.city,
                                             noosStops: "\(k.no_of_stops ?? 0) Stops",
                                             airlineslogo: k.operator_image,
                                             airlinesCode:"(\(k.operator_code ?? "")-\(k.operator_name ?? ""))",
                                             kwdprice:"\(j.sITECurrencyType ?? ""):\(j.totalPrice_API ?? "")",
                                             refundable:j.fareType,
                                             travelTime: k.duration,
                                             cellType:.SearchFlightResultInfoTVCell))
                    
                })
            }
        }
        
        tablerow.append(TableRow(height: 20,
                                 bgColor: .AppHolderViewColor,
                                 cellType:.EmptyTVCell))
        
        
        
        commonTVData = tablerow
        commonTableView.reloadData()
        
        
        if jfl.count == 0 {
            tablerow.removeAll()
            
            TableViewHelper.EmptyMessage(message: "No Data Found", tableview: commonTableView, vc: self)
            
            commonTVData = tablerow
            commonTableView.reloadData()
        }
        
    }
    
    func setupRoundTripTVCells(jfl:[[J_flight_list]]) {
        commonTableView.separatorStyle = .none
        
        tablerow.removeAll()
        
        jfl.forEach { i in
            i.forEach { j in
                tablerow.append(TableRow(title:j.access_key,
                                         kwdprice:"\(j.sITECurrencyType ?? ""):\(j.totalPrice_API ?? "")",
                                         refundable:j.fareType,
                                         key: "circle",
                                         moreData: j.flight_details?.summary,
                                         cellType:.RoundTripTVcell))
            }
        }
        
        tablerow.append(TableRow(height: 40,
                                 bgColor: .AppHolderViewColor,
                                 cellType:.EmptyTVCell))
        
        
        commonTVData = tablerow
        commonTableView.reloadData()
        
        
        if jfl.count == 0 {
            tablerow.removeAll()
            
            TableViewHelper.EmptyMessage(message: "No Data Found", tableview: commonTableView, vc: self)
            
            commonTVData = tablerow
            commonTableView.reloadData()
        }
    }
    
    
    
    func setupMulticityTVCells(jfl:[MJ_flight_list]) {
        commonTableView.separatorStyle = .none
        
        tablerow.removeAll()
        
        jfl.forEach { j in
            tablerow.append(TableRow(title:j.access_key,
                                     kwdprice:"\(j.sITECurrencyType ?? ""):\(j.totalPrice_API ?? "")",
                                     refundable:j.fareType,
                                     key: "multicity",
                                     moreData: j.flight_details?.summary,
                                     cellType:.RoundTripTVcell))
        }
        
        
        tablerow.append(TableRow(height: 40,
                                 bgColor: .AppHolderViewColor,
                                 cellType:.EmptyTVCell))
        
        
        commonTVData = tablerow
        commonTableView.reloadData()
        
        
        if jfl.count == 0 {
            tablerow.removeAll()
            
            TableViewHelper.EmptyMessage(message: "No Data Found", tableview: commonTableView, vc: self)
            
            commonTVData = tablerow
            commonTableView.reloadData()
        }
    }
    
    
    
    
}


extension SearchFlightResultVC:AppliedFilters {
    func hotelFilterByApplied(minpricerange: Double, maxpricerange: Double, starRating: String, refundableTypeArray: [String], nearByLocA: [String], niberhoodA: [String], aminitiesA: [String]) {
        
    }
    
   
    
    func filterByApplied(minpricerange: Double, maxpricerange: Double, noofstopsFA: [String], departureTimeFilter: [String], arrivalTimeFilter: [String], airlinesFA: [String], cancellationTypeFA: [String], connectingFlightsFA: [String], connectingAirportsFA: [String]) {
        
        
        print("====minpricerange ==== \(minpricerange)")
        print("====maxpricerange ==== \(maxpricerange)")
        print("==== noofstopsFA ==== \(noofstopsFA)")
        print("==== departureTimeFilter ==== \(departureTimeFilter)")
        print("==== arrivalTimeFilter ==== \(arrivalTimeFilter)")
        print("==== airlinesFA ==== \(airlinesFA)")
        print("==== cancellationTypeFA ==== \(cancellationTypeFA)")
        print("==== connectingFlightsFA ==== \(connectingFlightsFA)")
        print("==== connectingAirportsFA ==== \(connectingAirportsFA)")
        
        
        if let journyType = defaults.string(forKey: UserDefaultsKeys.journeyType) {
            
            let sortedArray = oneWayFlights.filter { flightList in
                
                
                // Calculate the total price for each flight in the flight list
                let totalPrice = flightList.reduce(0.0) { result, flight in
                    result + (Double(flight.totalPrice ?? "") ?? 0.0)
                }
                
                // Check if the flight list has at least one flight with the specified number of stops
                let noOfStopsMatch = noofstopsFA.isEmpty || flightList.contains(where: { $0.flight_details?.summary?.contains(where: { noofstopsFA.contains("\($0.no_of_stops ?? 0)") }) ?? false })
                
                // Check if the flight list has at least one flight with the specified airline
                let airlinesMatch = airlinesFA.isEmpty || flightList.contains(where: { $0.flight_details?.summary?.contains(where: { airlinesFA.contains($0.operator_name ?? "") }) ?? false })
                
                // Check if the flight list has at least one flight with the specified cancellation type
                let refundableMatch = cancellationTypeFA.isEmpty || flightList.contains(where: { $0.fareType == cancellationTypeFA.first })
                
                // Check if the flight list has at least one flight with the specified connecting flights
                let connectingFlightsMatch = connectingFlightsFA.isEmpty || flightList.contains(where: { $0.flight_details?.summary?.contains(where: { connectingFlightsFA.contains($0.destination?.loc ?? "") }) ?? false })
                
                // Check if the flight list has at least one flight with the specified connecting airports
                let connectingAirportsMatch = connectingAirportsFA.isEmpty || flightList.contains(where: { $0.flight_details?.summary?.contains(where: { $0.operator_name == connectingAirportsFA.first }) ?? false })
                
                
                
                // Check if the total price is within the specified range
                return totalPrice >= minpricerange && totalPrice <= maxpricerange && noOfStopsMatch && airlinesMatch && refundableMatch && connectingFlightsMatch && connectingAirportsMatch
            }
            
            
            if journyType == "oneway" {
                setupTVCells(jfl: sortedArray)
            }else {
                setupRoundTripTVCells(jfl: sortedArray)
            }
            
        }
        
        
        
        
        if let journeyType = defaults.string(forKey: UserDefaultsKeys.journeyType), journeyType == "multicity" {
            
            let totalPrice = multicityFlights.reduce(0.0) { result, flight in
                result + (Double(flight.totalPrice ?? "") ?? 0.0)
            }
            
            let sortedFlights = multicityFlights.filter { i in
                return totalPrice >= minpricerange && totalPrice <= maxpricerange
            }
            
            
            setupMulticityTVCells(jfl: sortedFlights)
        }
        
        
        
        
        
    }
    
    
    
    
    func filtersSortByApplied(sortBy: SortParameter) {
        
        
        switch sortBy {
        case .PriceLow:
            if let journyType = defaults.string(forKey: UserDefaultsKeys.journeyType) {
                if journyType == "oneway" {
                    
                    
                    let sortedFlights = oneWayFlights.sorted { (flights1, flights2) -> Bool in
                        let totalPrice1 = flights1.reduce(0) { $0 + (Double($1.totalPrice ?? "0") ?? 0) }
                        let totalPrice2 = flights2.reduce(0) { $0 + (Double($1.totalPrice ?? "0") ?? 0) }
                        return totalPrice1 < totalPrice2
                    }
                    
                    
                    setupTVCells(jfl: sortedFlights)
                    
                }else if journyType == "circle" {
                    let sortedFlights = oneWayFlights.sorted { (flights1, flights2) -> Bool in
                        let totalPrice1 = flights1.reduce(0) { $0 + (Double($1.totalPrice ?? "0") ?? 0) }
                        let totalPrice2 = flights2.reduce(0) { $0 + (Double($1.totalPrice ?? "0") ?? 0) }
                        return totalPrice1 < totalPrice2
                    }
                    
                    setupRoundTripTVCells(jfl: sortedFlights)
                    
                }else {
                    let sortedFlights = multicityFlights.sorted(by: {$0.totalPrice ?? "" < $1.totalPrice ?? ""})
                    
                    setupMulticityTVCells(jfl: sortedFlights)
                }
            }
            
            break
            
        case .PriceHigh:
            if let journyType = defaults.string(forKey: UserDefaultsKeys.journeyType) {
                if journyType == "oneway" {
                    
                    
                    let sortedFlights = oneWayFlights.sorted { (flights1, flights2) -> Bool in
                        let totalPrice1 = flights1.reduce(0) { $0 + (Double($1.totalPrice ?? "0") ?? 0) }
                        let totalPrice2 = flights2.reduce(0) { $0 + (Double($1.totalPrice ?? "0") ?? 0) }
                        return totalPrice1 > totalPrice2
                    }
                    
                    
                    setupTVCells(jfl: sortedFlights)
                    
                    
                    
                }else if journyType == "circle" {
                    
                    
                    let sortedFlights = oneWayFlights.sorted { (flights1, flights2) -> Bool in
                        let totalPrice1 = flights1.reduce(0) { $0 + (Double($1.totalPrice ?? "0") ?? 0) }
                        let totalPrice2 = flights2.reduce(0) { $0 + (Double($1.totalPrice ?? "0") ?? 0) }
                        return totalPrice1 > totalPrice2
                    }
                    
                    setupRoundTripTVCells(jfl: sortedFlights)
                    
                }else {
                    
                    let sortedFlights = multicityFlights.sorted(by: {$0.totalPrice ?? "" > $1.totalPrice ?? ""})
                    
                    setupMulticityTVCells(jfl: sortedFlights)
                    
                }
            }
            break
            
            
            
        case .DepartureLow:
            if let journyType = defaults.string(forKey: UserDefaultsKeys.journeyType) {
                if journyType == "oneway" {
                    
                    
                    
                    let sortedArray = oneWayFlights.sorted(by: { j1, j2 in
                        let time1 = j1.first?.flight_details?.summary?.first?.origin?.time ?? "0"
                        let time2 = j2.first?.flight_details?.summary?.first?.origin?.time ?? "0"
                        return time1 < time2
                    })
                    
                    setupTVCells(jfl: sortedArray)
                    
                }else if journyType == "circle" {
                    
                    
                    let sortedArray = oneWayFlights.sorted(by: { j1, j2 in
                        let time1 = j1.first?.flight_details?.summary?.first?.origin?.time ?? "0"
                        let time2 = j2.first?.flight_details?.summary?.first?.origin?.time ?? "0"
                        return time1 < time2
                    })
                    
                    setupRoundTripTVCells(jfl: sortedArray)
                    
                }else {
                    
                    
                    let sortedArray = multicityFlights.sorted(by: { j1, j2 in
                        let time1 = j1.flight_details?.summary?.first?.origin?.time ?? "0"
                        let time2 = j2.flight_details?.summary?.first?.origin?.time ?? "0"
                        return time1 < time2
                    })
                    
                    setupMulticityTVCells(jfl: sortedArray)
                    
                }
            }
            break
            
        case .DepartureHigh:
            if let journyType = defaults.string(forKey: UserDefaultsKeys.journeyType) {
                if journyType == "oneway" {
                    
                    
                    let sortedArray = oneWayFlights.sorted(by: { j1, j2 in
                        let time1 = j1.first?.flight_details?.summary?.first?.origin?.time ?? "0"
                        let time2 = j2.first?.flight_details?.summary?.first?.origin?.time ?? "0"
                        return time1 > time2
                    })
                    
                    setupTVCells(jfl: sortedArray)
                    
                }else if journyType == "circle"{
                    let sortedArray = oneWayFlights.sorted(by: { j1, j2 in
                        let time1 = j1.first?.flight_details?.summary?.first?.origin?.time ?? "0"
                        let time2 = j2.first?.flight_details?.summary?.first?.origin?.time ?? "0"
                        return time1 > time2
                    })
                    
                    setupRoundTripTVCells(jfl: sortedArray)
                    
                }else{
                    let sortedArray = multicityFlights.sorted(by: { j1, j2 in
                        let time1 = j1.flight_details?.summary?.first?.origin?.time ?? "0"
                        let time2 = j2.flight_details?.summary?.first?.origin?.time ?? "0"
                        return time1 > time2
                    })
                    
                    setupMulticityTVCells(jfl: sortedArray)
                    
                }
            }
            break
            
            
            
        case .ArrivalLow:
            if let journyType = defaults.string(forKey: UserDefaultsKeys.journeyType) {
                if journyType == "oneway" {
                    
                    let sortedArray = oneWayFlights.sorted(by: { j1, j2 in
                        let time1 = j1.first?.flight_details?.summary?.first?.destination?.time ?? "0"
                        let time2 = j2.first?.flight_details?.summary?.first?.destination?.time ?? "0"
                        return time1 < time2
                    })
                    
                    setupTVCells(jfl: sortedArray)
                    
                }else if journyType == "circle"{
                    let sortedArray = oneWayFlights.sorted(by: { j1, j2 in
                        let time1 = j1.first?.flight_details?.summary?.first?.destination?.time ?? "0"
                        let time2 = j2.first?.flight_details?.summary?.first?.destination?.time ?? "0"
                        return time1 < time2
                    })
                    
                    setupRoundTripTVCells(jfl: sortedArray)
                    
                }else {
                    let sortedArray = multicityFlights.sorted(by: { j1, j2 in
                        let time1 = j1.flight_details?.summary?.first?.destination?.time ?? "0"
                        let time2 = j2.flight_details?.summary?.first?.destination?.time ?? "0"
                        return time1 < time2
                    })
                    
                    setupMulticityTVCells(jfl: sortedArray)
                }
            }
            break
            
        case .ArrivalHigh:
            if let journyType = defaults.string(forKey: UserDefaultsKeys.journeyType) {
                if journyType == "oneway" {
                    
                    
                    let sortedArray = oneWayFlights.sorted(by: { j1, j2 in
                        let time1 = j1.first?.flight_details?.summary?.first?.destination?.time ?? "0"
                        let time2 = j2.first?.flight_details?.summary?.first?.destination?.time ?? "0"
                        return time1 > time2
                    })
                    
                    setupTVCells(jfl: sortedArray)
                    
                }else if journyType == "circle"{
                    let sortedArray = oneWayFlights.sorted(by: { j1, j2 in
                        let time1 = j1.first?.flight_details?.summary?.first?.destination?.time ?? "0"
                        let time2 = j2.first?.flight_details?.summary?.first?.destination?.time ?? "0"
                        return time1 > time2
                    })
                    
                    setupRoundTripTVCells(jfl: sortedArray)
                    
                }else {
                    let sortedArray = multicityFlights.sorted(by: { j1, j2 in
                        let time1 = j1.flight_details?.summary?.first?.destination?.time ?? "0"
                        let time2 = j2.flight_details?.summary?.first?.destination?.time ?? "0"
                        return time1 > time2
                    })
                    
                    setupMulticityTVCells(jfl: sortedArray)
                }
            }
            break
            
            
            
            
        case .DurationLow:
            if let journyType = defaults.string(forKey: UserDefaultsKeys.journeyType) {
                if journyType == "oneway" {
                    
                    
                    let sortedArray = oneWayFlights.sorted(by: { j1, j2 in
                        let durationseconds1 = j1.first?.flight_details?.summary?.first?.duration_seconds ?? 0
                        let durationseconds2 = j2.first?.flight_details?.summary?.first?.duration_seconds ?? 0
                        return durationseconds1 < durationseconds2
                    })
                    
                    setupTVCells(jfl: sortedArray)
                    
                }else if journyType == "circle"{
                    let sortedArray = oneWayFlights.sorted(by: { j1, j2 in
                        let durationseconds1 = j1.first?.flight_details?.summary?.first?.duration_seconds ?? 0
                        let durationseconds2 = j2.first?.flight_details?.summary?.first?.duration_seconds ?? 0
                        return durationseconds1 < durationseconds2
                    })
                    
                    setupRoundTripTVCells(jfl: sortedArray)
                    
                }else {
                    let sortedArray = multicityFlights.sorted(by: { j1, j2 in
                        let durationseconds1 = j1.flight_details?.summary?.first?.duration_seconds ?? 0
                        let durationseconds2 = j2.flight_details?.summary?.first?.duration_seconds ?? 0
                        return durationseconds1 < durationseconds2
                    })
                    
                    setupMulticityTVCells(jfl: sortedArray)
                    
                }
            }
            
            break
            
        case .DurationHigh:
            
            if let journyType = defaults.string(forKey: UserDefaultsKeys.journeyType) {
                if journyType == "oneway" {
                    
                    
                    let sortedArray = oneWayFlights.sorted(by: { j1, j2 in
                        let durationseconds1 = j1.first?.flight_details?.summary?.first?.duration_seconds ?? 0
                        let durationseconds2 = j2.first?.flight_details?.summary?.first?.duration_seconds ?? 0
                        return durationseconds1 > durationseconds2
                    })
                    
                    setupTVCells(jfl: sortedArray)
                    
                }else if journyType == "circle" {
                    let sortedArray = oneWayFlights.sorted(by: { j1, j2 in
                        let durationseconds1 = j1.first?.flight_details?.summary?.first?.duration_seconds ?? 0
                        let durationseconds2 = j2.first?.flight_details?.summary?.first?.duration_seconds ?? 0
                        return durationseconds1 > durationseconds2
                    })
                    
                    setupRoundTripTVCells(jfl: sortedArray)
                    
                }else {
                    let sortedArray = multicityFlights.sorted(by: { j1, j2 in
                        let durationseconds1 = j1.flight_details?.summary?.first?.duration_seconds ?? 0
                        let durationseconds2 = j2.flight_details?.summary?.first?.duration_seconds ?? 0
                        return durationseconds1 > durationseconds2
                    })
                    
                    setupMulticityTVCells(jfl: sortedArray)
                    
                }
            }
            break
            
            
        case .airlineaz:
            if let journyType = defaults.string(forKey: UserDefaultsKeys.journeyType) {
                if journyType == "oneway" {
                    
                    
                    let sortedArray = oneWayFlights.sorted(by: { j1, j2 in
                        let operatorCode1 = j1.first?.flight_details?.summary?.first?.operator_code ?? ""
                        let operatorCode2 = j2.first?.flight_details?.summary?.first?.operator_code ?? ""
                        return operatorCode1 < operatorCode2
                    })
                    
                    setupTVCells(jfl: sortedArray)
                    
                }else if journyType == "circle"{
                    let sortedArray = oneWayFlights.sorted(by: { j1, j2 in
                        let operatorCode1 = j1.first?.flight_details?.summary?.first?.operator_code ?? ""
                        let operatorCode2 = j2.first?.flight_details?.summary?.first?.operator_code ?? ""
                        return operatorCode1 < operatorCode2
                    })
                    
                    setupRoundTripTVCells(jfl: sortedArray)
                    
                }
            }else {
                let sortedArray = multicityFlights.sorted(by: { j1, j2 in
                    let operatorCode1 = j1.flight_details?.summary?.first?.operator_code ?? ""
                    let operatorCode2 = j2.flight_details?.summary?.first?.operator_code ?? ""
                    return operatorCode1 < operatorCode2
                })
                
                setupMulticityTVCells(jfl: sortedArray)
            }
            break
            
        case .airlineza:
            if let journyType = defaults.string(forKey: UserDefaultsKeys.journeyType) {
                if journyType == "oneway" {
                    
                    
                    let sortedArray = oneWayFlights.sorted(by: { j1, j2 in
                        let operatorCode1 = j1.first?.flight_details?.summary?.first?.operator_code ?? ""
                        let operatorCode2 = j2.first?.flight_details?.summary?.first?.operator_code ?? ""
                        return operatorCode1 > operatorCode2
                    })
                    
                    setupTVCells(jfl: sortedArray)
                    
                    
                }else if journyType == "circle"{
                    let sortedArray = oneWayFlights.sorted(by: { j1, j2 in
                        let operatorCode1 = j1.first?.flight_details?.summary?.first?.operator_code ?? ""
                        let operatorCode2 = j2.first?.flight_details?.summary?.first?.operator_code ?? ""
                        return operatorCode1 > operatorCode2
                    })
                    
                    setupRoundTripTVCells(jfl: sortedArray)
                    
                }else {
                    let sortedArray = multicityFlights.sorted(by: { j1, j2 in
                        let operatorCode1 = j1.flight_details?.summary?.first?.operator_code ?? ""
                        let operatorCode2 = j2.flight_details?.summary?.first?.operator_code ?? ""
                        return operatorCode1 > operatorCode2
                    })
                    
                    setupMulticityTVCells(jfl: sortedArray)
                }
            }
            break
            
            
        case .nothing:
            let journyType = defaults.string(forKey: UserDefaultsKeys.journeyType)
            if journyType == "oneway" {
                setupTVCells(jfl: oneWayFlights)
            }else if journyType == "circle"{
                setupRoundTripTVCells(jfl: oneWayFlights)
            }else {
                setupMulticityTVCells(jfl: multicityFlights)
            }
            break
            
        default:
            break
        }
        
        DispatchQueue.main.async {[self] in
            // commonTableView.scrollToRow(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
        }
        
    }
    
    
    
}





extension SearchFlightResultVC {
    
    func addObserver() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(nointernet), name: Notification.Name("offline"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: NSNotification.Name("reloadTV"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(resultnil), name: NSNotification.Name("resultnil"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTimer), name: NSNotification.Name("reloadTimer"), object: nil)
        
    }
    
    
    @objc func reloadTimer(){
        DispatchQueue.main.async {
            TimerManager.shared.delegate = self
        }
    }
    
    
    @objc func reload(){
        DispatchQueue.main.async {[self] in
            callAPI()
        }
    }
    
    @objc func nointernet(){
        gotoNoInternetConnectionVC(key: "nointernet", titleStr: "")
    }
    
    @objc func resultnil(){
        gotoNoInternetConnectionVC(key: "noresult", titleStr: "NO AVAILABILITY FOR THIS REQUEST")
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
        DispatchQueue.main.async {[self] in
            var totalTime = TimerManager.shared.totalTime
            let minutes =  totalTime / 60
            let seconds = totalTime % 60
            let formattedTime = String(format: "%02d:%02d", minutes, seconds)
            
            setuplabels(lbl: sessonlbl, text: "Your Session Expires In: \(formattedTime)",
                        textcolor: .AppLabelColor,
                        font: .OpenSansRegular(size: 12),
                        align: .left)
        }
    }
    
    
}
