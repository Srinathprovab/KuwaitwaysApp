//
//  SearchFlightResultVC.swift
//  BeeoonsApp
//
//  Created by MA673 on 17/08/22.
//

import UIKit

class SearchFlightResultVC: BaseTableVC {
    
    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var nav: NavBar!
    @IBOutlet weak var navHeight: NSLayoutConstraint!
    @IBOutlet weak var cvHolderView: UIView!
    @IBOutlet weak var baggageBtn: UIButton!
    @IBOutlet weak var baggageDateCV: UICollectionView!
    @IBOutlet weak var baggageImg: UIImageView!
    
    @IBOutlet weak var sessonlbl: UILabel!
    @IBOutlet weak var flightsFoundlbl: UILabel!
    
    static var newInstance: SearchFlightResultVC? {
        let storyboard = UIStoryboard(name: Storyboard.Main.name,
                                      bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: self.className()) as? SearchFlightResultVC
        return vc
    }
    var tablerow = [TableRow]()
    override func viewWillAppear(_ animated: Bool) {
       
        if screenHeight > 800 {
            navHeight.constant = 200
        }else {
            navHeight.constant = 160
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    
    func setupUI() {
        
        holderView.backgroundColor = .AppBGcolor
        nav.titlelbl.text = "Search Result"
        nav.backBtn.addTarget(self, action: #selector(gotoBackScreen), for: .touchUpInside)
        nav.citylbl.isHidden = false
        nav.datelbl.isHidden = false
        nav.travellerlbl.isHidden = false
        nav.citylbl.text = "Dubai(DXB) - Kuwait(KWI)"
        nav.datelbl.text = "Thu, 26 Jul  Fri, 27 Jul"
        nav.travellerlbl.text = "1 Traveller , Economy"
        nav.filterView.isHidden = false
        nav.editView.isHidden = false
        nav.filterBtn.addTarget(self, action: #selector(didTapOnFilterSearchFlight(_:)), for: .touchUpInside)
        nav.editBtn.addTarget(self, action: #selector(didTapOnEditSearchFlight(_:)), for: .touchUpInside)
        
        sessonlbl.text = "Your Session Expires In: 14:15"
        sessonlbl.textColor = .AppLabelColor
        sessonlbl.font = UIFont.OpenSansRegular(size: 12)
        
        flightsFoundlbl.text = "25 Flights found"
        flightsFoundlbl.textColor = .AppLabelColor
        flightsFoundlbl.font = UIFont.OpenSansRegular(size: 12)
        
        cvHolderView.backgroundColor = .AppBackgroundColor
        cvHolderView.addBottomBorderWithColor(color: .AppBorderColor, width: 0.5)
        baggageBtn.setTitle("", for: .normal)
        setupCV()
    }
    
    
    func setupCV() {
        baggageDateCV.backgroundColor = .AppBackgroundColor
        let nib = UINib(nibName: "BaggageDateCVCell", bundle: nil)
        baggageDateCV.register(nib, forCellWithReuseIdentifier: "cell")
        baggageDateCV.delegate = self
        baggageDateCV.dataSource = self
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 80, height: 50)
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        baggageDateCV.collectionViewLayout = layout
        baggageDateCV.backgroundColor = .clear
        baggageDateCV.layer.cornerRadius = 4
        baggageDateCV.clipsToBounds = true
        baggageDateCV.showsHorizontalScrollIndicator = false
        
        commonTableView.registerTVCells(["SearchFlightResultInfoTVCell","EmptyTVCell"])
        commonTableView.separatorStyle = .singleLine
        commonTableView.separatorColor = .AppLabelColor.withAlphaComponent(0.3)
        
        
        if let selectedJourntType = defaults.string(forKey: UserDefaultsKeys.journeyType) {
            if selectedJourntType == "One Way" {
                setupOneWayTVCells()
            }else if selectedJourntType == "Round Trip" {
                setupRoundTripTVCells()
            }else {
                setupOneWayTVCells()
            }
        }
    }
    
    @objc func gotoBackScreen() {
        guard let vc = BookFlightVC.newInstance.self else {return}
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false)
    }
    
    func setupOneWayTVCells() {
        tablerow.removeAll()
        
        tablerow.append(TableRow(title:"IN-254",subTitle: "13:30",text:"17:25", headerText: "Kuwait(KWI)", buttonTitle: "Dubai(DXB)", tempText: "04 hr 55min",cellType:.SearchFlightResultInfoTVCell, questionBase: "1 stop"))
        
        tablerow.append(TableRow(title:"IN-254",subTitle: "13:30",text:"17:25", headerText: "Kuwait(KWI)", buttonTitle: "Dubai(DXB)", tempText: "04 hr 55min",cellType:.SearchFlightResultInfoTVCell, questionBase: "1 stop"))
        
        tablerow.append(TableRow(title:"IN-254",subTitle: "13:30",text:"17:25", headerText: "Kuwait(KWI)", buttonTitle: "Dubai(DXB)", tempText: "04 hr 55min",cellType:.SearchFlightResultInfoTVCell, questionBase: "1 stop"))
        
        tablerow.append(TableRow(title:"IN-254",subTitle: "13:30",text:"17:25", headerText: "Kuwait(KWI)", buttonTitle: "Dubai(DXB)", tempText: "04 hr 55min",cellType:.SearchFlightResultInfoTVCell, questionBase: "1 stop"))
        
        tablerow.append(TableRow(title:"IN-254",subTitle: "13:30",text:"17:25", headerText: "Kuwait(KWI)", buttonTitle: "Dubai(DXB)", tempText: "04 hr 55min",cellType:.SearchFlightResultInfoTVCell, questionBase: "1 stop"))
        
        tablerow.append(TableRow(title:"IN-254",subTitle: "13:30",text:"17:25", headerText: "Kuwait(KWI)", buttonTitle: "Dubai(DXB)", tempText: "04 hr 55min",cellType:.SearchFlightResultInfoTVCell, questionBase: "1 stop"))
        
        tablerow.append(TableRow(title:"IN-254",subTitle: "13:30",text:"17:25", headerText: "Kuwait(KWI)", buttonTitle: "Dubai(DXB)", tempText: "04 hr 55min",cellType:.SearchFlightResultInfoTVCell, questionBase: "1 stop"))
        
        
        tablerow.append(TableRow(height:50,cellType:.EmptyTVCell))
        commonTVData = tablerow
        commonTableView.reloadData()
    }
    
    
    
    
    func setupRoundTripTVCells() {
        commonTableView.separatorStyle = .none
        tablerow.removeAll()
        
        tablerow.append(TableRow(title:"IN-254",subTitle: "13:30",text:"17:25", headerText: "Kuwait(KWI)", buttonTitle: "Dubai(DXB)", key1: "roundtrip", tempText: "04 hr 55min",cellType:.SearchFlightResultInfoTVCell, questionBase: "1 stop"))
        
        
        tablerow.append(TableRow(title:"IN-254",subTitle: "13:30",text:"17:25", headerText: "Kuwait(KWI)", buttonTitle: "Dubai(DXB)", key1: "roundtrip", tempText: "04 hr 55min",cellType:.SearchFlightResultInfoTVCell, questionBase: "1 stop"))
        
        tablerow.append(TableRow(height:50,cellType:.EmptyTVCell))
        
        commonTVData = tablerow
        commonTableView.reloadData()
    }
    
    
    
    
    override func didTapOnRefunduableBtn(cell: SearchFlightResultInfoTVCell) {
        print("didTapOnRefunduableBtn")
    }
    
    
    @objc func didTapOnEditSearchFlight(_ sender:UIButton) {
        guard let vc = BookFlightVC.newInstance.self else {return}
        vc.modalPresentationStyle = .overCurrentContext
        vc.isVcFrom = "modify"
        self.present(vc, animated: false)
    }
    
    @objc func didTapOnFilterSearchFlight(_ sender:UIButton) {
        guard let vc = FilterSearchVC.newInstance.self else {return}
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: false)
    }
    
    
    func goToFlightInfoVC() {
        guard let vc = SelectedFlightInfoVC.newInstance.self else {return}
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false)
    }
    
}


extension SearchFlightResultVC:UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var commonCell = UICollectionViewCell()
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? BaggageDateCVCell {
            cell.titlelbl.text = "26 jul"
            cell.subTitlelbl.text = "kwd: 150.00"
            cell.holderView.backgroundColor = .clear
            
            commonCell = cell
        }
        return commonCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? BaggageDateCVCell {
            cell.holderView.backgroundColor = .AppJournyTabSelectColor
            cell.lineView.backgroundColor = .clear
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? BaggageDateCVCell {
            cell.holderView.backgroundColor = .AppBackgroundColor
            cell.lineView.backgroundColor = .WhiteColor
        }
    }
    
}


extension SearchFlightResultVC {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? SearchFlightResultInfoTVCell {
            goToFlightInfoVC()
        }
    }
}
