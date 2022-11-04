//
//  PriceSummaryTVCell.swift
//  BabSafar
//
//  Created by MA673 on 25/07/22.
//

import UIKit

protocol PriceSummaryTVCellDelegate {
    func didTapOnRefundBtn(cell:PriceSummaryTVCell)
}

class PriceSummaryTVCell: TableViewCell {
    
    
    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var titlelbl: UILabel!
    @IBOutlet weak var fareTypelbl: UILabel!
    @IBOutlet weak var refundBtn: UIButton!
    @IBOutlet weak var baseFarelbl: UILabel!
    @IBOutlet weak var baseFareValuelbl: UILabel!
    @IBOutlet weak var taxeslbl: UILabel!
    @IBOutlet weak var taxesValuelbl: UILabel!
    @IBOutlet weak var tripCostlbl: UILabel!
    @IBOutlet weak var tripCostValuelbl: UILabel!
    
    
    var delegate:PriceSummaryTVCellDelegate?
    var key = String()
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
        
    }
    
    func setupUI(){
        contentView.backgroundColor = .AppBorderColor
        setupViews(v: holderView, radius: 0, color: .WhiteColor)
        setupLabels(lbl: titlelbl, text: "Purchase Summary", textcolor: .AppLabelColor, font: .OpenSansMedium(size: 18))
        setupLabels(lbl: fareTypelbl, text: "fare type", textcolor: .AppSubtitleColor, font: .OpenSansRegular(size: 16))
        setupLabels(lbl: baseFarelbl, text: "Base Fare", textcolor: .AppSubtitleColor, font: .OpenSansRegular(size: 16))
        setupLabels(lbl: taxeslbl, text: "Taxes& Fees", textcolor: .AppSubtitleColor, font: .OpenSansRegular(size: 16))
        setupLabels(lbl: baseFareValuelbl, text: "KWD:130.00", textcolor: .AppLabelColor, font: .oswaldRegular(size: 16))
        setupLabels(lbl: taxesValuelbl, text: "KWD:20.00", textcolor: .AppLabelColor, font: .oswaldRegular(size: 16))
        setupLabels(lbl: tripCostlbl, text: "TOtal trip cost", textcolor: .AppLabelColor, font: .poppinsRegular(size: 14))
        setupLabels(lbl: tripCostValuelbl, text: "KWD:150.00", textcolor: .AppLabelColor, font: .oswaldRegular(size: 16))

        refundBtn.setTitle("Refundudable", for: .normal)
        refundBtn.setTitleColor(HexColor("#35CB00"), for: .normal)
        refundBtn.titleLabel?.font = .OpenSansMedium(size: 12)
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
    
    
    @IBAction func didTapOnRefundBtn(_ sender: Any) {
        delegate?.didTapOnRefundBtn(cell: self)
    }

}

