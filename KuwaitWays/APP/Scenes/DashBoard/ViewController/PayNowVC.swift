//
//  PayNowVC.swift
//  BeeoonsApp
//
//  Created by MA673 on 18/08/22.
//

import UIKit

class PayNowVC: BaseTableVC {
    
    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var nav: NavBar!
    @IBOutlet weak var navHeight: NSLayoutConstraint!
    @IBOutlet weak var viewFlightsBtnView: UIView!
    @IBOutlet weak var viewFlightlbl: UILabel!
    @IBOutlet weak var viewFlightsBtn: UIButton!
    
    
    
    static var newInstance: PayNowVC? {
        let storyboard = UIStoryboard(name: Storyboard.Main.name,
                                      bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: self.className()) as? PayNowVC
        return vc
    }
    
    let datePicker = UIDatePicker()
    var addDetailsArray = ["srinath","badmi","Taarak","srinath","badmi","Taarak"]
    var tablerow = [TableRow]()
    var bool = true
    var name = String()
    var flighttotelCount = 0
    var hoteltotelCount = 0
    
    override func viewWillAppear(_ animated: Bool) {
        
        if screenHeight > 800 {
            navHeight.constant = 190
        }else {
            navHeight.constant = 160
        }
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(addDetails(notification:)), name: NSNotification.Name(rawValue: "add"), object: nil)
        
        
    }
    
    
    @objc func addDetails(notification:NSNotification) {
        if let name = notification.object as? String {
            print("name === > \(name)")
            self.name = name
            addDetailsArray.append(name)
        }
        
        commonTableView.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    
    func setupUI() {
        holderView.backgroundColor = .WhiteColor
        nav.titlelbl.text = ""
        nav.backBtn.addTarget(self, action: #selector(gotoBackScreen), for: .touchUpInside)
        nav.citylbl.isHidden = false
        nav.datelbl.isHidden = false
        nav.travellerlbl.isHidden = false
        nav.citylbl.text = "Dubai(DXB) - Kuwait(KWI)"
        nav.datelbl.text = "Thu, 26 Jul  Fri, 27 Jul"
        nav.travellerlbl.text = "1 Traveller , Economy"
        
        viewFlightsBtnView.backgroundColor = .AppBackgroundColor
        viewFlightsBtnView.layer.borderWidth = 1
        viewFlightsBtnView.layer.borderColor = UIColor.AppBtnColor.cgColor
        viewFlightsBtnView.layer.cornerRadius = 15
        viewFlightsBtnView.clipsToBounds = true
        
        viewFlightlbl.textColor = .WhiteColor
        viewFlightlbl.font = UIFont.poppinsRegular(size: 14)
        
        viewFlightsBtn.setTitle("", for: .normal)
        
        commonTableView.registerTVCells(["TDetailsLoginTVCell","EmptyTVCell","PromocodeTVCell","PriceSummaryTVCell","checkOptionsTVCell","AddTravellersDetailsTVCell","PriceLabelsTVCell"])
        
        
        if let selectedTab = defaults.string(forKey: UserDefaultsKeys.tabselect) {
            if selectedTab == "Flight" {
                viewFlightlbl.text = "View Flight Details"
                viewFlightsBtn.addTarget(self, action: #selector(didTapOnViewFlightDetails(_:)), for: .touchUpInside)
                let adultcount = (Int("\(defaults.string(forKey: UserDefaultsKeys.adultCount) ?? "0")") ?? 0)
                let childcount = (Int("\(defaults.string(forKey: UserDefaultsKeys.childCount) ?? "0")") ?? 0)
                let infantsCount = (Int("\(defaults.string(forKey: UserDefaultsKeys.infantsCount) ?? "0")") ?? 0)
                flighttotelCount = (adultcount + childcount + infantsCount)
                setupTVCells()
            }else {
                viewFlightlbl.text = "View Hotel Details"
                viewFlightsBtn.addTarget(self, action: #selector(didTapOnViewHotelDetails(_:)), for: .touchUpInside)
                let adultcount = (Int("\(defaults.string(forKey: UserDefaultsKeys.adultCount) ?? "0")") ?? 0)
                let childcount = (Int("\(defaults.string(forKey: UserDefaultsKeys.childCount) ?? "0")") ?? 0)
                hoteltotelCount = (adultcount + childcount)
                setupHotelTVCells()
            }
        }
    }
    
    
    
    @objc func gotoBackScreen() {
        dismiss(animated: true)
    }
    
    
    func setupTVCells() {
        tablerow.removeAll()
        
        tablerow.append(TableRow(cellType:.TDetailsLoginTVCell))
        tablerow.append(TableRow(title:"Travellers Details",data: addDetailsArray,characterLimit: flighttotelCount,cellType:.AddTravellersDetailsTVCell))
        
        tablerow.append(TableRow(cellType:.PromocodeTVCell))
        tablerow.append(TableRow(cellType:.PriceSummaryTVCell))
        tablerow.append(TableRow(title:"i Accept T&C and Privacy Policy",key: "book",cellType:.checkOptionsTVCell))
        tablerow.append(TableRow(height:200, bgColor:.AppBorderColor,cellType:.EmptyTVCell))
        
        
        commonTVData = tablerow
        commonTableView.reloadData()
    }
    
    
    func setupHotelTVCells() {
        tablerow.removeAll()
        
        tablerow.append(TableRow(cellType:.TDetailsLoginTVCell))
        tablerow.append(TableRow(title:"Guests Details",data: addDetailsArray,characterLimit: hoteltotelCount,cellType:.AddTravellersDetailsTVCell))
        tablerow.append(TableRow(cellType:.PromocodeTVCell))
        tablerow.append(TableRow(title:"Purchase Summary",key: "title",cellType:.PriceLabelsTVCell))
        tablerow.append(TableRow(title:"Room Type",subTitle: "\(defaults.string(forKey: UserDefaultsKeys.roomType) ?? "")",key: "roomtype",cellType:.PriceLabelsTVCell))
        tablerow.append(TableRow(title:"No Of Guest ",subTitle: "2",cellType:.PriceLabelsTVCell))
        tablerow.append(TableRow(title:"No Of Adults",subTitle: "\(defaults.string(forKey: UserDefaultsKeys.hadultCount) ?? "")",cellType:.PriceLabelsTVCell))
        tablerow.append(TableRow(title:"Chack - In",subTitle: "\(defaults.string(forKey: UserDefaultsKeys.checkin) ?? "")",cellType:.PriceLabelsTVCell))
        tablerow.append(TableRow(title:"Chack - Out",subTitle: "\(defaults.string(forKey: UserDefaultsKeys.checkout) ?? "")",cellType:.PriceLabelsTVCell))
        tablerow.append(TableRow(title:"Cancellation Policy:",subTitle: "Non-Refundable",key: "policy",cellType:.PriceLabelsTVCell))
        tablerow.append(TableRow(title:"Tax",subTitle: "KWD:30.00",cellType:.PriceLabelsTVCell))
        tablerow.append(TableRow(title:"Total Price",subTitle: "KWD:150.00",key: "price",cellType:.PriceLabelsTVCell))
        tablerow.append(TableRow(title:"Total Amount",subTitle: "KWD:180.00",key: "total",cellType:.PriceLabelsTVCell))
        tablerow.append(TableRow(height:20, bgColor:.AppBorderColor,cellType:.EmptyTVCell))
        tablerow.append(TableRow(title:"i Accept T&C and Privacy Policy",key: "book",cellType:.checkOptionsTVCell))
        tablerow.append(TableRow(height:50, bgColor:.AppBorderColor,cellType:.EmptyTVCell))
        
        
        commonTVData = tablerow
        commonTableView.reloadData()
    }
    
    
    @objc func didTapOnViewFlightDetails(_ sender:UIButton) {
        guard let vc = SelectedFlightInfoVC.newInstance.self else {return}
        vc.modalPresentationStyle = .fullScreen
        vc.isVcFrom = "PayNowVC"
        self.present(vc, animated: true)
    }
    
    
    @objc func didTapOnViewHotelDetails(_ sender:UIButton) {
        guard let vc = SelectedHotelInfoVC.newInstance.self else {return}
        vc.modalPresentationStyle = .fullScreen
        vc.isVcFrom = "PayNowVC"
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
    
    override func editingTextField(tf:UITextField){
        print(tf.text)
    }
    
    override func didTapOnRefundBtn(cell: PriceSummaryTVCell) {
        print("didTapOnRefundBtn")
    }
    
    
    @objc func didTapOnBookNowBtn(_ sender:UIButton) {
        //        guard let vc = PayNowVC.newInstance.self else {return}
        //        vc.modalPresentationStyle = .overCurrentContext
        //        self.present(vc, animated: true)
    }
    
    
    override func didTapOnAddAdultBtn(cell: AddTravellersDetailsTVCell) {
        goToSaveTravellersDetailsVC()
    }
    
    func goToSaveTravellersDetailsVC() {
        guard let vc = SaveTravellersDetailsVC.newInstance.self else {return}
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    
    
    override func didTapOnEditBtn(cell:TitleLblTVCell){
        goToSaveTravellersDetailsVC()
    }
    
    
   
    
}


extension PayNowVC {
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let myFooter =  Bundle.main.loadNibNamed("BookNowTVCell", owner: self, options: nil)?.first as! BookNowTVCell
        myFooter.bookNowlbl.text = "Pay Now"
        myFooter.bookNowBtn.addTarget(self, action: #selector(didTapOnBookNowBtn(_:)), for: .touchUpInside)
        return myFooter
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 60
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? checkOptionsTVCell {
            if bool == true {
                cell.sunImg.image = UIImage(named: "chk")
                bool = false
            }else {
                cell.sunImg.image = UIImage(named: "uncheck")
                bool = true
            }
        }
    }
}
