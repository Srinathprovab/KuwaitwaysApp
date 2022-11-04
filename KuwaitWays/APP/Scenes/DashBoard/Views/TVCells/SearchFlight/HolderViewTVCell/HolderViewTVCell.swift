//
//  HolderViewTVCell.swift
//  BeeoonsApp
//
//  Created by MA673 on 17/08/22.
//

import UIKit

class HolderViewTVCell: UITableViewCell {
    
    
    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var locImg: UIImageView!
    @IBOutlet weak var titlelbl: UILabel!
    @IBOutlet weak var dropdownimg: UIImageView!
    @IBOutlet weak var fromBtn: UIButton!
    
    @IBOutlet weak var toView: UIView!
    @IBOutlet weak var locImg1: UIImageView!
    @IBOutlet weak var tolabel: UILabel!
    @IBOutlet weak var toBtn: UIButton!

    @IBOutlet weak var swipeView: UIView!
    @IBOutlet weak var swipeImg: UIImageView!
    @IBOutlet weak var swipeBtn: UIButton!
    
    
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
        contentView.backgroundColor = .AppBGColor
        setupViews(v: holderView, radius: 4, color: .AppBGcolor)
        setupLabels(lbl: titlelbl, text: "", textcolor: .AppLabelColor, font: .OpenSansRegular(size: 16))
        locImg.image = UIImage(named: "loc")?.withRenderingMode(.alwaysOriginal).withTintColor(.AppJournyTabSelectColor)
        swipeImg.image = UIImage(named: "swap")?.withRenderingMode(.alwaysOriginal).withTintColor(.WhiteColor)
        dropdownimg.image = UIImage(named: "downarrow")?.withRenderingMode(.alwaysOriginal).withTintColor(.AppJournyTabSelectColor)
        dropdownimg.isHidden = true
        
        setupViews(v: toView, radius: 4, color: .AppBGcolor)
        setupLabels(lbl: tolabel, text: "To", textcolor: .AppLabelColor, font: .OpenSansRegular(size: 16))
        locImg1.image = UIImage(named: "loc")?.withRenderingMode(.alwaysOriginal).withTintColor(.AppJournyTabSelectColor)
        toView.isHidden = true
        swipeView.backgroundColor = .AppJournyTabSelectColor
        swipeView.isHidden = true
        swipeBtn.setTitle("", for: .normal)
        swipeBtn.addTarget(self, action: #selector(swapCity(_:)), for: .touchUpInside)

        fromBtn.setTitle("", for: .normal)
        toBtn.setTitle("", for: .normal)
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
    
    
    @objc func swapCity(_ sender:UIButton) {
        let a = self.titlelbl.text
        let b = self.tolabel.text
        
        self.titlelbl.text = b
        self.tolabel.text = a
        
    }
    
    @IBAction func didTapONFromBtn(_ sender: Any) {
    }
    
    
    @IBAction func didTapONToBtn(_ sender: Any) {
    }
    
}
