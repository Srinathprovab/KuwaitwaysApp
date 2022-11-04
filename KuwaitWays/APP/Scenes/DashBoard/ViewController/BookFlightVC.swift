//
//  BookFlightVC.swift
//  BeeoonsApp
//
//  Created by MA673 on 17/08/22.
//

import UIKit

class BookFlightVC: BaseTableVC {
    
    @IBOutlet weak var nav: NavBar!
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
    @IBOutlet weak var navHeight: NSLayoutConstraint!
    
    var isVcFrom = String()
    var tablerow = [TableRow]()
    static var newInstance: BookFlightVC? {
        let storyboard = UIStoryboard(name: Storyboard.Main.name,
                                      bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: self.className()) as? BookFlightVC
        return vc
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(reload(notification:)), name: NSNotification.Name("reload"), object: nil)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(reload(notification:)), name: NSNotification.Name("reload"), object: nil)
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
        self.view.backgroundColor = .black.withAlphaComponent(0.4)
        self.holderView.backgroundColor = .AppBGcolor
        nav.titlelbl.text = "Book Flight"
        nav.backBtn.addTarget(self, action: #selector(backbtnAction(_:)), for: .touchUpInside)
        nav.contentView.backgroundColor = .WhiteColor
        nav.titlelbl.textColor = .AppLabelColor
        nav.backBtn.tintColor = UIColor.AppLabelColor
        
        if screenHeight > 800 {
            navHeight.constant = 190
        }else {
            navHeight.constant = 160
        }
        
        
        buttonsView.addCornerRadiusWithShadow(color: .lightGray, borderColor: .AppBorderColor, cornerRadius: 20)
        buttonsView.backgroundColor = .WhiteColor
      //  setupViews(v: buttonsView, radius: 20, color: .WhiteColor)
        setupViews(v: oneWayView, radius: 18, color: .AppJournyTabSelectColor)
        setupViews(v: roundTripView, radius: 18, color: .WhiteColor)
        setupViews(v: multicityView, radius: 18, color: .WhiteColor)
        
        setupLabels(lbl: oneWaylbl, text: "One Way", textcolor: .WhiteColor, font: .OpenSansRegular(size: 16))
        setupLabels(lbl: roundTriplbl, text: "Round Trip", textcolor: .AppSubtitleColor, font: .OpenSansRegular(size: 16))
        setupLabels(lbl: multicitylbl, text: "Multicity", textcolor: .AppSubtitleColor, font: .OpenSansRegular(size: 16))
        
        
        oneWayBtn.setTitle("", for: .normal)
        roundTripBtn.setTitle("", for: .normal)
        multicityBtn.setTitle("", for: .normal)
        
        commonTableView.registerTVCells(["EmptyTVCell","SearchFlightTVCell","LabelTVCell","HotelDealsTVCell","MultiCityTripTVCell"])
        appendTvcells(str: "oneway")
        if let selectedJourneyType = defaults.string(forKey: UserDefaultsKeys.journeyType) {
            if selectedJourneyType == "Multicity" {
                setupMulticity()
            }else if selectedJourneyType == "Round Trip" {
                setupRoundTrip()
            }else {
                setupOneWay()
            }
        }
        
        
        if isVcFrom == "modify" {
            appendModifySearchTVCell()
        }
    }
    
    
    func appendTvcells(str:String) {
        tablerow.removeAll()
        
        tablerow.append(TableRow(key:str,cellType:.SearchFlightTVCell))
        tablerow.append(TableRow(height:10,bgColor: .AppBGcolor,cellType:.EmptyTVCell))
        tablerow.append(TableRow(title:"Best Deals Flights",key: "deals",cellType:.LabelTVCell))
        tablerow.append(TableRow(height:10,bgColor: .AppBGcolor,cellType:.EmptyTVCell))
        tablerow.append(TableRow(key1:"flight",cellType:.HotelDealsTVCell))
        tablerow.append(TableRow(height:30,bgColor: .AppBGcolor,cellType:.EmptyTVCell))

        commonTVData = tablerow
        commonTableView.reloadData()
        
    }
    
    
    func appendMulticityTvcells() {
        tablerow.removeAll()
        
        tablerow.append(TableRow(cellType:.MultiCityTripTVCell))
        tablerow.append(TableRow(height:10,bgColor: .AppBGcolor,cellType:.EmptyTVCell))
        tablerow.append(TableRow(title:"Flight ",subTitle: "Popular International Flights From Kuwait",key: "deals",cellType:.LabelTVCell))
        tablerow.append(TableRow(height:18,bgColor: .AppBGcolor,cellType:.EmptyTVCell))
        tablerow.append(TableRow(key1:"flight",cellType:.HotelDealsTVCell))
        tablerow.append(TableRow(height:30,bgColor: .AppBGcolor,cellType:.EmptyTVCell))

        commonTVData = tablerow
        commonTableView.reloadData()
        
    }
    
    
    func appendModifySearchTVCell() {
        nav.titlelbl.text = "Modify"
        self.holderView.backgroundColor = .clear
        tablerow.removeAll()
        
        tablerow.append(TableRow(cellType:.SearchFlightTVCell))
        
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
        roundTriplbl.textColor = .AppSubtitleColor
        multicitylbl.textColor = .AppSubtitleColor
        
        oneWayView.backgroundColor = .AppJournyTabSelectColor
        roundTripView.backgroundColor = .WhiteColor
        multicityView.backgroundColor = .WhiteColor
        
        defaults.set("One Way", forKey: UserDefaultsKeys.journeyType)
        appendTvcells(str: "oneway")
    }
    
    
    func setupRoundTrip() {
        oneWaylbl.textColor = .AppSubtitleColor
        roundTriplbl.textColor = .WhiteColor
        multicitylbl.textColor = .AppSubtitleColor
        
        oneWayView.backgroundColor = .WhiteColor
        roundTripView.backgroundColor = .AppJournyTabSelectColor
        multicityView.backgroundColor = .WhiteColor
        
        defaults.set("Round Trip", forKey: UserDefaultsKeys.journeyType)
        NotificationCenter.default.post(name: Notification.Name("reload"), object: nil)
        appendTvcells(str: "roundtrip")
    }
    
    
    func setupMulticity() {
        oneWaylbl.textColor = .AppSubtitleColor
        roundTriplbl.textColor = .AppSubtitleColor
        multicitylbl.textColor = .WhiteColor
        
        oneWayView.backgroundColor = .WhiteColor
        roundTripView.backgroundColor = .WhiteColor
        multicityView.backgroundColor = .AppJournyTabSelectColor
        
        defaults.set("Multicity", forKey: UserDefaultsKeys.journeyType)
        appendMulticityTvcells()
    }
    
    
    
    override func didTapOnFromCity(cell: HolderViewTVCell) {
        gotoSelectCityVC(str: "From")
    }
    
    override func didTapOnToCity(cell: HolderViewTVCell) {
        gotoSelectCityVC(str: "To")
    }
    
    override func didTapOnSelectDepDateBtn(cell: DualViewTVCell) {
        gotoCalenderVC()
    }
    override func didTapOnSelectRepDateBtn(cell: DualViewTVCell) {
        gotoCalenderVC()
    }
    
    
    override func didTapOnAddTravelerEconomy(cell:HolderViewTVCell){
        print("didTapOnAddTravelerEconomy")
        gotoAddTravelerVC()
    }
    
    func gotoSelectCityVC(str:String) {
        guard let vc = SelectFromCityVC.newInstance.self else {return}
        vc.modalPresentationStyle = .fullScreen
        vc.titleStr = str
        self.present(vc, animated: true)
    }
    
    func gotoCalenderVC() {
        guard let vc = CalenderVC.newInstance.self else {return}
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    func gotoAddTravelerVC() {
        guard let vc = TravellerEconomyVC.newInstance.self else {return}
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    
    func gotoSearchFlightResultVC() {
        guard let vc = SearchFlightResultVC.newInstance.self else {return}
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    
    override func didTapOnSearchFlightsBtn(cell:SearchFlightTVCell) {
        print("From City:\(defaults.string(forKey: UserDefaultsKeys.fromCity) ?? "")")
        print("To City:\(defaults.string(forKey: UserDefaultsKeys.toCity) ?? "")")
        print("Deperature Date:\(defaults.string(forKey: UserDefaultsKeys.calDepDate) ?? "")")
        print("Traveler :\(defaults.string(forKey: UserDefaultsKeys.travellerDetails) ?? "")")
        
        gotoSearchFlightResultVC()
    }
    
    
    
    override func didTapOnFromBtn(cell:MulticityFromToTVCell){
        gotoSelectCityVC(str: "From")
    }
    override func didTapOnToBtn(cell:MulticityFromToTVCell){
        gotoSelectCityVC(str: "To")
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
        gotoSearchFlightResultVC()
    }
}
