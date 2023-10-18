//
//  ModifyHotelSearchVC.swift
//  KuwaitWays
//
//  Created by FCI on 03/05/23.
//

import UIKit

class ModifyHotelSearchVC: BaseTableVC {
    
    
    @IBOutlet weak var nav: NavBar!
    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var navHeight: NSLayoutConstraint!
    
    
    var nationalityCode = String()
    var isVcFrom = String()
    var tablerow = [TableRow]()
    var payload = [String:Any]()
    
    static var newInstance: ModifyHotelSearchVC? {
        let storyboard = UIStoryboard(name: Storyboard.Hotel.name,
                                      bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: self.className()) as? ModifyHotelSearchVC
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
        
    }
    
    func setupUI() {
        self.view.backgroundColor = .black.withAlphaComponent(0.50)
        nav.backgroundColor = .clear
        nav.titlelbl.text = "Modify"
        nav.titlelbl.textColor = .WhiteColor
        nav.backBtn.addTarget(self, action: #selector(backbtnAction(_:)), for: .touchUpInside)
        
        
        
        commonTableView.backgroundColor = .AppHolderViewColor
        commonTableView.layer.cornerRadius = 8
        commonTableView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        commonTableView.clipsToBounds = true
        commonTableView.registerTVCells(["EmptyTVCell",
                                         "SearchFlightTVCell",
                                         "LabelTVCell",
                                         "HotelDealsTVCell"])
        
        
        
        appendHotelSearctTvcells(str: "hotel")
        
        
    }
    
    @objc func reload(notification: NSNotification){
        commonTableView.reloadData()
    }
    
    func appendHotelSearctTvcells(str:String) {
        tablerow.removeAll()
        
        tablerow.append(TableRow(key:"hotel",cellType:.SearchFlightTVCell))
        tablerow.append(TableRow(height:10,bgColor: .AppHolderViewColor,cellType:.EmptyTVCell))
        
        
        commonTVData = tablerow
        commonTableView.reloadData()
        
    }
    
    @objc func backbtnAction(_ sender:UIButton) {
        dismiss(animated: true)
    }
    
    
    override func didTapOnLocationOrCityBtn(cell:HolderViewTVCell){
        guard let vc = SelectFromCityVC.newInstance.self else {return}
        vc.modalPresentationStyle = .fullScreen
        vc.titleStr = "Location/City"
        vc.keyStr = "hotel"
        self.present(vc, animated: false)
    }
    override func didtapOnCheckInBtn(cell:DualViewTVCell){
        guard let vc = CalenderVC.newInstance.self else {return}
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false)
    }
    override func didtapOnCheckOutBtn(cell:DualViewTVCell){
        guard let vc = CalenderVC.newInstance.self else {return}
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false)
    }
    
    override func didTapOnAddRooms(cell:HolderViewTVCell){
        guard let vc = AddRoomsVCViewController.newInstance.self else {return}
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: false)
    }
    
    override func didTapOnSearchHotelsBtn(cell:ButtonTVCell){
        
        payload["city"] = defaults.string(forKey: UserDefaultsKeys.locationcity)
        payload["hotel_destination"] = defaults.string(forKey: UserDefaultsKeys.locationid)
        payload["hotel_checkin"] = defaults.string(forKey: UserDefaultsKeys.checkin)
        payload["hotel_checkout"] = defaults.string(forKey: UserDefaultsKeys.checkout)
        payload["rooms"] = defaults.string(forKey: UserDefaultsKeys.roomcount)
        payload["adult"] = adtArray
        payload["child"] = chArray
        payload["childAge_1"] = ["0","0"]
        payload["nationality"] = nationalityCode
        
        
        if defaults.string(forKey: UserDefaultsKeys.locationcity) == "Add City" || defaults.string(forKey: UserDefaultsKeys.locationcity) == nil {
            showToast(message: "Enter Hotel or City ")
        }else if defaults.string(forKey: UserDefaultsKeys.checkin) == "Check In" || defaults.string(forKey: UserDefaultsKeys.checkin) == nil{
            showToast(message: "Enter Checkin Date")
        }else if defaults.string(forKey: UserDefaultsKeys.checkout) == "Check Out" || defaults.string(forKey: UserDefaultsKeys.checkout) == nil{
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
            gotoSearchHotelsResultVC()
        }
    }
    
    
    func gotoSearchHotelsResultVC(){
        guard let vc = HotelSearchResultVC.newInstance.self else {return}
        vc.modalPresentationStyle = .fullScreen
        vc.nationalityCode = self.nationalityCode
        callapibool = true
        vc.payload = payload
        present(vc, animated: true)
    }
    
    
}
