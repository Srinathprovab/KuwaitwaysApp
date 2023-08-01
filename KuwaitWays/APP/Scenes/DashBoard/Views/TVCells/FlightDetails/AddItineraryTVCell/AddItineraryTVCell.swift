//
//  AddItineraryTVCell.swift
//  QBBYTravelApp
//
//  Created by FCI on 10/01/23.
//

import UIKit
import SDWebImage


class AddItineraryTVCell: TableViewCell {
    
    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var addDetailsTv: UITableView!
    @IBOutlet weak var tvHeight: NSLayoutConstraint!
    
    var fd = [FlightDetails]()
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
        
        fd = cellInfo?.moreData as! [FlightDetails]
        updateHeight(height: 170)
    }
    
    func updateHeight(height:Int){
        tvHeight.constant = CGFloat(fd.count * height)
        addDetailsTv.reloadData()
    }
    
    
    func setupTV() {
        
        contentView.backgroundColor = .AppHolderViewColor
        holderView.backgroundColor = .WhiteColor
        holderView.addCornerRadiusWithShadow(color: .clear, borderColor: .AppBorderColor, cornerRadius: 6)
        
        addDetailsTv.register(UINib(nibName: "ItineraryTVCell", bundle: nil), forCellReuseIdentifier: "cell")
        addDetailsTv.delegate = self
        addDetailsTv.dataSource = self
        addDetailsTv.tableFooterView = UIView()
        addDetailsTv.showsHorizontalScrollIndicator = false
        addDetailsTv.separatorStyle = .none
        addDetailsTv.isScrollEnabled = false
    }
    
}

extension AddItineraryTVCell:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fd.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var c = UITableViewCell()
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? ItineraryTVCell {
            cell.selectionStyle = .none
            
            let data = fd[indexPath.row]
            cell.inNolbl.text = "\(data.operator_code ?? "")-\(data.flight_number ?? "")"
            cell.airlinecodelbl.text = data.operator_name
            
            cell.fromCityTimelbl.text = data.origin?.time
            cell.fromCityNamelbl.text = "\(data.origin?.city ?? "")(\(data.origin?.loc ?? ""))"
            cell.fromCityDatelbl.text = data.origin?.date
            
            cell.toCityTimelbl.text =  data.destination?.time
            cell.toCityNamelbl.text = "\(data.destination?.city ?? "")(\(data.destination?.loc ?? ""))"
            cell.toCityDatelbl.text = data.destination?.date
            
            cell.hourslbl.text = data.duration
            cell.noOfStopslbl.text = "\(data.no_of_stops ?? 0) stop"
            cell.layoverCitylbl.text = "Layover duration \(data.destination?.city ?? "")(\(data.destination?.loc ?? "")) TIME \(data.layOverDuration ?? "")"
            
            
            cell.logoImg.sd_setImage(with: URL(string: data.operator_image ?? ""), placeholderImage:UIImage(contentsOfFile:"placeholder.png"))

        
            switch data.no_of_stops {
            case 0:
                cell.round1.isHidden = true
                cell.round2.isHidden = true
                cell.round3.isHidden = true
                break
                
            case 1:
                cell.round1.isHidden = false
                cell.round2.isHidden = true
                cell.round3.isHidden = true
                break
                
            case 2:
                cell.round1.isHidden = false
                cell.round2.isHidden = false
                cell.round3.isHidden = true
                break
                
                
            default:
                break
            }
            
            //cell.layoverHeight.constant = 25
            if tableView.isLast(for: indexPath) == true {
                cell.layoverView.isHidden = true
                cell.layoverHeight.constant = 0
            }
            
            c = cell
        }
        return c
    }
    
    
    
}


extension UITableView {
    func isLastVisibleCell(at indexPath: IndexPath) -> Bool {
        guard let lastIndexPath = indexPathsForVisibleRows?.last else {
            return false
        }
        return lastIndexPath == indexPath
    }
}
