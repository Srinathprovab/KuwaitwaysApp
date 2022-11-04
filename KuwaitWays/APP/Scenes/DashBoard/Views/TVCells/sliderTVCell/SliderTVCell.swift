//
//  SliderTVCell.swift
//  BabSafar
//
//  Created by MA673 on 05/08/22.
//

import UIKit
import SwiftRangeSlider
import TTRangeSlider

protocol SliderTVCellDelegate {
    func didTapOnShowSliderBtn(cell:SliderTVCell)
}

class SliderTVCell: TableViewCell {
    
    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var lblHolderView: UIView!
    @IBOutlet weak var titlelbl: UILabel!
    @IBOutlet weak var downImg: UIImageView!
    @IBOutlet weak var downBtn: UIButton!
    @IBOutlet weak var sliderHolderView: UIView!
    @IBOutlet weak var sliderViewHeight: NSLayoutConstraint!
    // @IBOutlet weak var rangeSlider: RangeSlider!
    @IBOutlet weak var rangeSlider: TTRangeSlider!
    
    
    
    var key = String()
    var minimumValue = 10.0
    var maximumValue = 100.0
    var lowerValue = 10.0
    var upperValue = 100.0
    var delegate:SliderTVCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if self.key == "hotel" {
        
        }else {
            if selected == true {
                expand()
            }else {
                hide()
            }
        }
    }
    
    override func updateUI() {
        titlelbl.text = cellInfo?.title
        self.key = cellInfo?.key ?? ""
        
        if self.key == "hotel" {
            downImg.isHidden = true
            expand()
        }
    }
    
    func setupUI() {
        holderView.backgroundColor = .WhiteColor
        lblHolderView.backgroundColor = .WhiteColor
        sliderHolderView.backgroundColor = .WhiteColor
        downImg.image = UIImage(named: "downarrow")
        downBtn.setTitle("", for: .normal)
        setupLabels(lbl: titlelbl, text: "", textcolor: .AppLabelColor, font: .OswaldSemiBold(size: 16))
        sliderViewHeight.constant = 0
        rangeSlider.isHidden = true
        rangeSlider.backgroundColor = .WhiteColor
        rangeSlider.minValue = Float("minValue \(minimumValue)") ?? 0.0
        rangeSlider.maxValue = Float(maximumValue - 10)
        // rangeSlider.step = 10
        rangeSlider.handleType = .rectangle
        rangeSlider.lineHeight = 5
        rangeSlider.tintColor = .AppBtnColor
        rangeSlider.tintColorBetweenHandles = .AppBtnColor
        rangeSlider.lineBorderColor = .AppBtnColor
       
        rangeSlider.handleDiameter = 40.0
        rangeSlider.hideLabels = false
        rangeSlider.handleColor = .lightGray
        rangeSlider.maxLabelColour = .black
        rangeSlider.minLabelColour = .black
        
        
        
        rangeSlider.addTarget(self, action: #selector(self.rangeSliderValueChanged(slider:)), for: UIControl.Event.valueChanged)
        downBtn.isHidden = true
    }
    
    func setupViews(v:UIView,radius:CGFloat,color:UIColor) {
        v.backgroundColor = color
        v.layer.cornerRadius = radius
        v.clipsToBounds = true
        v.layer.borderWidth = 1
        v.layer.borderColor = UIColor.AppBorderColor.cgColor
    }
    
    func setupLabels(lbl:UILabel,text:String,textcolor:UIColor,font:UIFont) {
        lbl.text = text
        lbl.textColor = textcolor
        lbl.font = font
    }
    
    
    @objc func rangeSliderValueChanged(slider: TTRangeSlider) {
        print("maxValue \(slider.maxValue)")
    }
    
    
    func expand() {
        sliderViewHeight.constant = 112
        rangeSlider.isHidden = false
    }
    
    func hide() {
        sliderViewHeight.constant = 0
        rangeSlider.isHidden = true
    }
    
    @IBAction func didTapOnShowSliderBtn(_ sender: Any) {
        delegate?.didTapOnShowSliderBtn(cell: self)
    }
    
    
}
