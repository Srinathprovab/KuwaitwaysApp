//
//  BookedTravelDetailsTVCell.swift
//  BabSafar
//
//  Created by MA673 on 26/07/22.
//

import UIKit

class BookedTravelDetailsTVCell: TableViewCell {
    
    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var labelsView: UIView!
    @IBOutlet weak var travellerNamelbl: UILabel!
    @IBOutlet weak var typelbl: UILabel!
    @IBOutlet weak var seatlbl: UILabel!
    @IBOutlet weak var ulView: UIView!
    @IBOutlet weak var adultDetailsTV: UITableView!
    @IBOutlet weak var tvHeight: NSLayoutConstraint!
    
    var cdeatils = [Customer_details]()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
        setupTV()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    override func updateUI() {
        
        if cdeatils.count > 3 {
            tvHeight.constant = CGFloat(vouchercustomerdetails.count * 35)
        }
        
        if cellInfo?.key == "hotel" {
            travellerNamelbl.text = "Guest Name"
            typelbl.text = "Type"
            seatlbl.text = "Room Type"
        }
        
        adultDetailsTV.reloadData()
    }
    
    func setupUI() {
        
        holderView.backgroundColor = .WhiteColor
        holderView.addCornerRadiusWithShadow(color: .clear, borderColor: .AppBorderColor, cornerRadius: 10)
        
        
        setupViews(v: labelsView, radius: 0, color: .WhiteColor)
        labelsView.layer.borderColor = UIColor.WhiteColor.cgColor
        ulView.backgroundColor = HexColor("#E6E8E7")
        setupLabels(lbl: travellerNamelbl, text: "Traveller Name", textcolor: HexColor("#5B5B5B"), font: .OpenSansRegular(size: 14))
        setupLabels(lbl: typelbl, text: "Type", textcolor: HexColor("#5B5B5B"), font: .OpenSansRegular(size: 14))
        setupLabels(lbl: seatlbl, text: "Passport No", textcolor: HexColor("#5B5B5B"), font: .OpenSansRegular(size: 14))
        
    }
    
    func setupTV() {
        adultDetailsTV.register(UINib(nibName: "BookedAdultDetailsTVCell", bundle: nil), forCellReuseIdentifier: "cell")
        adultDetailsTV.delegate = self
        adultDetailsTV.dataSource = self
        adultDetailsTV.tableFooterView = UIView()
        adultDetailsTV.showsHorizontalScrollIndicator = false
    }
    
    func setupViews(v:UIView,radius:CGFloat,color:UIColor) {
        v.backgroundColor = color
        v.layer.cornerRadius = radius
        v.clipsToBounds = true
        v.layer.borderWidth = 0.4
        v.layer.borderColor = UIColor.AppBorderColor.cgColor
    }
    
    func setupLabels(lbl:UILabel,text:String,textcolor:UIColor,font:UIFont) {
        lbl.text = text
        lbl.textColor = textcolor
        lbl.font = font
    }
    
}


extension BookedTravelDetailsTVCell:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vouchercustomerdetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var c = UITableViewCell()
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? BookedAdultDetailsTVCell {
            cell.selectionStyle = .none
            cell.travellerNamelbl.text = "\(vouchercustomerdetails[indexPath.row].first_name ?? "") \(vouchercustomerdetails[indexPath.row].last_name ?? "")"
            cell.typelbl.text = "\(vouchercustomerdetails[indexPath.row].passenger_type ?? "")"
            cell.seatlbl.text = "\(vouchercustomerdetails[indexPath.row].passport_number ?? "0000")"
            c = cell
        }
        return c
    }
    
    
    
}
