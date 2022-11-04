//
//  TravellerEconomyVC.swift
//  AirportProject
//
//  Created by Codebele 09 on 26/06/22.
//

import UIKit

class TravellerEconomyVC: BaseTableVC {
    
    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var nav: NavBar!
    
    
    var tableRow = [TableRow]()
    var count = 1
    var keyString = String()
    var adultsCount = 1
    var childCount = 0
    var infantsCount = 0
    var roomCountArray = [Int]()
    static var newInstance: TravellerEconomyVC? {
        let storyboard = UIStoryboard(name: Storyboard.Main.name,
                                      bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: self.className()) as? TravellerEconomyVC
        return vc
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let selectedTab = defaults.string(forKey: UserDefaultsKeys.tabselect){
            if selectedTab == "Flight" {
                adultsCount = Int(defaults.string(forKey: UserDefaultsKeys.adultCount) ?? "1") ?? 0
                childCount = Int(defaults.string(forKey: UserDefaultsKeys.childCount) ?? "0") ?? 0
                infantsCount = Int(defaults.string(forKey: UserDefaultsKeys.adultCount) ?? "0") ?? 0
                
                
            }else {
                adultsCount = Int(defaults.string(forKey: UserDefaultsKeys.hadultCount) ?? "1") ?? 1
                childCount = Int(defaults.string(forKey: UserDefaultsKeys.hchildCount) ?? "0") ?? 0
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        self.view.backgroundColor = .black.withAlphaComponent(0.3)
        holderView.backgroundColor = .black.withAlphaComponent(0.3)
        nav.backBtn.addTarget(self, action: #selector(gotoBackScreen), for: .touchUpInside)
       
        commonTableView.backgroundColor = .WhiteColor
        commonTableView.layer.cornerRadius = 10
        commonTableView.clipsToBounds = true
        commonTableView.registerTVCells(["RadioButtonTVCell","TravellerEconomyTVCell","TitleLblTVCell","EmptyTVCell","ButtonTVCell","checkOptionsTVCell"])
        
//        if keyString == "hotels" {
//
//        }else {
//
//        }
        
        if let selectedTab = defaults.string(forKey: UserDefaultsKeys.tabselect) {
            if selectedTab == "Hotel" {
                nav.titlelbl.text = "Select Adults, Rooms"
                roomCountArray.append(count)
                setupSearchHotelsEconomyTVCells()
            }else {
                nav.titlelbl.text = "Select Traveller , Economy"
                setupSearchFlightEconomyTVCells()
            }
        }
    }
    
    func setupSearchFlightEconomyTVCells(){
        
        tableRow.removeAll()
        
        tableRow.append(TableRow(title:"Adults",subTitle: "From 12 yeras old",text: "\(defaults.string(forKey: UserDefaultsKeys.adultCount) ?? "1")",cellType:.TravellerEconomyTVCell))
        tableRow.append(TableRow(title:"Children",subTitle: "2 - 11",text: "\(defaults.string(forKey: UserDefaultsKeys.childCount) ?? "0")",cellType:.TravellerEconomyTVCell))
        tableRow.append(TableRow(title:"Infants",subTitle: "From 12 yeras old",text: "\(defaults.string(forKey: UserDefaultsKeys.infantsCount) ?? "0")",cellType:.TravellerEconomyTVCell))
        tableRow.append(TableRow(height:20,cellType:.EmptyTVCell))
        tableRow.append(TableRow(title:"Select Class",cellType:.TitleLblTVCell))
        tableRow.append(TableRow(title:"Economy",image: "radioUnselected",cellType:.RadioButtonTVCell))
        tableRow.append(TableRow(title:"Premium Economy",image: "radioUnselected",cellType:.RadioButtonTVCell))
        tableRow.append(TableRow(title:"First",image: "radioUnselected",cellType:.RadioButtonTVCell))
        tableRow.append(TableRow(title:"Business",image: "radioUnselected",cellType:.RadioButtonTVCell))
        tableRow.append(TableRow(height:30,cellType:.EmptyTVCell))
        tableRow.append(TableRow(title:"Done",cellType:.ButtonTVCell))
        tableRow.append(TableRow(height:50,cellType:.EmptyTVCell))
        
        
        commonTVData = tableRow
        commonTableView.reloadData()
        
    }
    
    
    @objc func gotoBackScreen() {
        self.dismiss(animated: true)
    }
    
    
    func setupSearchHotelsEconomyTVCells(){
        
        print("adultsCount ==== > \(Int(defaults.string(forKey: UserDefaultsKeys.hadultCount) ?? "1") ?? 1)")
        tableRow.removeAll()
        
        
        
        
        roomCountArray.forEach { i in
            tableRow.append(TableRow(title:"Room \(i)",key: "room",cellType:.checkOptionsTVCell))
            tableRow.append(TableRow(title:"Adults",subTitle: "From 12 yeras old",text: "\(defaults.string(forKey: UserDefaultsKeys.hadultCount) ?? "1")",cellType:.TravellerEconomyTVCell))
            tableRow.append(TableRow(title:"Children",subTitle: "2 - 11",text: "\(defaults.string(forKey: UserDefaultsKeys.hchildCount) ?? "0")",cellType:.TravellerEconomyTVCell))
        }
        
        
        tableRow.append(TableRow(height:20,cellType:.EmptyTVCell))
        tableRow.append(TableRow(title:"+ Add Room",key:"addroom",cellType:.ButtonTVCell))
        tableRow.append(TableRow(height:100,cellType:.EmptyTVCell))
        tableRow.append(TableRow(title:"Done",cellType:.ButtonTVCell))
        tableRow.append(TableRow(height:50,cellType:.EmptyTVCell))
        
        commonTVData = tableRow
        commonTableView.reloadData()
        
    }
    
    
    
    
    override func didTapOnIncrementButton(cell: TravellerEconomyTVCell) {
        
        
        if (adultsCount + childCount) > 8 ||  (adultsCount + childCount + infantsCount) > 8{
            showToast(message: "adultsCount not mor than 9 ")
            showAlertOnWindow(title: "", message: "Adults Count Not More Than 9", titles: ["OK"], completionHanlder: nil)
        }else {
            if cell.count >= 0 {
                cell.count += 1
                cell.countlbl.text = "\(cell.count)"
            }
            
            if cell.titlelbl.text == "Adults" {
                adultsCount = cell.count
            }else if cell.titlelbl.text == "Children"{
                childCount = cell.count
            }else {
                infantsCount = cell.count
            }
            
            print("adultsCount :\(adultsCount)")
        }
        
    }
    
    
    override func didTapOnDecrementButton(cell: TravellerEconomyTVCell) {
        
        if cell.count > 0 {
            cell.count -= 1
            // cell.countlbl.text = "\(cell.count)"
        }
        print(cell.count)
        
        if cell.titlelbl.text == "Adults" {
            adultsCount = cell.count
        }else if cell.titlelbl.text == "Children"{
            childCount = cell.count
        }else {
            infantsCount = cell.count
        }
        
        
        if (adultsCount + childCount) > 8 || (adultsCount + childCount + infantsCount) > 8{
            showToast(message: "adultsCount not mor than 9 ")
            showAlertOnWindow(title: "", message: "Adults Count Not More Than 9", titles: ["OK"], completionHanlder: nil)
        }else {
            cell.countlbl.text = "\(cell.count)"
            print("adultsCount :\(adultsCount)")
        }
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? RadioButtonTVCell {
            cell.radioImg.image = UIImage(named: "radioSelected")?.withRenderingMode(.alwaysOriginal).withTintColor(.AppBackgroundColor)
           
            
            if let journeyType = defaults.string(forKey: UserDefaultsKeys.journeyType) {
                if journeyType == "One Way" {
                    defaults.set(cell.titlelbl.text ?? "", forKey: UserDefaultsKeys.selectClass)
                }else if journeyType == "Round Trip" {
                    defaults.set(cell.titlelbl.text ?? "", forKey: UserDefaultsKeys.rselectClass)
                }else {
                    defaults.set(cell.titlelbl.text ?? "", forKey: UserDefaultsKeys.mselectClass)
                }
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? RadioButtonTVCell {
            cell.radioImg.image = UIImage(named: "radioUnselected")
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
    
    
    override func btnAction(cell: ButtonTVCell) {
        print("button tap ...")
        print("adultsCount \(adultsCount)")
        print("childCount \(childCount)")
        print("infantsCount \(infantsCount)")
        if cell.titlelbl.text == "Done" {
            if let selectedTab = defaults.string(forKey: UserDefaultsKeys.tabselect){
                if selectedTab == "Flight" {
                    
                    if let journeyType = defaults.string(forKey: UserDefaultsKeys.journeyType) {
                        if journeyType == "One Way" {
                            defaults.set(adultsCount, forKey: UserDefaultsKeys.adultCount)
                            defaults.set(childCount, forKey: UserDefaultsKeys.childCount)
                            defaults.set(infantsCount, forKey: UserDefaultsKeys.infantsCount)
                        }else if journeyType == "Round Trip" {
                            defaults.set(adultsCount, forKey: UserDefaultsKeys.radultCount)
                            defaults.set(childCount, forKey: UserDefaultsKeys.rchildCount)
                            defaults.set(infantsCount, forKey: UserDefaultsKeys.rinfantsCount)
                        }else {
                            defaults.set(adultsCount, forKey: UserDefaultsKeys.madultCount)
                            defaults.set(childCount, forKey: UserDefaultsKeys.mchildCount)
                            defaults.set(infantsCount, forKey: UserDefaultsKeys.minfantsCount)
                        }
                    }
                    
                    
                    gotoBookFlightVC()
                }else {
                    defaults.set(adultsCount, forKey: UserDefaultsKeys.hadultCount)
                    defaults.set(childCount, forKey: UserDefaultsKeys.hchildCount)
                    
                    NotificationCenter.default.post(name: Notification.Name("reload"), object: nil)
                    dismiss(animated: false)
                }
            }
        }else {
            print("Add Room ......")
            count += 1
            roomCountArray.append(count)
            setupSearchHotelsEconomyTVCells()
        }
        
    }
}


