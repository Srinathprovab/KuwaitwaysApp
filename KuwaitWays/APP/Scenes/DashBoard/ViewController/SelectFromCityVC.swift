//
//  SelectFromCityVC.swift
//  BabSafar
//
//  Created by MA673 on 20/07/22.
//

import UIKit
import Alamofire


class SelectFromCityVC: BaseTableVC, SelectCityViewModelProtocal {
    
    @IBOutlet weak var searchTextfieldHolderView: UIView!
    @IBOutlet weak var searchImg: UIImageView!
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var nav: NavBar!
    
    var filtered:[SelectCityModel] = []
    var cityList:[SelectCityModel] = []
    var cityViewModel: SelectCityViewModel?
    var tablerow = [TableRow]()
    var titleStr = String()
    var payload = [String:Any]()
    var isSearchBool = Bool()
    var searchText = String()
    static var newInstance: SelectFromCityVC? {
        let storyboard = UIStoryboard(name: Storyboard.Main.name,
                                      bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: self.className()) as? SelectFromCityVC
        return vc
    }
    
    override func viewWillAppear(_ animated: Bool) {
        CallShowCityListAPI(str: "")
        
        NotificationCenter.default.addObserver(self, selector: #selector(noInterNet(notification:)), name: NSNotification.Name("nointernet"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTV(notification:)), name: NSNotification.Name("reloadTV"), object: nil)
    }
    
    @objc func noInterNet(notification:NSNotification) {
        let msg = notification.object as? String
        if msg == "no internet" {
            guard let vc = NoInternetConnectionVC.newInstance.self else {return}
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated: false)
        }
    }
    
    @objc func reloadTV(notification:NSNotification) {
        CallShowCityListAPI(str: "")
    }
    
    
    func CallShowCityListAPI(str:String) {
        BASE_URL = "https://provabdevelopment.com/alghanim_new/mobile_webservices/mobile/index.php/ajax/"
        payload["term"] = str
        cityViewModel?.CallShowCityListAPI(dictParam: payload)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupUI()
        cityViewModel = SelectCityViewModel(self)
        
    }
    
    func setupUI() {
        
        nav.titlelbl.text = titleStr
        nav.backBtn.addTarget(self, action: #selector(dismisVC(_:)), for: .touchUpInside)
        setupViews(v: searchTextfieldHolderView, radius: 6, color: .WhiteColor.withAlphaComponent(0.5))
        
        searchImg.image = UIImage(named: "search")?.withRenderingMode(.alwaysOriginal).withTintColor(.AppBackgroundColor)
        
        searchTF.backgroundColor = .clear
        searchTF.placeholder = "search airport /city"
        searchTF.setLeftPaddingPoints(20)
        searchTF.font = UIFont.LatoRegular(size: 16)
        searchTF.addTarget(self, action: #selector(searchTextChanged(_:)), for: .editingChanged)
        
        
        commonTableView.register(UINib(nibName: "FromCityTVCell", bundle: nil), forCellReuseIdentifier: "cell")
        commonTableView.separatorStyle = .singleLine
        commonTableView.separatorColor = .lightGray
    }
    
    
    
    @objc func dismisVC(_ sender:UIButton) {
        self.dismiss(animated: true)
    }
    
    func setupViews(v:UIView,radius:CGFloat,color:UIColor) {
        v.backgroundColor = color
        v.layer.cornerRadius = radius
        v.clipsToBounds = true
        v.layer.borderWidth = 1
        v.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.4).cgColor
    }
    
    func setupLabels(lbl:UILabel,text:String,textcolor:UIColor,font:UIFont) {
        lbl.text = text
        lbl.textColor = textcolor
        lbl.font = font
    }
    
    
    @objc func searchTextChanged(_ sender: UITextField) {
        searchText = sender.text ?? ""
        
        if searchText == "" {
            isSearchBool = false
            filterContentForSearchText(searchText)
        }else {
            isSearchBool = true
            filterContentForSearchText(searchText)
            
        }
        
        CallShowCityListAPI(str: searchText)
    }
    
    func filterContentForSearchText(_ searchText: String) {
        print("Filterin with:", searchText)
        filtered.removeAll()
        filtered = self.cityList.filter { thing in
            return "\(thing.label?.lowercased() ?? "")".contains(searchText.lowercased())
        }
        
        commonTableView.reloadData()
    }
    
    
    
    func ShowCityList(response: [SelectCityModel]) {
        
        print(response.first)
        self.cityList = response
        
        DispatchQueue.main.async {[self] in
            commonTableView.reloadData()
        }
    }
    
    
    func gotoBookFlightVC() {
        guard let vc = BookFlightVC.newInstance.self else {return}
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: false)
    }
    
    func gotoSearchHotelsVC() {
        //        guard let vc = SearchHotelsVC.newInstance.self else {return}
        //        vc.modalPresentationStyle = .overCurrentContext
        //        self.present(vc, animated: false)
    }
    
    @IBAction func didTapOnBackButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}


extension SelectFromCityVC {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //check search text & original text
        if( isSearchBool == true){
            return filtered.count
        }else{
            return cityList.count
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FromCityTVCell
        cell.selectionStyle = .none
        if( isSearchBool == true){
            let dict = filtered[indexPath.row]
            cell.titlelbl.text = dict.label
            cell.subTitlelbl.text = dict.value
            cell.id = dict.id ?? ""
            cell.cityShortNamelbl.text = dict.airportCode
        }else{
            let dict = cityList[indexPath.row]
            cell.titlelbl.text = dict.label
            cell.subTitlelbl.text = dict.value
            cell.id = dict.id ?? ""
            cell.cityShortNamelbl.text = dict.airportCode
        }
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) as? FromCityTVCell {
            
            if let selectedtab = defaults.string(forKey: UserDefaultsKeys.tabselect) {
                if selectedtab == "Flight" {
                    if let selectedJourneyType = defaults.string(forKey: UserDefaultsKeys.journeyType) {
                        if selectedJourneyType == "One Way" {
                            if titleStr == "From" {
                                defaults.set(cell.titlelbl.text ?? "", forKey: UserDefaultsKeys.fromCity)
                                defaults.set(cell.id , forKey: UserDefaultsKeys.fromlocid)
                            }else {
                                defaults.set(cell.titlelbl.text ?? "", forKey: UserDefaultsKeys.toCity)
                                defaults.set(cell.id , forKey: UserDefaultsKeys.tolocid)
                            }
                        }else if selectedJourneyType == " Round Trip" {
                            if titleStr == "From" {
                                defaults.set(cell.titlelbl.text ?? "", forKey: UserDefaultsKeys.rfromCity)
                                defaults.set(cell.id , forKey: UserDefaultsKeys.rfromlocid)
                            }else {
                                defaults.set(cell.titlelbl.text ?? "", forKey: UserDefaultsKeys.rtoCity)
                                defaults.set(cell.id , forKey: UserDefaultsKeys.rtolocid)
                            }
                        }else {
                            if titleStr == "From" {
                                defaults.set(cell.titlelbl.text ?? "", forKey: UserDefaultsKeys.mfromCity)
                                defaults.set(cell.id , forKey: UserDefaultsKeys.mfromlocid)
                            }else {
                                defaults.set(cell.titlelbl.text ?? "", forKey: UserDefaultsKeys.mtoCity)
                                defaults.set(cell.id , forKey: UserDefaultsKeys.mtolocid)
                            }
                        }
                    }
                    
                    
                    
                    NotificationCenter.default.post(name: NSNotification.Name("reload"), object: nil)
                    self.gotoBookFlightVC()
                }else {
                    defaults.set(cell.titlelbl.text ?? "", forKey: UserDefaultsKeys.locationcity)
                    NotificationCenter.default.post(name: NSNotification.Name("reload"), object: nil)
                    self.dismiss(animated: true)
                }
            }
        }
        
        
    }
}
