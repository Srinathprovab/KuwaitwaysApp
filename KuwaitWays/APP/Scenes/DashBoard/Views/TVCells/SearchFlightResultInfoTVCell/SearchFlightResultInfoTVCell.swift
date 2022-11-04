//
//  SearchFlightResultInfoTVCell.swift
//  BeeoonsApp
//
//  Created by MA673 on 17/08/22.
//

import UIKit
protocol SearchFlightResultInfoTVCellDelegate {
    func didTapOnRefunduableBtn(cell:SearchFlightResultInfoTVCell)
}

class SearchFlightResultInfoTVCell: TableViewCell {
    
    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var logoImg: UIImageView!
    @IBOutlet weak var inNolbl: UILabel!
    @IBOutlet weak var fromCityTimelbl: UILabel!
    @IBOutlet weak var fromCityNamelbl: UILabel!
    @IBOutlet weak var toCityTimelbl: UILabel!
    @IBOutlet weak var toCityNamelbl: UILabel!
    @IBOutlet weak var hourslbl: UILabel!
    @IBOutlet weak var noOfStopslbl: UILabel!
    @IBOutlet weak var underLineImg: UIImageView!
    @IBOutlet weak var kwdlbl: UILabel!
    @IBOutlet weak var refundBtn: UIButton!
    @IBOutlet weak var bottomView: UIView!
    
    
    @IBOutlet weak var fromDatelbl: UILabel!
    @IBOutlet weak var toDatelbl: UILabel!
    @IBOutlet weak var bottomViewHeight: NSLayoutConstraint!
    
    
    @IBOutlet weak var retView: UIView!
    @IBOutlet weak var logoImg1: UIImageView!
    @IBOutlet weak var inNolbl1: UILabel!
    @IBOutlet weak var fromCityTimelbl1: UILabel!
    @IBOutlet weak var fromCityNamelbl1: UILabel!
    @IBOutlet weak var toCityTimelbl1: UILabel!
    @IBOutlet weak var toCityNamelbl1: UILabel!
    @IBOutlet weak var hourslbl1: UILabel!
    @IBOutlet weak var noOfStopslbl1: UILabel!
    @IBOutlet weak var underLineImg1: UIImageView!
    @IBOutlet weak var fromDatelbl1: UILabel!
    @IBOutlet weak var toDatelbl1: UILabel!
    
    @IBOutlet weak var sv: UIStackView!

    var delegate:SearchFlightResultInfoTVCellDelegate?
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
        inNolbl.text = cellInfo?.title
        fromCityTimelbl.text = cellInfo?.subTitle
        fromCityNamelbl.text = cellInfo?.buttonTitle
        toCityTimelbl.text = cellInfo?.text
        toCityNamelbl.text = cellInfo?.headerText
        hourslbl.text = cellInfo?.tempText
        noOfStopslbl.text = cellInfo?.questionBase
        
        inNolbl1.text = cellInfo?.title
        fromCityTimelbl1.text = cellInfo?.subTitle
        fromCityNamelbl1.text = cellInfo?.buttonTitle
        toCityTimelbl1.text = cellInfo?.text
        toCityNamelbl1.text = cellInfo?.headerText
        hourslbl1.text = cellInfo?.tempText
        noOfStopslbl1.text = cellInfo?.questionBase
        
        if cellInfo?.key == "flightinfo" {
            fromDatelbl.text = "26 jul 2022"
            toDatelbl.text = "27 jul 2022"
            bottomViewHeight.constant = 0
            bottomView.isHidden = true
        }
        
        
        if cellInfo?.key1 == "roundtrip" {
            retView.isHidden = false
            
        }
        
    }
    
    func setupUI() {
        setupViews(v: holderView, radius: 0, color: .WhiteColor)
        logoImg.image = UIImage(named: "indigo")?.withRenderingMode(.alwaysOriginal)
        logoImg.contentMode = .scaleToFill
        underLineImg.image = UIImage(named: "line")?.withRenderingMode(.alwaysOriginal)
        underLineImg.contentMode = .scaleToFill
        setupLabels(lbl: inNolbl, text: "", textcolor: .AppLabelColor, font: .OpenSansRegular(size: 12))
        setupLabels(lbl: fromCityTimelbl, text: "", textcolor: .AppLabelColor, font: .OswaldSemiBold(size: 22))
        setupLabels(lbl: toCityTimelbl, text: "", textcolor: .AppLabelColor, font: .OswaldSemiBold(size: 22))
        setupLabels(lbl: fromCityNamelbl, text: "", textcolor: .AppLabelColor, font: .OpenSansMedium(size: 14))
        setupLabels(lbl: toCityNamelbl, text: "", textcolor: .AppLabelColor, font: .OpenSansMedium(size: 14))
        setupLabels(lbl: hourslbl, text: "", textcolor: .AppLabelColor, font: .OpenSansMedium(size: 12))
        setupLabels(lbl: noOfStopslbl, text: "", textcolor: .AppLabelColor, font: .OpenSansMedium(size: 12))
        bottomView.backgroundColor = .AppBtnColor
        setupLabels(lbl: kwdlbl, text: "KWD: 150:00", textcolor: .WhiteColor, font: .oswaldRegular(size: 16))
        setupLabels(lbl: fromDatelbl, text: "", textcolor: .AppSubtitleColor, font: .OpenSansMedium(size: 12))
        setupLabels(lbl: toDatelbl, text: "", textcolor: .AppSubtitleColor, font: .OpenSansMedium(size: 12))
        
        
        setupViews(v: retView, radius: 0, color: .WhiteColor)
        logoImg1.image = UIImage(named: "em")?.withRenderingMode(.alwaysOriginal)
        logoImg1.contentMode = .scaleToFill
        underLineImg1.image = UIImage(named: "line")?.withRenderingMode(.alwaysOriginal)
        underLineImg1.contentMode = .scaleToFill
        setupLabels(lbl: inNolbl1, text: "", textcolor: .AppLabelColor, font: .OpenSansRegular(size: 12))
        setupLabels(lbl: fromCityTimelbl1, text: "", textcolor: .AppLabelColor, font: .OswaldSemiBold(size: 22))
        setupLabels(lbl: toCityTimelbl1, text: "", textcolor: .AppLabelColor, font: .OswaldSemiBold(size: 22))
        setupLabels(lbl: fromCityNamelbl1, text: "", textcolor: .AppLabelColor, font: .OpenSansMedium(size: 14))
        setupLabels(lbl: toCityNamelbl1, text: "", textcolor: .AppLabelColor, font: .OpenSansMedium(size: 14))
        setupLabels(lbl: hourslbl1, text: "", textcolor: .AppLabelColor, font: .OpenSansMedium(size: 12))
        setupLabels(lbl: noOfStopslbl1, text: "", textcolor: .AppLabelColor, font: .OpenSansMedium(size: 12))
        setupLabels(lbl: fromDatelbl1, text: "", textcolor: .AppSubtitleColor, font: .OpenSansMedium(size: 12))
        setupLabels(lbl: toDatelbl1, text: "", textcolor: .AppSubtitleColor, font: .OpenSansMedium(size: 12))

        retView.isHidden = true
        sv.layer.cornerRadius = 6
        sv.clipsToBounds = true
        sv.layer.borderWidth = 0.5
        sv.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    
    func setupViews(v:UIView,radius:CGFloat,color:UIColor) {
        v.backgroundColor = color
        v.layer.cornerRadius = radius
        v.clipsToBounds = true
        v.layer.borderWidth = 0.2
        v.layer.borderColor = UIColor.AppBorderColor.cgColor
    }
    
    func setupLabels(lbl:UILabel,text:String,textcolor:UIColor,font:UIFont) {
        lbl.text = text
        lbl.textColor = textcolor
        lbl.font = font
    }
    
    
    
    @IBAction func didTapOnRefunduableBtn(_ sender: Any) {
        delegate?.didTapOnRefunduableBtn(cell: self)
    }
    
    
}
