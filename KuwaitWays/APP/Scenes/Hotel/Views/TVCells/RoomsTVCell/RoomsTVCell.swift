//
//  RoomsTVCell.swift
//  BeeoonsApp
//
//  Created by MA673 on 22/08/22.
//

import UIKit
protocol RoomsTVCellDelegate {
    func didTapOnCancellationPolicyBtn(cell:TwinSuperiorRoomTVCell)
}

class RoomsTVCell: TableViewCell {
    
    @IBOutlet weak var titlelbl: UILabel!
    @IBOutlet weak var roomsTV: UITableView!
    
    
    var delegate:RoomsTVCellDelegate?
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
        titlelbl.text = cellInfo?.title
    }
    
    
    
    func setupTV() {
        roomsTV.register(UINib(nibName: "TwinSuperiorRoomTVCell", bundle: nil), forCellReuseIdentifier: "cell")
        roomsTV.delegate = self
        roomsTV.dataSource = self
        roomsTV.tableFooterView = UIView()
        roomsTV.separatorStyle = .none
        roomsTV.backgroundColor = .WhiteColor
        roomsTV.isScrollEnabled = false
        roomsTV.layer.cornerRadius = 6
        roomsTV.clipsToBounds = true
        roomsTV.layer.borderWidth = 1
        roomsTV.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
    }
    
    @objc func didTapOnCancellationPolicyBtn(cell:TwinSuperiorRoomTVCell) {
        delegate?.didTapOnCancellationPolicyBtn(cell: cell)
    }
}



extension RoomsTVCell:UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var c = UITableViewCell()
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? TwinSuperiorRoomTVCell {
            cell.selectionStyle = .none
            cell.cancellationPoloicyBtn.addTarget(self, action: #selector(didTapOnCancellationPolicyBtn(cell:)), for: .touchUpInside)
            
            if indexPath.row == 1 {
                cell.kwdlbl.text = "OMR"
                cell.kwdPricelbl.text = "210.00"
                cell.ulView.isHidden = true
            }
            c = cell
        }
        return c
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? TwinSuperiorRoomTVCell {
            cell.radioImg.image = UIImage(named: "radioSelected")?.withRenderingMode(.alwaysOriginal).withTintColor(.AppBackgroundColor)
            defaults.set(cell.titlelbl.text, forKey: UserDefaultsKeys.roomType)
        }
    }
    
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? TwinSuperiorRoomTVCell {
            cell.radioImg.image = UIImage(named: "radioUnselected")?.withRenderingMode(.alwaysOriginal).withTintColor(.AppBackgroundColor)
        }
    }
    
}
