//
//  BookHotelVC.swift
//  BeeoonsApp
//
//  Created by MA673 on 22/08/22.
//

import UIKit

class BookHotelVC: BaseTableVC {
    
    
    @IBOutlet weak var nav: NavBar!
    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var navHeight: NSLayoutConstraint!
    
    
    var nationalityCode = String()
    var isVcFrom = String()
    var tablerow = [TableRow]()
    var payload = [String:Any]()
    
    static var newInstance: BookHotelVC? {
        let storyboard = UIStoryboard(name: Storyboard.Hotel.name,
                                      bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: self.className()) as? BookHotelVC
        return vc
    }
    
    
    
    @objc func offline(notificatio:UNNotification) {
        callapibool = true
        guard let vc = NoInternetConnectionVC.newInstance.self else {return}
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(offline), name: NSNotification.Name("offline"), object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(reload(notification:)), name: NSNotification.Name("reload"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(nationalityCode(notification:)), name: NSNotification.Name("nationalityCode"), object: nil)
        
    }
    
    @objc func nationalityCode(notification: NSNotification){
        nationalityCode = notification.object as? String ?? ""
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(reload(notification:)), name: NSNotification.Name("reload"), object: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
        setInitalValues()
    }
    
    func setupUI() {
        self.view.backgroundColor = .WhiteColor
        nav.titlelbl.text = "Book Hotel"
        nav.backBtn.addTarget(self, action: #selector(backbtnAction(_:)), for: .touchUpInside)
        
        if screenHeight > 835 {
            navHeight.constant = 130
        }else {
            navHeight.constant = 100
        }
        
        self.view.backgroundColor = .WhiteColor
        
        commonTableView.registerTVCells(["EmptyTVCell",
                                         "SearchFlightTVCell",
                                         "LabelTVCell",
                                         "HotelDealsTVCell"])
        
        
        
        appendHotelSearctTvcells(str: "hotel")
        
        
    }
    
    
    func setInitalValues() {
        
        adtArray.removeAll()
        chArray.removeAll()
        
        adtArray.append("2")
        chArray.append("0")
        
        defaults.set("1", forKey: UserDefaultsKeys.roomcount)
        defaults.set("2", forKey: UserDefaultsKeys.hoteladultscount)
        defaults.set("0", forKey: UserDefaultsKeys.hotelchildcount)
        
        defaults.set("Rooms \(defaults.string(forKey: UserDefaultsKeys.roomcount) ?? ""),Adults \(defaults.string(forKey: UserDefaultsKeys.hoteladultscount) ?? "")", forKey: UserDefaultsKeys.selectPersons)
        
    }
    
    @objc func reload(notification: NSNotification){
        commonTableView.reloadData()
    }
    
    func appendHotelSearctTvcells(str:String) {
        tablerow.removeAll()
        
        tablerow.append(TableRow(key:"hotel",cellType:.SearchFlightTVCell))
        tablerow.append(TableRow(height:10,bgColor: .AppHolderViewColor,cellType:.EmptyTVCell))
        tablerow.append(TableRow(title:"Hotel ",subTitle: "Deals from your favorite booking sites, All in one place.",key: "deals",cellType:.LabelTVCell))
        tablerow.append(TableRow(key1:"hotel",cellType:.HotelDealsTVCell))
        tablerow.append(TableRow(height:100,bgColor: .AppHolderViewColor,cellType:.EmptyTVCell))
        
        commonTVData = tablerow
        commonTableView.reloadData()
        
    }
    
    @objc func backbtnAction(_ sender:UIButton) {
        guard let vc = DBTabbarController.newInstance.self else {return}
        vc.modalPresentationStyle = .fullScreen
        vc.selectedIndex = 0
        callapibool = true
        self.present(vc, animated: false)
    }
    
    
    override func didTapOnLocationOrCityBtn(cell:HolderViewTVCell){
        guard let vc = SelectFromCityVC.newInstance.self else {return}
        vc.modalPresentationStyle = .fullScreen
        vc.titleStr = "Location/City"
        vc.keyStr = "hotel"
        self.present(vc, animated: true)
    }
    override func didtapOnCheckInBtn(cell:DualViewTVCell){
        guard let vc = CalenderVC.newInstance.self else {return}
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true)
    }
    override func didtapOnCheckOutBtn(cell:DualViewTVCell){
        guard let vc = CalenderVC.newInstance.self else {return}
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    override func didTapOnAddRooms(cell:HolderViewTVCell){
        guard let vc = AddRoomsVCViewController.newInstance.self else {return}
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true)
    }
    
    
    override func didTapOnSearchHotelsBtn(cell:ButtonTVCell){
        
        payload.removeAll()
        payload["city"] = defaults.string(forKey: UserDefaultsKeys.locationcity)
        payload["hotel_destination"] = defaults.string(forKey: UserDefaultsKeys.locationid)
        payload["hotel_checkin"] = defaults.string(forKey: UserDefaultsKeys.checkin)
        payload["hotel_checkout"] = defaults.string(forKey: UserDefaultsKeys.checkout)
        
        payload["rooms"] = "\(defaults.string(forKey: UserDefaultsKeys.roomcount) ?? "1")"
        payload["adult"] = adtArray
        payload["child"] = chArray
        
        for roomIndex in 0..<totalRooms {
            
            
            if let numChildren = Int(chArray[roomIndex]), numChildren > 0 {
                var childAges: [String] = Array(repeating: "0", count: numChildren)
                
                if numChildren > 2 {
                    childAges.append("0")
                }
                
                payload["childAge_\(roomIndex + 1)"] = childAges
            }
        }
        
        
        payload["nationality"] = nationalityCode
        payload["language"] = "english"
        payload["search_source"] = "postman"
        payload["currency"] = defaults.string(forKey: UserDefaultsKeys.selectedCurrency) ?? "KWD"
        payload["user_id"] = defaults.string(forKey: UserDefaultsKeys.userid) ?? "0"
        
        if defaults.string(forKey: UserDefaultsKeys.locationcity) == "Add City" || defaults.string(forKey: UserDefaultsKeys.locationcity) == nil{
            showToast(message: "Enter Hotel or City ")
        }else if defaults.string(forKey: UserDefaultsKeys.checkin) == "Add Check In Date" || defaults.string(forKey: UserDefaultsKeys.checkin) == nil{
            showToast(message: "Enter Checkin Date")
        }else if defaults.string(forKey: UserDefaultsKeys.checkout) == "Add Check Out Date" || defaults.string(forKey: UserDefaultsKeys.checkout) == nil{
            showToast(message: "Enter Checkout Date")
        }else if defaults.string(forKey: UserDefaultsKeys.checkout) == defaults.string(forKey: UserDefaultsKeys.checkin) {
            showToast(message: "Enter Different Dates")
        }else if defaults.string(forKey: UserDefaultsKeys.roomcount) == "" {
            showToast(message: "Add Rooms For Booking")
        }else if self.nationalityCode.isEmpty == true {
            showToast(message: "Please Select Nationality.")
        }else if checkDepartureAndReturnDates(payload, p1: "hotel_checkin", p2: "hotel_checkout") == false {
            showToast(message: "Invalid Date")
        }else {
            
            
            do{
                
                let jsonData = try JSONSerialization.data(withJSONObject: payload, options: JSONSerialization.WritingOptions.prettyPrinted)
                let jsonStringData =  NSString(data: jsonData as Data, encoding: NSUTF8StringEncoding)! as String
                
                print(jsonStringData)
                
                
            }catch{
                print(error.localizedDescription)
            }
            
            gotoSearchHotelsResultVC()
            
        }
    }
    
    
    func gotoSearchHotelsResultVC(){
        defaults.set(false, forKey: "hoteltfilteronce")
        guard let vc = HotelSearchResultVC.newInstance.self else {return}
        vc.modalPresentationStyle = .fullScreen
        vc.nationalityCode = self.nationalityCode
        callapibool = true
        vc.payload = payload
        present(vc, animated: true)
    }
    
    
}
