//
//  AddCityTVCell.swift
//  BeeoonsApp
//
//  Created by MA673 on 19/08/22.
//

import UIKit

protocol AddCityTVCellDelegate {
    
    func didTapOnFromBtn(cell:MulticityFromToTVCell)
    func didTapOnToBtn(cell:MulticityFromToTVCell)
    func didTapOndateBtn(cell:MulticityFromToTVCell)
    func didTapOnCloseBtn(cell:MulticityFromToTVCell)
}

class AddCityTVCell: UITableViewCell, MulticityFromToTVCellDelegate {
    
    
    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var addCityTV: UITableView!
    @IBOutlet weak var addCityTVHeight: NSLayoutConstraint!
    @IBOutlet weak var addCityBtn: UIButton!
    
    var delegate:AddCityTVCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    func setupUI() {
        holderView.backgroundColor = .AppBGColor
        addCityTVHeight.constant = 130
        addCityBtn.setTitle("+ Add City", for: .normal)
        addCityBtn.setTitleColor(.AppBtnColor, for: .normal)
        setupTV()
    }
    
    func setupTV() {
        addCityTV.register(UINib(nibName: "MulticityFromToTVCell", bundle: nil), forCellReuseIdentifier: "cell")
        addCityTV.delegate = self
        addCityTV.dataSource = self
        addCityTV.tableFooterView = UIView()
        addCityTV.separatorStyle = .none
        addCityTV.backgroundColor = .AppBGColor
    }
    
    
    func didTapOnFromBtn(cell: MulticityFromToTVCell) {
        delegate?.didTapOnFromBtn(cell: cell)
    }
    
    func didTapOnToBtn(cell: MulticityFromToTVCell) {
        delegate?.didTapOnToBtn(cell: cell)
    }
    
    func didTapOndateBtn(cell: MulticityFromToTVCell) {
        delegate?.didTapOndateBtn(cell: cell)
    }
    
    func didTapOnCloseBtn(cell: MulticityFromToTVCell) {
        delegate?.didTapOnCloseBtn(cell: cell)
    }
    
    @IBAction func didTapOnAddCityBtn(_ sender: Any) {
        print("didTapOnAddCityBtn")
    }
    
    
    
}


extension AddCityTVCell:UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var c = UITableViewCell()
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? MulticityFromToTVCell {
            cell.selectionStyle = .none
            cell.delegate = self
            cell.fromlbl.text = "\(defaults.string(forKey: UserDefaultsKeys.mfromCity) ?? "From")"
            cell.tolbl.text = "\(defaults.string(forKey: UserDefaultsKeys.mtoCity) ?? "To")"
            cell.datelbl.text = "\(defaults.string(forKey: UserDefaultsKeys.mcalDepDate) ?? "Date")"
            if indexPath.row == 0 {
                cell.closeView.isHidden = true
            }
            c = cell
        }
        return c
    }
    
    
}
