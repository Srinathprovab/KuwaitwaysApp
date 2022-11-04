//
//  TitleLblTVCell.swift
//  BeeoonsApp
//
//  Created by MA673 on 17/08/22.
//

import UIKit
protocol TitleLblTVCellDelegate {
    func didTapOnEditBtn(cell:TitleLblTVCell)
}

class TitleLblTVCell: TableViewCell {
    
    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var titlelbl: UILabel!
    @IBOutlet weak var subtitlelbl: UILabel!
    @IBOutlet weak var editView: UIView!
    @IBOutlet weak var editlbl: UILabel!
    @IBOutlet weak var editImg: UIImageView!
    @IBOutlet weak var editBtn: UIButton!
    
    
    var delegate:TitleLblTVCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        holderView.backgroundColor = .WhiteColor
        titlelbl.textColor = .AppLabelColor
        titlelbl.font = UIFont.OpenSansRegular(size: 16)
        titlelbl.numberOfLines = 0
        
        subtitlelbl.textColor = .AppLabelColor
        subtitlelbl.font = UIFont.OpenSansMedium(size: 16)
        subtitlelbl.isHidden = true
        
        editView.isHidden = true
        editView.backgroundColor = .clear
        editlbl.textColor = .AppLabelColor
        editlbl.font = UIFont.OpenSansMedium(size: 16)
        editImg.image = UIImage(named: "edit1")
        editBtn.setTitle("", for: .normal)
        
        
    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func updateUI() {
        titlelbl.text = cellInfo?.title
        subtitlelbl.text = cellInfo?.subTitle
        
        if cellInfo?.key == "faresub" {
            titlelbl.font = .OpenSansRegular(size: 12)
        }
    }
    
    
    func tripcost() {
        subtitlelbl.isHidden = false
        titlelbl.textColor = .WhiteColor
        subtitlelbl.textColor = .WhiteColor
        holderView.backgroundColor = .AppBtnColor
    }
    
    func fare() {
        subtitlelbl.isHidden = false
        titlelbl.textColor = .AppSubtitleColor
    }
    
    
    @IBAction func didTapOnEditBtn(_ sender: Any) {
        delegate?.didTapOnEditBtn(cell: self)
    }
    
    
}
