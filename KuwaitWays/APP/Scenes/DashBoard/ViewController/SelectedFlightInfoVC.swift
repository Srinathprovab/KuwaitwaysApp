//
//  SelectedFlightInfoVC.swift
//  BeeoonsApp
//
//  Created by MA673 on 18/08/22.
//

import UIKit

class SelectedFlightInfoVC: BaseTableVC, FlightDetailsViewModelDelegate {
    
    
    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var nav: NavBar!
    @IBOutlet weak var navHeight: NSLayoutConstraint!
    @IBOutlet weak var cvHolderView: UIView!
    @IBOutlet weak var itineraryCV: UICollectionView!
    @IBOutlet weak var bookNowHolderView: UIView!
    @IBOutlet weak var titlelbl: UILabel!
    @IBOutlet weak var bookNowView: UIView!
    @IBOutlet weak var bookNowlbl: UILabel!
    @IBOutlet weak var bookNowBtn: UIButton!
    
    static var newInstance: SelectedFlightInfoVC? {
        let storyboard = UIStoryboard(name: Storyboard.Main.name,
                                      bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: self.className()) as? SelectedFlightInfoVC
        return vc
    }
    var isVcFrom = String()
    var itineraryArray = ["Itinerary","Fare Breakdown","Fare Rules","Baggage Info"]
    var city = String()
    var date = String()
    var traveller = String()
    var tablerow = [TableRow]()
    var cellIndex = Int()
    let refreshControl = UIRefreshControl()
    var farepricedetails:PriceDetails?
    var jm = [JourneySummary]()
    var adultsCount = Int()
    var childCount = Int()
    var infantsCount = Int()
    var fareRulesData = [FareRulehtml]()
    var payload = [String:Any]()
    var vm:FlightDetailsViewModel?
    override func viewWillAppear(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(offline), name: NSNotification.Name("offline"), object: nil)

        
        if let journeyType = defaults.string(forKey: UserDefaultsKeys.journeyType) {
            if journeyType == "oneway" {
                adultsCount = Int(defaults.string(forKey: UserDefaultsKeys.adultCount) ?? "1") ?? 0
                childCount = Int(defaults.string(forKey: UserDefaultsKeys.childCount) ?? "0") ?? 0
                infantsCount = Int(defaults.string(forKey: UserDefaultsKeys.infantsCount) ?? "0") ?? 0
                
                
            }else if journeyType == "circle"{
                adultsCount = Int(defaults.string(forKey: UserDefaultsKeys.radultCount) ?? "1") ?? 0
                childCount = Int(defaults.string(forKey: UserDefaultsKeys.rchildCount) ?? "0") ?? 0
                infantsCount = Int(defaults.string(forKey: UserDefaultsKeys.rinfantsCount) ?? "0") ?? 0
            }else {
                
                adultsCount = Int(defaults.string(forKey: UserDefaultsKeys.madultCount) ?? "1") ?? 0
                childCount = Int(defaults.string(forKey: UserDefaultsKeys.mchildCount) ?? "0") ?? 0
                infantsCount = Int(defaults.string(forKey: UserDefaultsKeys.minfantsCount) ?? "0") ?? 0
            }
        }
        
        
        if  callapibool == true {
            DispatchQueue.main.async {[self] in
                holderView.isHidden = true
                callAPI()
            }
        }
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(stopTimer), name: NSNotification.Name("sessionStop"), object: nil)
    }
    
    @objc func stopTimer() {
        guard let vc = PopupVC.newInstance.self else {return}
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: false)
    }
    
    @objc func offline(notificatio:UNNotification) {
        callapibool = true
        guard let vc = NoInternetConnectionVC.newInstance.self else {return}
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false)
    }
    
 
    
    
    func callAPI() {
        payload.removeAll()
        payload["user_id"] = defaults.string(forKey: UserDefaultsKeys.userid) ?? "0"
        let journyType = defaults.string(forKey: UserDefaultsKeys.journeyType)
        if journyType == "multicity" {
            payload["booking_source"] = bookingsource
        }else {
            payload["booking_source"] = bookingsource
        }
        payload["access_key"] = accesskey
        payload["search_id"] = searchid
        vm?.CALL_GET_FLIGHT_DETAILS_API(dictParam: payload)
    }
    
    
    
    func flightDetails(response: FlightDetailsModel) {
        
        
        holderView.isHidden = false
        grandTotal = "\(response.priceDetails?.api_currency ?? ""):\(response.priceDetails?.grand_total ?? "")"
        jm = response.journeySummary ?? []
        fd = response.flightDetails ?? [[]]
        fareRulesData = response.fareRulehtml ?? []
        farepricedetails = response.priceDetails
        baggageAllowance1 = response.baggageAllowance ?? []
        
        Adults_Base_Price = String(response.priceDetails?.adultsBasePrice ?? "0")
        Adults_Tax_Price = String(response.priceDetails?.adultsTaxPrice ?? "0")
        Childs_Base_Price = String(response.priceDetails?.childBasePrice ?? "0")
        Childs_Tax_Price = String(response.priceDetails?.childTaxPrice ?? "0")
        Infants_Base_Price = String(response.priceDetails?.infantBasePrice ?? "0")
        Infants_Tax_Price = String(response.priceDetails?.infantTaxPrice ?? "0")
        AdultsTotalPrice = String(response.priceDetails?.adultsTotalPrice ?? "0")
        ChildTotalPrice = String(response.priceDetails?.childTotalPrice ?? "0")
        InfantTotalPrice = String(response.priceDetails?.infantTotalPrice ?? "0")
        sub_total_adult = String(response.priceDetails?.sub_total_adult ?? "0")
        sub_total_child = String(response.priceDetails?.sub_total_child ?? "0")
        sub_total_infant = String(response.priceDetails?.sub_total_infant ?? "0")
        
        DispatchQueue.main.async {[self] in
            setupUI()
        }
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .WhiteColor
        
        vm = FlightDetailsViewModel(self)
    }
    
    
    func setupUI() {
        holderView.backgroundColor = .AppHolderViewColor
        cvHolderView.backgroundColor = .AppNavBackColor
        commonTableView.backgroundColor = .AppHolderViewColor
        
        setupCV()
        
        if screenHeight > 835 {
            navHeight.constant = 180
        }else {
            navHeight.constant = 140
        }
        
        
        nav.titlelbl.text = ""
        nav.backBtn.addTarget(self, action: #selector(gotoBackScreen), for: .touchUpInside)
        nav.citylbl.isHidden = false
        nav.datelbl.isHidden = false
        nav.travellerlbl.isHidden = false
        nav.citylbl.text = defaults.string(forKey: UserDefaultsKeys.journeyCitys) ?? ""
        nav.datelbl.text = defaults.string(forKey: UserDefaultsKeys.journeyDates) ?? ""
        let jt = defaults.string(forKey: UserDefaultsKeys.journeyType)
        if jt == "oneway" {
            nav.travellerlbl.text = defaults.string(forKey: UserDefaultsKeys.travellerDetails) ?? ""
        }else if jt == "circle" {
            nav.travellerlbl.text = defaults.string(forKey: UserDefaultsKeys.rtravellerDetails) ?? ""
        }else {
            nav.travellerlbl.text = defaults.string(forKey: UserDefaultsKeys.mtravellerDetails) ?? ""
        }
        
        cellIndex = Int(defaults.string(forKey: UserDefaultsKeys.itinerarySelectedIndex) ?? "0") ?? 0
        print("cellIndex \(cellIndex)")
        itineraryCV.selectItem(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: .left)
        
        
        
        
        setupViews(v: bookNowHolderView, radius: 0, color: .AppJournyTabSelectColor)
        setupViews(v: bookNowView, radius: 6, color: .AppNavBackColor)
        setupLabels(lbl: titlelbl, text: grandTotal, textcolor: .WhiteColor, font: .oswaldRegular(size: 20))
        setupLabels(lbl: bookNowlbl, text: "BOOK NOW", textcolor: .WhiteColor, font: .oswaldRegular(size: 16))
        bookNowBtn.setTitle("", for: .normal)
        
        commonTableView.registerTVCells(["AddItineraryTVCell",
                                         "BookNowTVCell",
                                         "EmptyTVCell",
                                         "TitleLblTVCell",
                                         "FareBreakdownTVCell",
                                         "BaggageInfoTVCell",
                                         "FareRulesTVCell",
                                         "RadioButtonTVCell"])
        
        
        
        setupItineraryTVCells()
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
    
    func setupCV() {
        let nib = UINib(nibName: "ItineraryCVCell", bundle: nil)
        itineraryCV.register(nib, forCellWithReuseIdentifier: "cell")
        itineraryCV.delegate = self
        itineraryCV.dataSource = self
        let layout = UICollectionViewFlowLayout()
        // layout.itemSize = CGSize(width: 100, height: 40)
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        itineraryCV.collectionViewLayout = layout
        itineraryCV.backgroundColor = .clear
        itineraryCV.layer.cornerRadius = 4
        itineraryCV.clipsToBounds = true
        itineraryCV.showsHorizontalScrollIndicator = false
        
        
    }
    
    @objc func gotoBackScreen() {
        callapibool = false
        dismiss(animated: true)
    }
    
    func setupItineraryTVCells() {
        tablerow.removeAll()
        
        fd.forEach { i in
            tablerow.append(TableRow(moreData:i,cellType:.AddItineraryTVCell))
        }
        
        
        commonTVData = tablerow
        commonTableView.reloadData()
    }
    
    
    @IBAction func didTapOnBookNowBtn(_ sender: Any) {
        guard let vc = ContactInfoVC.newInstance.self else {return}
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true)
    }
    
    
    
    func setupFareBreakdownTVCells() {
        
        tablerow.removeAll()
        
        
        
        if adultsCount > 0 && childCount == 0 && infantsCount == 0 {
            tablerow.append(TableRow(title:"Adult",
                                     subTitle: "X\(String(adultsCount))",
                                     key:farepricedetails?.api_currency,
                                     text: farepricedetails?.adultsBasePrice,
                                     headerText: farepricedetails?.sub_total_adult,
                                     buttonTitle:farepricedetails?.adultsTotalPrice,
                                     errormsg:farepricedetails?.adultsTotalPrice,
                                     key1:farepricedetails?.grand_total,
                                     tempText: farepricedetails?.adultsTaxPrice,
                                     cellType:.FareBreakdownTVCell))
            
        }else if adultsCount > 0 && childCount > 0 && infantsCount == 0 {
            tablerow.append(TableRow(title:"Adult",
                                     subTitle: "X\(String(adultsCount))",
                                     key:farepricedetails?.api_currency,
                                     text: farepricedetails?.adultsBasePrice,
                                     headerText: farepricedetails?.sub_total_adult,
                                     buttonTitle:farepricedetails?.adultsTotalPrice,
                                     errormsg:farepricedetails?.adultsTotalPrice,
                                     key1:farepricedetails?.grand_total,
                                     tempText: farepricedetails?.adultsTaxPrice,
                                     cellType:.FareBreakdownTVCell))
            
            tablerow.append(TableRow(title:"Child",
                                     subTitle: "X\(String(childCount))",
                                     key:farepricedetails?.api_currency,
                                     text: farepricedetails?.childBasePrice,
                                     headerText: farepricedetails?.sub_total_child,
                                     buttonTitle:farepricedetails?.childTotalPrice,
                                     key1:farepricedetails?.grand_total,
                                     tempText: farepricedetails?.childTaxPrice,
                                     cellType:.FareBreakdownTVCell))
            
        }else if adultsCount > 0 && childCount == 0 && infantsCount > 0 {
            tablerow.append(TableRow(title:"Adult",
                                     subTitle: "X\(String(adultsCount))",
                                     key:farepricedetails?.api_currency,
                                     text: farepricedetails?.adultsBasePrice,
                                     headerText: farepricedetails?.sub_total_adult,
                                     buttonTitle:farepricedetails?.adultsTotalPrice,
                                     key1:farepricedetails?.grand_total,
                                     tempText: farepricedetails?.adultsTaxPrice,
                                     cellType:.FareBreakdownTVCell))
            
            tablerow.append(TableRow(title:"Infanta",
                                     subTitle: "X\(String(infantsCount))",
                                     key:farepricedetails?.api_currency,
                                     text: farepricedetails?.infantBasePrice,
                                     headerText: farepricedetails?.sub_total_infant,
                                     buttonTitle:farepricedetails?.infantTotalPrice,
                                     key1:farepricedetails?.grand_total,
                                     tempText: farepricedetails?.infantTaxPrice,
                                     cellType:.FareBreakdownTVCell))
        }else {
            tablerow.append(TableRow(title:"Adult",
                                     subTitle: "X\(String(adultsCount))",
                                     key:farepricedetails?.api_currency,
                                     text: farepricedetails?.adultsBasePrice,
                                     headerText: farepricedetails?.sub_total_adult,
                                     buttonTitle:farepricedetails?.adultsTotalPrice,
                                     key1:farepricedetails?.grand_total,
                                     tempText: farepricedetails?.adultsTaxPrice,
                                     cellType:.FareBreakdownTVCell))
            
            tablerow.append(TableRow(title:"Child",
                                     subTitle: "X\(String(childCount))",
                                     key:farepricedetails?.api_currency,
                                     text: farepricedetails?.childBasePrice,
                                     headerText: farepricedetails?.sub_total_child,
                                     buttonTitle:farepricedetails?.childTotalPrice,
                                     errormsg:farepricedetails?.childTotalPrice,
                                     key1:farepricedetails?.grand_total,
                                     tempText: farepricedetails?.childTaxPrice,
                                     cellType:.FareBreakdownTVCell))
            
            tablerow.append(TableRow(title:"Infanta",
                                     subTitle: "X\(String(infantsCount))",
                                     key:farepricedetails?.api_currency,
                                     text: farepricedetails?.infantBasePrice,
                                     headerText: farepricedetails?.sub_total_infant,
                                     buttonTitle:farepricedetails?.infantTotalPrice,
                                     key1:farepricedetails?.grand_total,
                                     tempText: farepricedetails?.infantTaxPrice,
                                     cellType:.FareBreakdownTVCell))
        }
        
        
        tablerow.append(TableRow(title:"Total Trip Cost",subTitle: farepricedetails?.grand_total,key: "totalcost",cellType:.TitleLblTVCell))
        tablerow.append(TableRow(height:50,bgColor: .AppHolderViewColor,cellType:.EmptyTVCell))
        
        
        commonTVData = tablerow
        commonTableView.reloadData()
    }
    
    
    func setupFareRulesTVCells() {
        self.commonTableView.estimatedRowHeight = 500
        self.commonTableView.rowHeight = 40
        
        tablerow.removeAll()
        
        if fareRulesData.count == 0 {
            TableViewHelper.EmptyMessage(message: "No Data Found", tableview: commonTableView, vc: self)
        }else {
            TableViewHelper.EmptyMessage(message: "", tableview: commonTableView, vc: self)

            self.fareRulesData.forEach { i in
                tablerow.append(TableRow(title:i.rule_heading,subTitle: i.rule_content?.htmlToString,cellType:.FareRulesTVCell))
            }
        }
        
       
        
        commonTVData = tablerow
        commonTableView.reloadData()
        
    }
    
    
    func setupBaggageInfoTVCells() {
        tablerow.removeAll()
        
        tablerow.append(TableRow(title:"Baggage Information",subTitle: "",key: "baggage",cellType:.TitleLblTVCell))
        
        baggageAllowance1.forEach { i in
            tablerow.append(TableRow(title:i.journeySummary,
                                     subTitle: i.cabin_baggage ?? "",
                                     text: i.aDT ?? "",
                                     key1: i.cNN ?? "",
                                     tempText: i.iNF ?? "",
                                     cellType:.BaggageInfoTVCell))
        }
        
        
        
        commonTVData = tablerow
        commonTableView.reloadData()
    }
    
}



extension SelectedFlightInfoVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itineraryArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var commonCell = UICollectionViewCell()
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? ItineraryCVCell {
            cell.titlelbl.text = itineraryArray[indexPath.row]
            if indexPath.row == 0 {
                cell.holderView.backgroundColor = .WhiteColor
                cell.titlelbl.textColor = .AppLabelColor
            }
            commonCell = cell
        }
        return commonCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? ItineraryCVCell {
            cell.holderView.backgroundColor = .WhiteColor
            cell.titlelbl.textColor = .AppLabelColor
            defaults.set(indexPath.row, forKey: UserDefaultsKeys.itinerarySelectedIndex)
            TableViewHelper.EmptyMessage(message: "", tableview: commonTableView, vc: self)
            
            switch cell.titlelbl.text {
            case "Itinerary":
                setupItineraryTVCells()
                break
                
            case "Fare Breakdown":
                setupFareBreakdownTVCells()
                break
                
            case "Fare Rules":
                setupFareRulesTVCells()
                break
                
            case "Baggage Info":
                setupBaggageInfoTVCells()
                break
                
            default:
                break
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? ItineraryCVCell {
            cell.holderView.backgroundColor = .WhiteColor.withAlphaComponent(0.50)
            cell.titlelbl.textColor = .WhiteColor
        }
    }
    
    //MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: itineraryArray[indexPath.item].size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17)]).width + 25, height: 40)
    }
    
}

extension SelectedFlightInfoVC {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? FareRulesTVCell {
            if cell.showBool == true {
                cell.show()
                cell.showBool = false
            }else {
                cell.hide()
                cell.showBool = true
            }
        }
        
        commonTableView.beginUpdates()
        commonTableView.endUpdates()
    }
    
    
    //    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    //        if let cell = tableView.cellForRow(at: indexPath) as? FareRulesTVCell {
    //            cell.hide()
    //        }
    //
    //    }
}
