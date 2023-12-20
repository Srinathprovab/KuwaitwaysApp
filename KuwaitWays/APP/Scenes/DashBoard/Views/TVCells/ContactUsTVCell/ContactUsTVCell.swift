//
//  ContactUsTVCell.swift
//  KuwaitWays
//
//  Created by FCI on 20/12/23.
//

import UIKit

protocol ContactUsTVCellDelegate {
    func didTapOnMailBtnAction(cell:ContactUsTVCell)
    func didTapOnPhoneBtnAction(cell:ContactUsTVCell)
}

class ContactUsTVCell: TableViewCell {

    
    
    
    var delegate:ContactUsTVCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func didTaponMailBtnAction(_ sender: Any) {
        delegate?.didTapOnMailBtnAction(cell: self)
    }
    
    
    @IBAction func didTapOnPhoneBtnAction(_ sender: Any) {
        delegate?.didTapOnPhoneBtnAction(cell: self)
    }
}
