//
//  HotelSearchResultVC.swift
//  BeeoonsApp
//
//  Created by MA673 on 22/08/22.
//

import UIKit

class HotelSearchResultVC: BaseTableVC {
    
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
    
    
    
    
    
    var isVcFrom = String()
    var tablerow = [TableRow]()
    static var newInstance: HotelSearchResultVC? {
        let storyboard = UIStoryboard(name: Storyboard.Hotel.name,
                                      bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: self.className()) as? HotelSearchResultVC
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
        self.holderView.backgroundColor = .AppBackgroundColor
        nav.titlelbl.text = "Search Result"
        nav.backBtn.addTarget(self, action: #selector(backbtnAction(_:)), for: .touchUpInside)
        nav.citylbl.isHidden = false
        nav.datelbl.isHidden = false
        nav.travellerlbl.isHidden = false
        nav.editView.isHidden = false
        nav.editBtn.addTarget(self, action: #selector(modifySearchHotel(_:)), for: .touchUpInside)
        nav.citylbl.text = "\(defaults.string(forKey: UserDefaultsKeys.locationcity) ?? "")"
        nav.datelbl.text = "CheckIn -\(defaults.string(forKey: UserDefaultsKeys.checkin) ?? "" ) CheckOut -\(defaults.string(forKey: UserDefaultsKeys.checkin) ?? "")"
        nav.travellerlbl.text = "Guests- 1 / Room - 1"
        let screenHeight = UIScreen.main.bounds.size.height
        if screenHeight > 800 {
            navHeight.constant = 220
        }else {
            navHeight.constant = 200
        }
        
        setupLabels(lbl: titlelbl, text: "Your Session Expires In: 14:15", textcolor: .WhiteColor, font: .OpenSansRegular(size: 12))
        setupLabels(lbl: subtitlelbl, text: "38 Hotels Found", textcolor: .WhiteColor, font: .OpenSansRegular(size: 12))
        
        setupViews(v: mapView, radius: 4, color: .AppBtnColor)
        setupViews(v: filterView, radius: 4, color: .AppBtnColor)
        mapImg.image = UIImage(named: "loc")
        filterImg.image = UIImage(named: "filter")
        mapBtn.setTitle("", for: .normal)
        filterpBtn.setTitle("", for: .normal)
        mapBtn.addTarget(self, action: #selector(didTapOnMapviewBtn(_:)), for: .touchUpInside)
        filterpBtn.addTarget(self, action: #selector(didTapOnFilterwBtn(_:)), for: .touchUpInside)
        
        
        commonTableView.registerTVCells(["EmptyTVCell","HotelSearchResultTVCell"])
        appendHotelSearctTvcells(str: "hotel")
    }
    
    
    
    
    @objc func reload(notification: NSNotification){
        commonTableView.reloadData()
    }
    
    
    
    func appendHotelSearctTvcells(str:String) {
        tablerow.removeAll()
        
        
        
        for _ in 1...10 {
            tablerow.append(TableRow(title:"Golden Tulip Deira ( Former Nihal Palace)",subTitle: "Deira, Al Rigga Street, Clock Tower, DUBAI, 33214",image: "hotel1", characterLimit: 3,cellType:.HotelSearchResultTVCell))
        }
        
        commonTVData = tablerow
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
        guard let vc = BookHotelVC.newInstance.self else {return}
        vc.modalPresentationStyle = .overCurrentContext
        vc.isVcFrom = "modify"
        self.present(vc, animated: false)
    }
    
    
    @objc func backbtnAction(_ sender:UIButton) {
        guard let vc = BookHotelVC.newInstance.self else {return}
        vc.modalPresentationStyle = .fullScreen
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
        self.present(vc, animated: false)
    }
    
    
    override func didTapOnDetailsBtn(cell: HotelSearchResultTVCell) {
        guard let vc = SelectedHotelInfoVC.newInstance.self else {return}
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false)
    }
    
    
    
}
