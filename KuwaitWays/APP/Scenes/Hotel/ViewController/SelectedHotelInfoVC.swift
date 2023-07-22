//
//  SelectedHotelInfoVC.swift
//  BeeoonsApp
//
//  Created by MA673 on 22/08/22.
//

import UIKit

class SelectedHotelInfoVC: BaseTableVC, HotelDetailsViewModelDelegate {
    
    
    @IBOutlet weak var nav: NavBar!
    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var navHeight: NSLayoutConstraint!
    
    @IBOutlet weak var bookNowHolderView: UIView!
    @IBOutlet weak var titlelbl: UILabel!
    @IBOutlet weak var bookNowView: UIView!
    @IBOutlet weak var bookNowlbl: UILabel!
    @IBOutlet weak var bookNowBtn: UIButton!
    
    
    var kwdprice = String()
    
    var isVcFrom = String()
    var tablerow = [TableRow]()
    var payload = [String:Any]()
    var vm:HotelDetailsViewModel?
    
    var desc = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Feugiat ut tristique velit in. Dis cursus gravida lorem non consectetur morbi morbi. Ultrices egestas id malesuada justo. Massa ac euismod accumsan tellus turpis."
    static var newInstance: SelectedHotelInfoVC? {
        let storyboard = UIStoryboard(name: Storyboard.Hotel.name,
                                      bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: self.className()) as? SelectedHotelInfoVC
        return vc
    }
    
    

    @objc func offline(notificatio:UNNotification) {
        callapibool = true
        guard let vc = NoInternetConnectionVC.newInstance.self else {return}
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(offline), name: NSNotification.Name("offline"), object: nil)
        
        if  callapibool == true {
            ratekeyArray.removeAll()
            holderView.isHidden = true
            callAPI()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(stopTimer), name: NSNotification.Name("sessionStop"), object: nil)
    }
    
    @objc func stopTimer() {
        guard let vc = PopupVC.newInstance.self else {return}
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: false)
    }
    
    
    func callAPI() {
        payload["booking_source"] = hbooking_source
        payload["hotel_id"] = hotelid
        payload["search_id"] = hsearch_id
        vm?.CALL_GET_HOTEL_DETAILS_API(dictParam: payload)
    }
    
    
    func hotelDetails(response: HotelDetailsModel) {
        print(" ====== hotelDetails ====== ")
        holderView.isHidden = false
        hd = response
        
        //        titlelbl.text = "\(response.currency_obj?.to_currency ?? "") \(response.currency_obj?.conversion_rate ?? "")"
        htoken = response.hotel_details?.token ?? ""
        htokenkey = response.hotel_details?.tokenKey ?? ""
        
        DispatchQueue.main.async {
            self.setupTVCells(hotelDetails: response)
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
        vm = HotelDetailsViewModel(self)
    }
    
    func setupUI() {
        
        self.view.backgroundColor = .WhiteColor
        self.holderView.backgroundColor = .AppHolderViewColor
        nav.titlelbl.text = ""
        nav.backBtn.addTarget(self, action: #selector(backbtnAction(_:)), for: .touchUpInside)
        nav.citylbl.isHidden = false
        nav.datelbl.isHidden = false
        nav.travellerlbl.isHidden = false
        
        nav.citylbl.text = "\(defaults.string(forKey: UserDefaultsKeys.locationcity) ?? "")"
        nav.datelbl.text = "CheckIn -\(convertDateFormat(inputDate: defaults.string(forKey: UserDefaultsKeys.checkin) ?? "" , f1: "dd-MM-yyyy", f2: "dd MMM")) & CheckOut -\(convertDateFormat(inputDate: defaults.string(forKey: UserDefaultsKeys.checkout) ?? "", f1: "dd-MM-yyyy", f2: "dd MMM"))"
        nav.travellerlbl.text = "Guests- \(defaults.string(forKey: UserDefaultsKeys.guestcount) ?? "1") / Room - \(defaults.string(forKey: UserDefaultsKeys.roomcount) ?? "")"
        if screenHeight > 835 {
            navHeight.constant = 190
        }else {
            navHeight.constant = 150
        }
        
        setupViews(v: bookNowHolderView, radius: 0, color: .AppJournyTabSelectColor)
        setupViews(v: bookNowView, radius: 6, color: .AppNavBackColor)
        setupLabels(lbl: titlelbl, text: grandTotal, textcolor: .WhiteColor, font: .oswaldRegular(size: 20))
        setupLabels(lbl: bookNowlbl, text: "BOOK NOW", textcolor: .WhiteColor, font: .oswaldRegular(size: 16))
        bookNowBtn.setTitle("", for: .normal)
        bookNowBtn.addTarget(self, action: #selector(didTapOnBookNowBtn(_:)), for: .touchUpInside)
        
        commonTableView.registerTVCells(["EmptyTVCell",
                                         "HotelSearchResultTVCell",
                                         "RatingWithLabelsTVCell",
                                         "FacilitiesTVCell",
                                         "HotelImagesTVCell",
                                         "RoomsTVCell"])
        
        
    }
    
    
    @objc func backbtnAction(_ sender:UIButton) {
        isFromVCBool = false
        callapibool = false
        dismiss(animated: true)
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
    
    
    override func didTapOnCancellationPolicyBtn(cell: TwinSuperiorRoomTVCell) {
        
        guard let vc = CancellationPolicyPopupVC.newInstance.self else {return}
        vc.modalPresentationStyle = .overCurrentContext
        vc.amount = cell.CancellationPolicyAmount
        vc.datetime = cell.CancellationPolicyFromDate
        self.present(vc, animated: false)
        
    }
    
    
    override func didTapOnRoomTvcell(cell:TwinSuperiorRoomTVCell) {
        ratekeyArray.removeAll()
        ratekeyArray.append(cell.ratekey)
    }
    
    @objc func didTapOnBookNowBtn(_ sender:UIButton) {
        
        if ratekeyArray.isEmpty == true {
            showToast(message: "Please Select Room Type")
        }else {
            guard let vc = ContactInfoVC.newInstance.self else {return}
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: false)
            
        }
    }
}

extension SelectedHotelInfoVC {
    
    func setupTVCells(hotelDetails:HotelDetailsModel) {
        tablerow.removeAll()
        
        tablerow.append(TableRow(title:hotelDetails.hotel_details?.name,
                                 subTitle: hotelDetails.hotel_details?.address,
                                 key:"rating",
                                 characterLimit: hotelDetails.hotel_details?.star_rating,
                                 cellType:.RatingWithLabelsTVCell))
        
        
        tablerow.append(TableRow(height:20,cellType:.EmptyTVCell))
        
        tablerow.append(TableRow(image:hotelDetails.hotel_details?.image,
                                 moreData: hotelDetails.hotel_details?.images,
                                 cellType:.HotelImagesTVCell))
        
        tablerow.append(TableRow(title:hotelDetails.hotel_details?.format_desc?[0].heading,
                                 subTitle: hotelDetails.hotel_details?.format_desc?[0].content,
                                 cellType:.RatingWithLabelsTVCell))
        
        
        if isVcFrom != "PayNowVC" {
            tablerow.append(TableRow(title:"Rooms",
                                     moreData: hotelDetails.hotel_details?.rooms,
                                     cellType:.RoomsTVCell))
        }
        
        
        tablerow.append(TableRow(title:"Facilities",
                                 moreData: hotelDetails.hotel_details?.facility,
                                 cellType:.FacilitiesTVCell))
        
        tablerow.append(TableRow(height:50,cellType:.EmptyTVCell))
        
        
        commonTVData = tablerow
        commonTableView.reloadData()
        
    }
}


