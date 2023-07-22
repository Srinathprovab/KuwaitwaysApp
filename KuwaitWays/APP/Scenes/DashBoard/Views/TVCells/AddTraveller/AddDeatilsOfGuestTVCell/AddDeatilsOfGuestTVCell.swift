//
//  AddDeatilsOfGuestTVCell.swift
//  KuwaitWays
//
//  Created by FCI on 06/07/23.
//

import UIKit
import DropDown

protocol AddDeatilsOfGuestTVCellDelegate {
    
    func didTapOnExpandAdultViewbtnAction(cell:AddDeatilsOfGuestTVCell)
    func tfeditingChanged(tf:UITextField)
    func didTapOnTitleBtnAction(cell:AddDeatilsOfGuestTVCell)
    func didTapOnMrBtnAction(cell:AddDeatilsOfGuestTVCell)
    func didTapOnMrsBtnAction(cell:AddDeatilsOfGuestTVCell)
    
}

class AddDeatilsOfGuestTVCell: TableViewCell {
    
    @IBOutlet weak var titlelbl: UILabel!
    @IBOutlet weak var dropdownimg: UIImageView!
    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var saveView: UIView!
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    @IBOutlet weak var mrRadioImg: UIImageView!
    @IBOutlet weak var mrlbl: UILabel!
    @IBOutlet weak var mrBtn: UIButton!
    @IBOutlet weak var mrsRadioImg: UIImageView!
    @IBOutlet weak var mrslbl: UILabel!
    @IBOutlet weak var mrsBtn: UIButton!
    @IBOutlet weak var mnameTF: UITextField!
    @IBOutlet weak var fnameTF: UITextField!
    @IBOutlet weak var lnameTF: UITextField!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var nameTitleSelectBtn: UIButton!
    @IBOutlet weak var mnameView: UIView!
    @IBOutlet weak var fnameView: UIView!
    @IBOutlet weak var lnameView: UIView!
    
    
    //  @IBOutlet weak var othersGenderView: UIView!
    
    let titledropDown = DropDown()
    var countryNames = [String]()
    var maxLength = 50
    var expandViewBool = true
    var delegate:AddDeatilsOfGuestTVCellDelegate?
    var indexposition = Int()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
        
    }
    
    override func prepareForReuse() {
        collapsView()
    }
    
    
    
    @objc func tfeditingChanged(tf:UITextField) {
        delegate?.tfeditingChanged(tf: tf)
    }
    
    
    func expandView() {
        dropdownimg.image = UIImage(named: "dropup")?.withRenderingMode(.alwaysOriginal).withTintColor(.AppLabelColor)
        saveView.isHidden = false
        viewHeight.constant = 154
    }
    
    
    func collapsView() {
        dropdownimg.image = UIImage(named: "down")?.withRenderingMode(.alwaysOriginal).withTintColor(.AppLabelColor)
        saveView.isHidden = true
        viewHeight.constant = 0
    }
    
    
    override func updateUI() {
        
        titlelbl.text = cellInfo?.title
        
        guard let characterLimit = cellInfo?.characterLimit else {
            return
        }
        indexposition = characterLimit - 1
        
        
        if let cellInfo = cellInfo {
            if cellInfo.key == "adult" {
                if travelerArray.count <= self.indexposition {
                    travelerArray += Array(repeating: Traveler(), count: (self.indexposition ) - travelerArray.count + 1)
                }
                
                // Update the gender property of the Traveler object at the specified index
                travelerArray[self.indexposition ].passengertype = "AD"
                travelerArray[self.indexposition ].laedpassenger = "1"
                travelerArray[self.indexposition ].middlename = ""
            } else {
                if travelerArray.count <= self.indexposition {
                    travelerArray += Array(repeating: Traveler(), count: (self.indexposition ) - travelerArray.count + 1)
                }
                
                // Update the gender property of the Traveler object at the specified index
                travelerArray[self.indexposition ].passengertype = "CH"
                travelerArray[self.indexposition ].laedpassenger = "0"
                travelerArray[self.indexposition ].middlename = ""
            }
            
        }
        
        
        if cellInfo?.title == "Adult 1" {
            expandView()
            expandViewBool = false
        }
    }
    
    
    func setupUI() {
        
        setuplabels(lbl: titlelbl, text: "", textcolor: .AppLabelColor, font: .OpenSansRegular(size: 14), align: .left)
        dropdownimg.image = UIImage(named: "down")?.withRenderingMode(.alwaysOriginal).withTintColor(.AppLabelColor)
        
        contentView.backgroundColor = .clear
        holderView.layer.borderColor = UIColor.AppBorderColor.cgColor
        holderView.layer.borderWidth = 1
        holderView.layer.cornerRadius = 8
        holderView.clipsToBounds = true
        
        collapsView()
        
        
        mrRadioImg.image = UIImage(named: "radioUnselected")?.withRenderingMode(.alwaysOriginal)
        mrsRadioImg.image = UIImage(named: "radioUnselected")?.withRenderingMode(.alwaysOriginal)
        setuplabels(lbl: mrlbl, text: "Male", textcolor: .AppLabelColor, font: .OpenSansBold(size: 14), align: .left)
        setuplabels(lbl: mrslbl, text: "Female", textcolor: .AppLabelColor, font: .OpenSansBold(size: 14), align: .left)
        mrBtn.setTitle("", for: .normal)
        mrsBtn.setTitle("", for: .normal)
        
        setupTextField(txtField: titleTF, tag1: 1, label: "Title*", placeholder: "MR")
        setupTextField(txtField: fnameTF, tag1: 1, label: "First Name*", placeholder: "First Name")
        setupTextField(txtField: mnameTF, tag1: 1, label: "Middle Name(Optional)", placeholder: "Middle Name(Optional)")
        setupTextField(txtField: lnameTF, tag1: 2, label: "Last Name*", placeholder: "Last Name")
        
        
        
        
        setupTitleDropDown()
        
        setupView(v: titleView)
        setupView(v: fnameView)
        setupView(v: mnameView)
        setupView(v: lnameView)
        
    }
    
    
    
    func setupView(v:UIView) {
        v.layer.cornerRadius = 4
        v.clipsToBounds = true
        v.layer.borderColor = UIColor.AppBorderColor.cgColor
        v.layer.borderWidth = 1
    }
    
    
    func setupTextField(txtField:UITextField,tag1:Int,label:String,placeholder:String) {
        txtField.setLeftPaddingPoints(15)
        txtField.delegate = self
        txtField.tag = tag1
        txtField.placeholder = placeholder
        txtField.backgroundColor = .clear
        txtField.font = UIFont.LatoRegular(size: 16)
        txtField.addTarget(self, action: #selector(editingTextField1(textField:)), for: .editingChanged)
        txtField.textColor = .SubTitleColor
    }
    
    
    
    func setupTitleDropDown() {
        
        titledropDown.direction = .bottom
        titledropDown.backgroundColor = .WhiteColor
        titledropDown.anchorView = self.titleView
        titledropDown.dataSource = ["MR","MS","MRS"]
        titledropDown.bottomOffset = CGPoint(x: 0, y: titleView.frame.size.height + 20)
        titledropDown.selectionAction = { [weak self] (index: Int, item: String) in
            self?.titleTF.text = item
            
            if travelerArray.count <= self?.indexposition ?? 0 {
                travelerArray += Array(repeating: Traveler(), count: (self?.indexposition ?? 0) - travelerArray.count + 1)
            }
            
            switch item {
            case "MR":
                travelerArray[self?.indexposition ?? 0].mrtitle = "1"
                break
                
            case "MS":
                travelerArray[self?.indexposition ?? 0].mrtitle = "2"
                break
                
            case "MRS":
                travelerArray[self?.indexposition ?? 0].mrtitle = "3"
                break
                
            default:
                break
                
            }
            
            self?.titleView.layer.borderColor = UIColor.AppBorderColor.cgColor
            self?.fnameTF.becomeFirstResponder()
            self?.delegate?.didTapOnTitleBtnAction(cell: self!)
        }
        
    }
    
    
    @objc func editingTextField1(textField: UITextField) {
        
        if travelerArray.count <= indexposition {
            travelerArray += Array(repeating: Traveler(), count: indexposition - travelerArray.count + 1)
        }
        
        if let text = textField.text, !text.isEmpty {
            
            switch textField {
            case fnameTF:
                fnameView.layer.borderColor = UIColor.AppBorderColor.cgColor
                travelerArray[indexposition].firstName = text
                break
                
            case lnameTF:
                lnameView.layer.borderColor = UIColor.AppBorderColor.cgColor
                travelerArray[indexposition].lastName = text
                break
                
                
            case mnameTF:
                mnameView.layer.borderColor = UIColor.AppBorderColor.cgColor
                travelerArray[indexposition].middlename = text
                break
                
                
            default:
                break
            }
        }
        
    }
    
    
    
    private func getIndexPath() -> IndexPath? {
        guard let tableView = superview as? UITableView else {
            return nil
        }
        
        return tableView.indexPath(for: self)
    }
    
    
    
    @IBAction func didTapOnMrBtnAction(_ sender: Any) {
        self.mrRadioImg.image = UIImage(named: "radioSelected")?.withRenderingMode(.alwaysOriginal).withTintColor(HexColor("#254179"))
        self.mrsRadioImg.image = UIImage(named: "radioUnselected")
        
        if travelerArray.count <= indexposition {
            travelerArray += Array(repeating: Traveler(), count: indexposition - travelerArray.count + 1)
        }
        
        // Update the gender property of the Traveler object at the specified index
        travelerArray[indexposition].gender = "1"
        
        delegate?.didTapOnMrBtnAction(cell: self)
    }
    
    @IBAction func didTapOnMrsBtnAction(_ sender: Any) {
        self.mrRadioImg.image = UIImage(named: "radioUnselected")
        self.mrsRadioImg.image = UIImage(named: "radioSelected")?.withRenderingMode(.alwaysOriginal).withTintColor(HexColor("#254179"))
        
        if travelerArray.count <= indexposition {
            travelerArray += Array(repeating: Traveler(), count: indexposition - travelerArray.count + 1)
        }
        
        // Update the gender property of the Traveler object at the specified index
        travelerArray[indexposition].gender = "2"
        delegate?.didTapOnMrsBtnAction(cell: self)
    }
    
    
    @IBAction func didTapOnExpandAdultViewbtnAction(_ sender: Any) {
        delegate?.didTapOnExpandAdultViewbtnAction(cell: self)
    }
    
    
    
    @IBAction func didTapOnTitileSelectBtnAction(_ sender: Any) {
        titledropDown.show()
    }
    

}


extension AddDeatilsOfGuestTVCell {
    override func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentString: NSString = (textField.text ?? "") as NSString
        let newString: NSString =  currentString.replacingCharacters(in: range, with: string) as NSString
        
        return newString.length <= maxLength
    }
}
