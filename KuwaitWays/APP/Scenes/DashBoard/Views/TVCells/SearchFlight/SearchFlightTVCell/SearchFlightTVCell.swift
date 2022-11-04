//
//  SearchFlightTVCell.swift
//  BeeoonsApp
//
//  Created by MA673 on 17/08/22.
//

import UIKit
protocol SearchFlightTVCellDelegate {
    func didTapOnFromCity(cell:HolderViewTVCell)
    func didTapOnToCity(cell:HolderViewTVCell)
    func didTapOnSelectDepDateBtn(cell:DualViewTVCell)
    func didTapOnSelectRepDateBtn(cell:DualViewTVCell)
    func didTapOnAddTravelerEconomy(cell:HolderViewTVCell)
    func didTapOnSearchFlightsBtn(cell:SearchFlightTVCell)
    
    
    
    func didTapOnLocationOrCityBtn(cell:HolderViewTVCell)
    func didtapOnCheckInBtn(cell:DualViewTVCell)
    func didtapOnCheckOutBtn(cell:DualViewTVCell)
    func didTapOnSearchHotelsBtn(cell:ButtonTVCell)
    
}

class SearchFlightTVCell: TableViewCell,DualViewTVCellDelegate,ButtonTVCellDelegate {
    
    
    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var searchFlightTV: UITableView!
    
    
    var key = String()
    var delegate:SearchFlightTVCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupTV()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func updateUI() {
        self.key = cellInfo?.key ?? ""
        searchFlightTV.reloadData()
    }
    
    
    func setupTV() {
        holderView.backgroundColor = .AppBGcolor
        searchFlightTV.layer.cornerRadius = 10
        searchFlightTV.clipsToBounds = true
        searchFlightTV.backgroundColor = .AppBGColor
        searchFlightTV.register(UINib(nibName: "HolderViewTVCell", bundle: nil), forCellReuseIdentifier: "cell")
        searchFlightTV.register(UINib(nibName: "HolderViewTVCell", bundle: nil), forCellReuseIdentifier: "cell1")
        searchFlightTV.register(UINib(nibName: "DualViewTVCell", bundle: nil), forCellReuseIdentifier: "cell2")
        searchFlightTV.register(UINib(nibName: "HolderViewTVCell", bundle: nil), forCellReuseIdentifier: "cell3")
        searchFlightTV.register(UINib(nibName: "ButtonTVCell", bundle: nil), forCellReuseIdentifier: "cell4")
        searchFlightTV.separatorStyle = .none
        searchFlightTV.delegate = self
        searchFlightTV.dataSource = self
        searchFlightTV.tableFooterView = UIView()
        searchFlightTV.showsHorizontalScrollIndicator = false
        searchFlightTV.isScrollEnabled = false
    }
    
    func didTapOnSelectDepDateBtn(cell: DualViewTVCell) {
        delegate?.didTapOnSelectDepDateBtn(cell: cell)
    }
    
    func didTapOnSelectRepDateBtn(cell: DualViewTVCell) {
        delegate?.didTapOnSelectRepDateBtn(cell: cell)
    }
    
    
    @objc func didTapOnFromCity(cell:HolderViewTVCell){
        delegate?.didTapOnFromCity(cell: cell)
    }
    @objc func didTapOnToCity(cell:HolderViewTVCell){
        delegate?.didTapOnToCity(cell: cell)
    }
    
    
    
    func btnAction(cell: ButtonTVCell) {
        delegate?.didTapOnSearchFlightsBtn(cell: self)
    }
    
    
    
    
    @objc func didTapOnLocationOrCityBtn(cell:HolderViewTVCell){
        delegate?.didTapOnLocationOrCityBtn(cell: cell)
    }
    
    @objc func didtapOnCheckInBtn(cell:DualViewTVCell){
        delegate?.didtapOnCheckInBtn(cell: cell)
    }
    
    @objc func didtapOnCheckOutBtn(cell:DualViewTVCell){
        delegate?.didtapOnCheckOutBtn(cell: cell)
    }
    
    @objc func didTapOnAddTravelerEconomy(cell:HolderViewTVCell){
        delegate?.didTapOnAddTravelerEconomy(cell: cell)
    }
    
    
    @objc func didTapOnSearchHotelsBtn(cell:ButtonTVCell){
        delegate?.didTapOnSearchHotelsBtn(cell: cell)
    }
    
    
}


extension SearchFlightTVCell:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var c = UITableViewCell()
        
        
        if self.key == "hotel" {
            if indexPath.row == 0 {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? HolderViewTVCell {
                    cell.titlelbl.text = "\(defaults.string(forKey: UserDefaultsKeys.locationcity) ?? "city/location")"
                    cell.locImg.image = UIImage(named: "loc")
                    cell.dropdownimg.isHidden = true
                    cell.fromBtn.addTarget(self, action: #selector(didTapOnLocationOrCityBtn(cell:)), for: .touchUpInside)
                    cell.tag = 1
                    c = cell
                }
            }else  if indexPath.row == 1 {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "cell2") as? DualViewTVCell {
                    cell.delegate = self
                    cell.deplbl.text = defaults.string(forKey: UserDefaultsKeys.checkin) ?? "Check In"
                    cell.returnlbl.text = defaults.string(forKey: UserDefaultsKeys.checkout) ?? "Check Out"
                    cell.depBtn.addTarget(self, action: #selector(didtapOnCheckInBtn(cell:)), for: .touchUpInside)
                    cell.returnBtn.addTarget(self, action: #selector(didtapOnCheckOutBtn(cell:)), for: .touchUpInside)

                    cell.showReturnView()
                    c = cell
                }
            }else  if indexPath.row == 2 {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "cell3") as? HolderViewTVCell {
                    cell.titlelbl.text = "\(defaults.string(forKey: UserDefaultsKeys.hadultCount) ?? "+ Add Traveller") traveller ) "
                    defaults.set(cell.titlelbl.text, forKey: UserDefaultsKeys.htravellerDetails)
                    cell.locImg.image = UIImage(named: "traveler")
                    cell.dropdownimg.isHidden = false
                    cell.fromBtn.addTarget(self, action: #selector(didTapOnAddTravelerEconomy(cell:)), for: .touchUpInside)
                    cell.tag = 3
                    c = cell
                }
            }else {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "cell4") as? ButtonTVCell {
                    cell.titlelbl.text = "Search Flights"
                    cell.holderView.backgroundColor = .AppBGColor
                    cell.btnLeftConstraint.constant = 16
                    cell.delegate = self
                    cell.btn.addTarget(self, action: #selector(didTapOnSearchHotelsBtn(cell:)), for: .touchUpInside)
                    c = cell
                }
            }
            
        }else {
            
            if indexPath.row == 0 {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? HolderViewTVCell {
                    cell.titlelbl.text = defaults.string(forKey: UserDefaultsKeys.fromCity) ?? "From"
                    cell.tolabel.text = defaults.string(forKey: UserDefaultsKeys.toCity) ?? "To"
                    cell.locImg.image = UIImage(named: "loc")?.withRenderingMode(.alwaysOriginal).withTintColor(.AppJournyTabSelectColor)
                    cell.toView.isHidden = false
                    cell.swipeView.isHidden = false
                    cell.fromBtn.addTarget(self, action: #selector(didTapOnFromCity(cell:)), for: .touchUpInside)
                    cell.toBtn.addTarget(self, action: #selector(didTapOnToCity(cell:)), for: .touchUpInside)
                    
                    cell.tag = 1
                    c = cell
                }
            }else  if indexPath.row == 1 {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "cell2") as? DualViewTVCell {
                    cell.delegate = self
                    cell.hideRetView()
                    if self.key == "roundtrip" {
                        cell.showReturnView()
                        cell.deplbl.text = defaults.string(forKey: UserDefaultsKeys.rcalDepDate) ?? "Select Date"
                        cell.returnlbl.text = defaults.string(forKey: UserDefaultsKeys.rcalRetDate) ?? "Select Date"
                    }else {
                        cell.deplbl.text = defaults.string(forKey: UserDefaultsKeys.calDepDate) ?? "Select Date"
                        cell.returnlbl.text = defaults.string(forKey: UserDefaultsKeys.calRetDate) ?? "Select Date"
                    }
                    
                    c = cell
                }
            }else  if indexPath.row == 2 {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "cell3") as? HolderViewTVCell {
                    cell.titlelbl.text = "\(defaults.string(forKey: UserDefaultsKeys.adultCount) ?? "+ Add Traveller") traveller - \(defaults.string(forKey: UserDefaultsKeys.selectClass) ?? "") "
                    
                    cell.locImg.image = UIImage(named: "traveler")?.withRenderingMode(.alwaysOriginal).withTintColor(.AppJournyTabSelectColor)
                    cell.dropdownimg.isHidden = false
                    cell.fromBtn.addTarget(self, action: #selector(didTapOnAddTravelerEconomy(cell:)), for: .touchUpInside)
                    cell.tag = 3
                    
                    if self.key == "roundtrip" {
                        defaults.set(cell.titlelbl.text, forKey: UserDefaultsKeys.rtravellerDetails)
                    }else {
                        defaults.set(cell.titlelbl.text, forKey: UserDefaultsKeys.travellerDetails)
                    }
                    
                    c = cell
                }
            }else {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "cell4") as? ButtonTVCell {
                    cell.titlelbl.text = "Search Flights"
                    cell.holderView.backgroundColor = .AppBGColor
                    cell.btnLeftConstraint.constant = 16
                    cell.delegate = self
                    c = cell
                }
            }
        }
        return c
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? HolderViewTVCell {
            switch cell.tag {
            case 1:
                delegate?.didTapOnFromCity(cell: cell)
                break
                
            case 2:
                delegate?.didTapOnToCity(cell: cell)
                break
                
            case 3:
                delegate?.didTapOnAddTravelerEconomy(cell: cell)
                break
                
            default:
                break
            }
        }
    }
    
    
    
}
