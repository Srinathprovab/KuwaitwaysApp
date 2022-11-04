//
//  SelectedFlightInfoVC.swift
//  BeeoonsApp
//
//  Created by MA673 on 18/08/22.
//

import UIKit

class SelectedFlightInfoVC: BaseTableVC {
    
    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var nav: NavBar!
    @IBOutlet weak var navHeight: NSLayoutConstraint!
    @IBOutlet weak var cvHolderView: UIView!
    @IBOutlet weak var itineraryCV: UICollectionView!
    
    
    static var newInstance: SelectedFlightInfoVC? {
        let storyboard = UIStoryboard(name: Storyboard.Main.name,
                                      bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: self.className()) as? SelectedFlightInfoVC
        return vc
    }
    var isVcFrom = String()
    var itineraryArray = ["Itinerary","Fare Breakdown","Fare Rules","Baggage Info"]
    var city = String()
    var date = String()
    var traveller = String()
    var tablerow = [TableRow]()
    var cellIndex = Int()
    var newString = "Tickets are Non-Refundable and Non-Transferable.\n\nName changes are not permitted.\n\nPlease ensure Passenger names provided are\n\nexactly as written on the passport.\n\nFlight date or routing change must be done\n\nprior to the originally scheduled flight.\n\nChanges are not allowed if the passenger is a NO-SHOW\n\nFlight date or routing change may incur change fee\n\nPlus Fare and tax difference.\n\nSome fares may not allow any changes.\n\nPer change will apply over and above airline fee.\n\nIt is your responsibility to ensure that you have\n\nAppropriate documents to travel\n\nPASSPORT MUST BE VALID FOR 6 MONTHS\n\nBEYOND THE INTENDED PERIOD OF STAY.\n\nAt any event, entry may be refused\\neven with a valid passport and/or visa.\n\nAdvance seat assignments, seating configurations\n\nFlight schedules, terminal, aircraft type may change\n\nwith or Without notice and are never guaranteed.\n\n assumes no responsibility for missed flights,\n\nmissed connections, flight delays, cancelled flights\n\nor denied boarding.\n\nIt is recommended to reconfirm your flight details\n\nwith airlines 24 hours prior to departure. "
    
    
    override func viewWillAppear(_ animated: Bool) {
       
        if screenHeight > 800 {
            navHeight.constant = 200
        }else {
            navHeight.constant = 160
        }
        
        
        cellIndex = Int(defaults.string(forKey: UserDefaultsKeys.itinerarySelectedIndex) ?? "0") ?? 0
        print("cellIndex \(cellIndex)")
        itineraryCV.selectItem(at: IndexPath(item: cellIndex, section: 0), animated: true, scrollPosition: .left)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    
    func setupUI() {
        cvHolderView.backgroundColor = .AppBtnColor
        holderView.backgroundColor = .AppBGcolor
        nav.titlelbl.text = ""
        nav.backBtn.addTarget(self, action: #selector(gotoBackScreen), for: .touchUpInside)
        nav.citylbl.isHidden = false
        nav.datelbl.isHidden = false
        nav.travellerlbl.isHidden = false
        nav.citylbl.text = "Dubai(DXB) - Kuwait(KWI)"
        nav.datelbl.text = "Thu, 26 Jul  Fri, 27 Jul"
        nav.travellerlbl.text = "1 Traveller , Economy"
        
        setupCV()
    }
    
    
    func setupCV() {
        let nib = UINib(nibName: "ItineraryCVCell", bundle: nil)
        itineraryCV.register(nib, forCellWithReuseIdentifier: "cell")
        itineraryCV.delegate = self
        itineraryCV.dataSource = self
        let layout = UICollectionViewFlowLayout()
        // layout.itemSize = CGSize(width: 100, height: 40)
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        itineraryCV.collectionViewLayout = layout
        itineraryCV.backgroundColor = .clear
        itineraryCV.layer.cornerRadius = 4
        itineraryCV.clipsToBounds = true
        itineraryCV.showsHorizontalScrollIndicator = false
        
        commonTableView.registerTVCells(["SearchFlightResultInfoTVCell","BookNowTVCell","EmptyTVCell","TitleLblTVCell","FareBreakdownTVCell","RadioButtonTVCell"])
        commonTableView.separatorStyle = .singleLine
        commonTableView.separatorColor = .AppLabelColor.withAlphaComponent(0.3)
        setupItineraryTVCells()
    }
    
    @objc func gotoBackScreen() {
        dismiss(animated: true)
    }
    
    func setupItineraryTVCells() {
        tablerow.removeAll()
        
        tablerow.append(TableRow(title:"IN-254",subTitle: "13:30",key:"flightinfo", text:"17:25", headerText: "Kuwait(KWI)", buttonTitle: "Dubai(DXB)", tempText: "04 hr 55min",cellType:.SearchFlightResultInfoTVCell, questionBase: "1 stop"))
        tablerow.append(TableRow(height:500,cellType:.EmptyTVCell))
        
        
        commonTVData = tablerow
        commonTableView.reloadData()
    }
    
    
    
    @objc func didTapOnBookNowBtn(_ sender:UIButton) {
        guard let vc = PayNowVC.newInstance.self else {return}
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true)
    }
    
    
    func setupFareBreakdownTVCells() {
        commonTableView.separatorColor = .clear
        tablerow.removeAll()
        
        tablerow.append(TableRow(cellType:.FareBreakdownTVCell))
        tablerow.append(TableRow(height:500,cellType:.EmptyTVCell))
        
        commonTVData = tablerow
        commonTableView.reloadData()
    }
    
    
    
    
    
    
    func setupFareRulesTVCells() {
        commonTableView.separatorColor = .clear
        tablerow.removeAll()
        
        tablerow.append(TableRow(title:"FARE RULES AND CANCELLATIONS",subTitle: "",cellType:.TitleLblTVCell))
        tablerow.append(TableRow(height:10,cellType:.EmptyTVCell))
        tablerow.append(TableRow(title:newString,subTitle: "",key: "faresub",cellType:.TitleLblTVCell))
        tablerow.append(TableRow(height:500,cellType:.EmptyTVCell))
        
        
        commonTVData = tablerow
        commonTableView.reloadData()
    }
    
    func setupBaggageInfoTVCells() {
        commonTableView.separatorColor = .clear
        tablerow.removeAll()
        
        tablerow.append(TableRow(title:"Baggage Information",subTitle: "",cellType:.TitleLblTVCell))
        tablerow.append(TableRow(title:"Cabin Baggage - 7KG",image: "b1",cellType:.RadioButtonTVCell))
        tablerow.append(TableRow(title:"Checked -In Baggage - 20 KG",image: "b2",cellType:.RadioButtonTVCell))
        tablerow.append(TableRow(height:500,cellType:.EmptyTVCell))
        
        
        commonTVData = tablerow
        commonTableView.reloadData()
    }
    
}



extension SelectedFlightInfoVC {
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        if isVcFrom != "PayNowVC" {
            let myFooter =  Bundle.main.loadNibNamed("BookNowTVCell", owner: self, options: nil)?.first as! BookNowTVCell
            myFooter.bookNowBtn.addTarget(self, action: #selector(didTapOnBookNowBtn(_:)), for: .touchUpInside)
            return myFooter
        }else {
            return UIView()
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 60
    }
}



extension SelectedFlightInfoVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itineraryArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var commonCell = UICollectionViewCell()
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? ItineraryCVCell {
            cell.titlelbl.text = itineraryArray[indexPath.row]
            if indexPath.row == 0 {
                cell.holderView.backgroundColor = .WhiteColor
                cell.titlelbl.textColor = .AppLabelColor
            }
            commonCell = cell
        }
        return commonCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? ItineraryCVCell {
            cell.holderView.backgroundColor = .WhiteColor
            cell.titlelbl.textColor = .AppLabelColor
            defaults.set(indexPath.row, forKey: UserDefaultsKeys.itinerarySelectedIndex)
            
            switch cell.titlelbl.text {
            case "Itinerary":
                setupItineraryTVCells()
                break
                
            case "Fare Breakdown":
                setupFareBreakdownTVCells()
                break
                
            case "Fare Rules":
                setupFareRulesTVCells()
                break
                
            case "Baggage Info":
                setupBaggageInfoTVCells()
                break
                
            default:
                break
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? ItineraryCVCell {
            cell.holderView.backgroundColor = .WhiteColor.withAlphaComponent(0.50)
            cell.titlelbl.textColor = .WhiteColor
        }
    }
    
    //MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: itineraryArray[indexPath.item].size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17)]).width + 25, height: 40)
    }
    
}
