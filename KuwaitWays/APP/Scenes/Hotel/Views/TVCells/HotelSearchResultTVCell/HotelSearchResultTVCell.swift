//
//  HotelSearchResultTVCell.swift
//  BeeoonsApp
//
//  Created by MA673 on 22/08/22.
//

import UIKit
import AARatingBar

protocol HotelSearchResultTVCellDelegate {
    func didTapOnDetailsBtn(cell:HotelSearchResultTVCell)
}

class HotelSearchResultTVCell: TableViewCell {
    
    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var kwdlblView: UIView!
    @IBOutlet weak var kwdlbl: UILabel!
    @IBOutlet weak var detailsBtn: UIButton!
    @IBOutlet weak var hotelImg: UIImageView!
    @IBOutlet weak var titlelbl: UILabel!
    @IBOutlet weak var subtitlelbl: UILabel!
    @IBOutlet weak var ratingView: AARatingBar!
    @IBOutlet weak var detailslbl: UILabel!

    var delegate:HotelSearchResultTVCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func updateUI() {
        titlelbl.text = cellInfo?.title
        subtitlelbl.text = cellInfo?.subTitle
        hotelImg.image = UIImage(named: cellInfo?.image ?? "")
        ratingView.value = CGFloat(cellInfo?.characterLimit ?? 0)
    }
    
    
    func setupUI() {
        setupViews(v: holderView, radius: 6, color: .WhiteColor)
        kwdlblView.backgroundColor = .AppBtnColor
        setupLabels(lbl: kwdlbl, text: "KWD:120.00", textcolor: .WhiteColor, font: .OswaldSemiBold(size: 16))
        detailsBtn.setTitle("", for: .normal)
        detailsBtn.setTitleColor(.WhiteColor, for: .normal)
        detailsBtn.titleLabel?.font = UIFont.oswaldRegular(size: 16)
        detailsBtn.addTarget(self, action: #selector(didTapOnDetailsBtn(_:)), for: .touchUpInside)
        
        setupLabels(lbl: titlelbl, text: "", textcolor: .AppLabelColor, font: .OpenSansMedium(size: 16))
        titlelbl.numberOfLines = 0
        setupLabels(lbl: subtitlelbl, text: "", textcolor: .AppSubtitleColor, font: .OpenSansMedium(size: 12))
        setupLabels(lbl: detailslbl, text: "Details", textcolor: .WhiteColor, font: .OswaldSemiBold(size: 16))

        subtitlelbl.numberOfLines = 0
        
        hotelImg.contentMode = .scaleToFill
        ratingView.maxValue = 5
        ratingView.color = HexColor("#FABF35")
        
        
    }
    
    @objc func didTapOnDetailsBtn(_ sender:UIButton) {
        delegate?.didTapOnDetailsBtn(cell: self)
    }
    
    func setupLabels(lbl:UILabel,text:String,textcolor:UIColor,font:UIFont) {
        lbl.text = text
        lbl.textColor = textcolor
        lbl.font = font
    }
    
    func setupViews(v:UIView,radius:CGFloat,color:UIColor) {
        v.backgroundColor = color
        v.layer.cornerRadius = radius
        v.clipsToBounds = true
        v.layer.borderWidth = 0.5
        v.layer.borderColor = UIColor.AppBorderColor.cgColor
    }
    
}
