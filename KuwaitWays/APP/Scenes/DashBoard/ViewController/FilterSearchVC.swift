//
//  FilterSearchVC.swift
//  BeeoonsApp
//
//  Created by MA673 on 19/08/22.
//

import UIKit

class FilterSearchVC: BaseTableVC {
    
    
    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var closeBtn: UIButton!
    
    
    static var newInstance: FilterSearchVC? {
        let storyboard = UIStoryboard(name: Storyboard.Main.name,
                                      bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: self.className()) as? FilterSearchVC
        return vc
    }
    
    var tablerow = [TableRow]()
    var pricesArray = ["Airline","Depart","Duration","Arrive"]
    var noOfStopsArray = ["0 Stop","1 Stop","2 Stop"]
    var departurnTimeArray = ["12 am - 6 am","06 am - 12 pm","12 pm - 06 pm","06 pm - 12 am"]
    var airlinesArray = ["EMIRATES AIRLINES(EK)","ETIHAD AIRWAYS(EY)","Flydubai(FZ)","GULF AIR(GF)"]
    
    
    var hpricesArray = ["Deal","Name"," Star"]
    var amenitiesArray = ["Wi-Fi","Breakfast","Parking","Swimming Pool"]
    var amenitiesArray1 = ["Others(379)","Others(379)"]
    var facilitiesArray = ["Air condition"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupUI()
        
    }
    
    
    func setupUI() {
        self.view.backgroundColor = .black.withAlphaComponent(0.5)
        holderView.backgroundColor = .clear
        closeBtn.setTitle("", for: .normal)
        
        commonTableView.registerTVCells(["EmptyTVCell","CheckBoxTVCell","SliderTVCell","ButtonTVCell","StarRatingTVCell"])
        if let tabSelected = defaults.string(forKey: UserDefaultsKeys.tabselect) {
            if tabSelected == "Flight" {
                setupTVCells()
            }else {
                setupHotelFilterTVCells()
            }
        }
    }
    

    func setupTVCells() {
        tablerow.removeAll()
        
        tablerow.append(TableRow(height:30,cellType:.EmptyTVCell))
        tablerow.append(TableRow(title:"Prices",data: pricesArray,cellType:.CheckBoxTVCell))
        tablerow.append(TableRow(title:"Prices",cellType:.SliderTVCell))
        tablerow.append(TableRow(title:"No. Of Stops",data: noOfStopsArray,cellType:.CheckBoxTVCell))
        tablerow.append(TableRow(title:"Outbound Departurn Time",key:"time", data: departurnTimeArray,cellType:.CheckBoxTVCell))
        tablerow.append(TableRow(title:"Inbound Departurn Time",key:"time", data: departurnTimeArray,cellType:.CheckBoxTVCell))
        tablerow.append(TableRow(title:"Airlines",data: airlinesArray,cellType:.CheckBoxTVCell))
        tablerow.append(TableRow(title:"Cancellations Type",data: airlinesArray,cellType:.CheckBoxTVCell))
        tablerow.append(TableRow(title:"Connecting Flights",data: airlinesArray,cellType:.CheckBoxTVCell))
        tablerow.append(TableRow(title:"Connecting Airports",data: airlinesArray,cellType:.CheckBoxTVCell))
        tablerow.append(TableRow(height:50,cellType:.EmptyTVCell))
        tablerow.append(TableRow(title:"Apply",key: "hotel",cellType:.ButtonTVCell))
        tablerow.append(TableRow(height:50,cellType:.EmptyTVCell))
        commonTVData = tablerow
        commonTableView.reloadData()
        
    }
    
    
    func setupHotelFilterTVCells() {
        tablerow.removeAll()
        
        tablerow.append(TableRow(height:30,cellType:.EmptyTVCell))
        tablerow.append(TableRow(title:"Prices",key: "hotel",data: hpricesArray,cellType:.CheckBoxTVCell))
        tablerow.append(TableRow(title:"Prices",key: "hotel",cellType:.SliderTVCell))
        tablerow.append(TableRow(title:"Star Rating",cellType:.StarRatingTVCell))
        tablerow.append(TableRow(title:"Amenities",key: "hotel",data: amenitiesArray,cellType:.CheckBoxTVCell))
        tablerow.append(TableRow(title:"Amenities",key: "hotel",data: amenitiesArray1,cellType:.CheckBoxTVCell))
        tablerow.append(TableRow(title:"Facilities",key: "hotel",data: facilitiesArray,cellType:.CheckBoxTVCell))
        tablerow.append(TableRow(height:50,cellType:.EmptyTVCell))
        tablerow.append(TableRow(title:"Apply",key: "hotel",cellType:.ButtonTVCell))
        tablerow.append(TableRow(height:50,cellType:.EmptyTVCell))


        commonTVData = tablerow
        commonTableView.reloadData()
        
    }
    
    
    override func didTapOnCheckBoxDropDownBtn(cell:CheckBoxTVCell){
        print("didTapOnCheckBoxDropDownBtn")
    }
    
    
    override func didTapOnShowMoreBtn(cell:CheckBoxTVCell){
        print("didTapOnShowMoreBtn")
    }
    
    
    override func btnAction(cell: ButtonTVCell) {
        print("btnAction")
    }
    
    
    
    override func didTapOnStarRatingCell(cell: StarRatingCVCell) {
        print(cell.titlelbl.text)
    }
    
    
    
    
    
    
    
    @IBAction func didTapOnCloseBtn(_ sender: Any) {
        dismiss(animated: true)
    }
}


extension FilterSearchVC {
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.3) {
            tableView.performBatchUpdates(nil)
        }
    }
    
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? CheckBoxTVCell {
            cell.hide()
        }else if let cell = tableView.cellForRow(at: indexPath) as? SliderTVCell {
            cell.hide()
        }
    }
    
    
    
}
