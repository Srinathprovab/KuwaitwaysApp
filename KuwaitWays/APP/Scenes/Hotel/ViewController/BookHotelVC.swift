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
    
    var isVcFrom = String()
    var tablerow = [TableRow]()
    static var newInstance: BookHotelVC? {
        let storyboard = UIStoryboard(name: Storyboard.Hotel.name,
                                      bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: self.className()) as? BookHotelVC
        return vc
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(reload(notification:)), name: NSNotification.Name("reload"), object: nil)
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
        
        self.view.backgroundColor = .black.withAlphaComponent(0.4)
        
        nav.titlelbl.text = "Book Hotel"
        nav.backBtn.addTarget(self, action: #selector(backbtnAction(_:)), for: .touchUpInside)
        let screenHeight = UIScreen.main.bounds.size.height
        if screenHeight > 800 {
            navHeight.constant = 130
        }else {
            navHeight.constant = 120
        }
        
        
        commonTableView.registerTVCells(["EmptyTVCell","SearchFlightTVCell","LabelTVCell","HotelDealsTVCell"])
       
        
        if isVcFrom == "modify" {
            self.holderView.backgroundColor = .clear
            commonTableView.isScrollEnabled = false
            appendModifyHotelSearctTvcells(str: "hotel")
        }else {
            self.holderView.backgroundColor = .AppBackgroundColor
            appendHotelSearctTvcells(str: "hotel")
        }
        
    }
    
    @objc func reload(notification: NSNotification){
        commonTableView.reloadData()
    }
    
    func appendHotelSearctTvcells(str:String) {
        tablerow.removeAll()
        
        
        tablerow.append(TableRow(key:"hotel",cellType:.SearchFlightTVCell))
        
        
        
        tablerow.append(TableRow(height:10,cellType:.EmptyTVCell))
        tablerow.append(TableRow(title:"Hotel ",subTitle: "Deals from your favorite booking sites, All in one place.",key: "deals",cellType:.LabelTVCell))
        tablerow.append(TableRow(height:18,cellType:.EmptyTVCell))
        tablerow.append(TableRow(key1:"hotel",cellType:.HotelDealsTVCell))
        
        
        
        tablerow.append(TableRow(height:18,cellType:.EmptyTVCell))
        tablerow.append(TableRow(title:"Flight ",subTitle: "Popular International Flights From Kuwait",key: "deals",cellType:.LabelTVCell))
        tablerow.append(TableRow(height:18,cellType:.EmptyTVCell))
        tablerow.append(TableRow(key1:"flight",cellType:.HotelDealsTVCell))
        tablerow.append(TableRow(height:30,cellType:.EmptyTVCell))
        
        
        
        commonTVData = tablerow
        commonTableView.reloadData()
        
    }
    
    
    
    
    func appendModifyHotelSearctTvcells(str:String) {
        tablerow.removeAll()
        
        
        tablerow.append(TableRow(key:str,cellType:.SearchFlightTVCell))
        
        
        commonTVData = tablerow
        commonTableView.reloadData()
        
    }
    
    
    
    @objc func backbtnAction(_ sender:UIButton) {
        if isVcFrom == "modify" {
            dismiss(animated: false)
        }else {
            guard let vc = DBTabbarController.newInstance.self else {return}
            vc.modalPresentationStyle = .fullScreen
            vc.selectedIndex = 0
            self.present(vc, animated: false)
        }
    }
    
    
    
    override func didTapOnLocationOrCityBtn(cell:HolderViewTVCell){
        guard let vc = SelectFromCityVC.newInstance.self else {return}
        vc.modalPresentationStyle = .fullScreen
        vc.titleStr = "Location/ City"
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
    
    override func didTapOnAddTravelerEconomy(cell:HolderViewTVCell){
        guard let vc = TravellerEconomyVC.newInstance.self else {return}
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false)
    }
    
    override func didTapOnSearchHotelsBtn(cell:ButtonTVCell){
        print("city/location \(defaults.string(forKey: UserDefaultsKeys.locationcity) ?? "")")
        print("checkin \(defaults.string(forKey: UserDefaultsKeys.checkin) ?? "")")
        print("checkout \(defaults.string(forKey: UserDefaultsKeys.checkout) ?? "")")
        print("hotel travellerDetails \(defaults.string(forKey: UserDefaultsKeys.htravellerDetails) ?? "mmmm")")
        
        
        guard let vc = HotelSearchResultVC.newInstance.self else {return}
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false)
    }
    
}
