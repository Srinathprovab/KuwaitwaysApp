//
//  NewMulticityTVCell.swift
//  KuwaitWays
//
//  Created by FCI on 11/12/23.
//

import UIKit

protocol NewMulticityTVCellDelegate {
    func didTapOnFromBtn(cell:NewMulticityTVCell)
    func didTapOnToBtn(cell:NewMulticityTVCell)
    func didTapOndateBtn(cell:NewMulticityTVCell)
}

class NewMulticityTVCell: TableViewCell {
    
    
    @IBOutlet weak var addCityView: UIView!
    @IBOutlet weak var citycard3: UIStackView!
    @IBOutlet weak var citycard4: UIStackView!
    @IBOutlet weak var closeBtn3: UIButton!
    @IBOutlet weak var closeBtn4: UIButton!
    @IBOutlet weak var addCityViewHeight: NSLayoutConstraint!
    
    var count = 2
    var delegate:NewMulticityTVCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    override func updateUI() {
        
    }
    
    
    func setupUI() {
        
    }
    
    
    
    
    func didTapOnFromBtn(_ sender:UIButton) {
        defaults.set(sender.tag, forKey: UserDefaultsKeys.cellTag)
        delegate?.didTapOnFromBtn(cell: self)
    }
    
    func didTapOnToBtn(_ sender:UIButton) {
        defaults.set(sender.tag, forKey: UserDefaultsKeys.cellTag)
        delegate?.didTapOnToBtn(cell: self)
    }
    
    func didTapOndateBtn(_ sender:UIButton) {
        defaults.set(sender.tag, forKey: UserDefaultsKeys.cellTag)
        delegate?.didTapOndateBtn(cell: self)
    }
    
    
    
    @IBAction func closecard3BtnAction(_ sender: Any) {
        count -= 1
        citycard3.isHidden = true
        addCityView.isHidden = false
        addCityViewHeight.constant = 40
        NotificationCenter.default.post(name: NSNotification.Name("addcity"), object: nil)
    }
    
    @IBAction func closecard4BtnAction(_ sender: Any) {
        count -= 1
        addCityView.isHidden = false
        addCityViewHeight.constant = 40
        citycard4.isHidden = true
        
//        fromlocidArray.remove(at: (sender as AnyObject).tag)
//        tolocidArray.remove(at: (sender as AnyObject).tag)
//        fromCityCodeArray.remove(at: (sender as AnyObject).tag)
//        toCityCodeArray.remove(at: (sender as AnyObject).tag)
//        depatureDatesArray.remove(at: (sender as AnyObject).tag)
//        fromCityNameArray.remove(at: (sender as AnyObject).tag)
//        toCityNameArray.remove(at: (sender as AnyObject).tag)
        
        
        NotificationCenter.default.post(name: NSNotification.Name("addcity"), object: nil)
    }
    
    
    
    
    @IBAction func didTapOnAddCityBtnAction(_ sender: Any) {
        count += 1
        
        if count <= 4 {
            
            switch count {
            case 3:
                citycard3.isHidden = false
                citycard4.isHidden = true
                break
                
            case 4:
                citycard3.isHidden = false
                citycard4.isHidden = false
                addCityView.isHidden = true
                addCityViewHeight.constant = 0
                break
                
            default:
                break
            }
        }
        
        
        NotificationCenter.default.post(name: NSNotification.Name("addcity"), object: nil)
        
    }
    
    
}
