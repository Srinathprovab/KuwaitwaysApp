//
//  HotelSearchResultVC.swift
//  BeeoonsApp
//
//  Created by MA673 on 22/08/22.
//

import UIKit

class HotelSearchResultVC: BaseTableVC,HotelListViewModelDelegate, TimerManagerDelegate {
    
    @IBOutlet weak var nav: NavBar!
    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var navHeight: NSLayoutConstraint!
    @IBOutlet weak var titlelbl: UILabel!
    @IBOutlet weak var subtitlelbl: UILabel!
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var mapImg: UIImageView!
    @IBOutlet weak var mapBtn: UIButton!
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var filterImg: UIImageView!
    @IBOutlet weak var filterpBtn: UIButton!
    
    
    
    var nationalityCode = String()
    var viewModel:HotelListViewModel?
    var payload = [String:Any]()
    var payload1 = [String:Any]()
    var hotelSearchResultArray = [HotelSearchResult]()
    var isVcFrom = String()
    var tablerow = [TableRow]()
    let refreshControl = UIRefreshControl()
    
    
    static var newInstance: HotelSearchResultVC? {
        let storyboard = UIStoryboard(name: Storyboard.Hotel.name,
                                      bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: self.className()) as? HotelSearchResultVC
        return vc
    }
    
    
    @objc func offline(notificatio:UNNotification) {
        callapibool = true
        guard let vc = NoInternetConnectionVC.newInstance.self else {return}
        vc.modalPresentationStyle = .fullScreen
        vc.key = "offline"
        self.present(vc, animated: false)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(offline), name: NSNotification.Name("offline"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(reload(notification:)), name: NSNotification.Name("reload"), object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(resultnil(notification:)), name: NSNotification.Name("resultnil"), object: nil)
        
        
        if callapibool == true {
            holderView.isHidden = true
            CallAPI()
        }
        
        
        
       
        TimerManager.shared.delegate = self
    }
    
    func timerDidFinish() {
        guard let vc = PopupVC.newInstance.self else {return}
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: false)
    }
    
    func updateTimer() {
        var totalTime = TimerManager.shared.totalTime
        let minutes =  totalTime / 60
        let seconds = totalTime % 60
        let formattedTime = String(format: "%02d:%02d", minutes, seconds)
        
        setuplabels(lbl: titlelbl, text: "Your Session Expires In: \(formattedTime)",
                    textcolor: .WhiteColor,
                    font: .OpenSansRegular(size: 12),
                    align: .left)
    }
  
    
    @objc func resultnil(notification: NSNotification){
        callapibool = true
        guard let vc = NoInternetConnectionVC.newInstance.self else {return}
        vc.modalPresentationStyle = .fullScreen
        vc.key = "noresult"
        self.present(vc, animated: false)
    }
    
    
    func CallAPI() {
        
        holderView.isHidden = true
        
        do {
            
            let arrJson = try JSONSerialization.data(withJSONObject: payload, options: JSONSerialization.WritingOptions.prettyPrinted)
            let theJSONText = NSString(data: arrJson, encoding: String.Encoding.utf8.rawValue)
            print(theJSONText ?? "")
            payload1["search_params"] = theJSONText
            viewModel?.CALL_GET_HOTEL_LIST_API(dictParam: payload1)
            
        }catch let error as NSError{
            print(error.description)
        }
        
    }
    
    
    func hotelList(response: HotelListModel) {
        
        if response.status == 1 {
            
            holderView.isHidden = false
            hbooking_source = response.booking_source ?? ""
            hsearch_id = String(response.search_id ?? 0)
            
            
            TimerManager.shared.totalTime = response.session_expiry_details?.session_start_time ?? 0
            TimerManager.shared.startTimer()
            
            
            
            hotelSearchResultArray = response.data?.hotelSearchResult ?? []
            setupLabels(lbl: subtitlelbl, text: "\(hotelSearchResultArray.count) Hotels Found", textcolor: .WhiteColor, font: .OpenSansRegular(size: 12))
            
            prices.removeAll()
            latitudeArray.removeAll()
            longitudeArray.removeAll()
            facilityArray.removeAll()
            hotelSearchResultArray.forEach { i in
                prices.append("\(i.xml_net ?? "")")
                latitudeArray.append(Double(i.latitude ?? "0.0") ?? 0.0)
                longitudeArray.append(Double(i.longitude ?? "0.0") ?? 0.0)
                i.facility?.forEach({ j in
                    facilityArray.append(j)
                })
            }
            prices = Array(Set(prices))
            facilityArray = Array(Set(facilityArray))
            
            DispatchQueue.main.async {
                self.setupTVCells(hotelList: self.hotelSearchResultArray)
            }
            
        }else {
            
            
            callapibool = true
            guard let vc = NoInternetConnectionVC.newInstance.self else {return}
            vc.modalPresentationStyle = .fullScreen
            vc.key = "noresult"
            self.present(vc, animated: false)
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
        viewModel = HotelListViewModel(self)
    }
    
    func setupUI() {
        
        self.holderView.backgroundColor = .AppHolderViewColor
        nav.titlelbl.text = "Search Result"
        nav.backBtn.addTarget(self, action: #selector(backbtnAction(_:)), for: .touchUpInside)
        nav.citylbl.isHidden = false
        nav.datelbl.isHidden = false
        nav.travellerlbl.isHidden = false
        nav.editView.isHidden = false
        nav.editBtn.addTarget(self, action: #selector(modifySearchHotel(_:)), for: .touchUpInside)
        nav.citylbl.text = "\(defaults.string(forKey: UserDefaultsKeys.locationcity) ?? "")"
        nav.datelbl.text = "CheckIn - \(convertDateFormat(inputDate: defaults.string(forKey: UserDefaultsKeys.checkin) ?? "" , f1: "dd-MM-yyyy", f2: "dd MMM")) & CheckOut - \(convertDateFormat(inputDate: defaults.string(forKey: UserDefaultsKeys.checkout) ?? "", f1: "dd-MM-yyyy", f2: "dd MMM"))"
        nav.travellerlbl.text = "Guests- \(defaults.string(forKey: UserDefaultsKeys.guestcount) ?? "1") / Room - \(defaults.string(forKey: UserDefaultsKeys.roomcount) ?? "")"
        
        
        if screenHeight > 835 {
            navHeight.constant = 190
        }else {
            navHeight.constant = 160
        }
        
        //  setupLabels(lbl: titlelbl, text: "Your Session Expires In: 14:15", textcolor: .WhiteColor, font: .OpenSansRegular(size: 12))
        
        
        setupViews(v: mapView, radius: 4, color: .AppJournyTabSelectColor)
        setupViews(v: filterView, radius: 4, color: .AppNavBackColor)
        mapImg.image = UIImage(named: "loc")
        filterImg.image = UIImage(named: "filter")
        mapBtn.setTitle("", for: .normal)
        filterpBtn.setTitle("", for: .normal)
        mapBtn.addTarget(self, action: #selector(didTapOnMapviewBtn(_:)), for: .touchUpInside)
        filterpBtn.addTarget(self, action: #selector(didTapOnFilterwBtn(_:)), for: .touchUpInside)
        
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        commonTableView.refreshControl = refreshControl
        
        commonTableView.registerTVCells(["EmptyTVCell",
                                         "HotelSearchResultTVCell"])
        
        
        
    }
    
    @objc func handleRefresh() {
        // Perform data fetching or reloading here
        let seconds = 2.0
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {[self] in
            // Put your code which should be executed with a delay here
            setupTVCells(hotelList: hotelSearchResultArray)
            commonTableView.refreshControl?.endRefreshing()
        }
    }
    
    
    
    @objc func reload(notification: NSNotification){
        commonTableView.reloadData()
    }
    
    
    func setupLabels(lbl:UILabel,text:String,textcolor:UIColor,font:UIFont) {
        lbl.text = text
        lbl.textColor = textcolor
        lbl.font = font
    }
    
    func setupViews(v:UIView,radius:CGFloat,color:UIColor) {
        v.backgroundColor = color
        v.layer.cornerRadius = radius
        v.clipsToBounds = true
        v.layer.borderWidth = 0.2
        v.layer.borderColor = UIColor.AppBorderColor.cgColor
    }
    
    @objc func modifySearchHotel(_ sender:UIButton) {
        guard let vc = ModifyHotelSearchVC.newInstance.self else {return}
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: false)
    }
    
    
    @objc func backbtnAction(_ sender:UIButton) {
        TimerManager.shared.sessionStop()
        guard let vc = BookHotelVC.newInstance.self else {return}
        vc.modalPresentationStyle = .fullScreen
        callapibool = false
        self.present(vc, animated: false)
    }
    
    @objc func didTapOnMapviewBtn(_ sender:UIButton) {
        guard let vc = MapViewVC.newInstance.self else {return}
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false)
    }
    
    @objc func didTapOnFilterwBtn(_ sender:UIButton) {
        guard let vc = FilterSearchVC.newInstance.self else {return}
        vc.modalPresentationStyle = .overCurrentContext
        vc.delegate = self
        self.present(vc, animated: false)
    }
    
    
    override func didTapOnDetailsBtn(cell: HotelSearchResultTVCell) {
        guard let vc = SelectedHotelInfoVC.newInstance.self else {return}
        vc.modalPresentationStyle = .fullScreen
        hotelid = cell.hotelid
        grandTotal = cell.kwdlbl.text ?? ""
        defaults.set(cell.kwdlbl.text, forKey: UserDefaultsKeys.kwdprice)
        callapibool = true
        self.present(vc, animated: false)
    }
    
}


extension HotelSearchResultVC:AppliedFilters {
    
    
    func filtersSortByApplied(sortBy: SortParameter) {
        
    }
    
    func filterByApplied(minpricerange: Double, maxpricerange: Double, noofstopsFA: [String], departureTimeFilter: [String], arrivalTimeFilter: [String], airlinesFA: [String], cancellationTypeFA: [String], connectingFlightsFA: [String], connectingAirportsFA: [String]) {
        
    }
    
    func hotelFilterByApplied(minpricerange: Double, maxpricerange: Double, starRating: String) {
        
        print("====minpricerange ==== \(minpricerange)")
        print("====maxpricerange ==== \(maxpricerange)")
        print(" ==== starRating === \n\(starRating)")
        
        let filteredArray = hotelSearchResultArray.filter { i in
            guard let netPrice = Double(i.xml_net ?? "0.0") else { return false }
            let ratingMatches = i.star_rating == Int(starRating) || starRating.isEmpty
            return ratingMatches &&
            netPrice >= minpricerange &&
            netPrice <= maxpricerange
        }
        
        
        setupTVCells(hotelList: filteredArray)
    }
    
    
    
    
    
    func setupTVCells(hotelList:[HotelSearchResult]) {
        
        
        if hotelList.count == 0 {
            tablerow.removeAll()
            TableViewHelper.EmptyMessage(message: "No Data Found", tableview: commonTableView, vc: self)
            commonTVData = tablerow
            commonTableView.reloadData()
        }else {
            tablerow.removeAll()
            
            hotelList.forEach { i in
                tablerow.append(TableRow(title:i.name,
                                         subTitle: "\(i.address ?? "")",
                                         kwdprice: "\(i.currency ?? "") \(i.xml_net ?? "")",
                                         text: "\(i.hotel_code ?? 0)",
                                         image: i.image,
                                         characterLimit: i.star_rating,
                                         cellType:.HotelSearchResultTVCell))
                
            }
            
            tablerow.append(TableRow(height:50,
                                     bgColor: .AppHolderViewColor,
                                     cellType:.EmptyTVCell))
            
            commonTVData = tablerow
            commonTableView.reloadData()
        }
        
        
        
        
    }
    
    
}
