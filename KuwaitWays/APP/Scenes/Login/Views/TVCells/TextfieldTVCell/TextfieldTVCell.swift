//
//  TextfieldTVCell.swift
//  BabSafar
//
//  Created by MA673 on 21/07/22.
//

import UIKit
import DropDown
import MaterialComponents.MaterialTextControls_OutlinedTextFields


protocol TextfieldTVCellDelegate {
    func didTapOnForGetPassword(cell:TextfieldTVCell)
    func editingTextField(tf:UITextField)
    func didTapOnShowPasswordBtn(cell:TextfieldTVCell)
    func didTapOnCountryCodeDropDownBtn(cell:TextfieldTVCell)
    
    
    func donedatePicker(cell:TextfieldTVCell)
    func cancelDatePicker(cell:TextfieldTVCell)
    
}
class TextfieldTVCell: TableViewCell {
    
    @IBOutlet weak var showPassView: UIView!
    @IBOutlet weak var showPassBtn: UIButton!
    @IBOutlet weak var showPassImg: UIImageView!
    @IBOutlet weak var countryCodeView: UIView!
    @IBOutlet weak var txtField: MDCOutlinedTextField!
    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var forgetPwdBtn: UIButton!
    @IBOutlet weak var btnHeight: NSLayoutConstraint!
    @IBOutlet weak var viewheight: NSLayoutConstraint!
    @IBOutlet weak var countryCodelbl: UILabel!
    @IBOutlet weak var dropdownBtn: UIButton!
    
    
    let datePicker = UIDatePicker()
    let dropDown = DropDown()
    var maxLength = 10
    var key = String()
    var delegate:TextfieldTVCellDelegate?
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
        btnHeight.constant = 0
       // titlelbl.text = cellInfo?.title
        txtField.placeholder = cellInfo?.tempText
        txtField.tag = Int(cellInfo?.text ?? "") ?? 0
        txtField.text = ""
        txtField.label.text = cellInfo?.title
        dropDown.dataSource = cellInfo?.moreData as? [String] ?? []
        key = cellInfo?.key ?? ""
        switch cellInfo?.key {
            
        case "pwd":
            self.txtField.isSecureTextEntry = true
//             btnHeight.constant = 30
//             forgetPwdBtn.isHidden = false
            break
            
        case "pass":
            self.txtField.isSecureTextEntry = true
            btnHeight.constant = 30
            forgetPwdBtn.isHidden = false
            showPassView.isHidden = false
            break
            
        case "mobile":
            self.txtField.keyboardType = .numberPad
            countryCodeView.isHidden = false
            break
            
        case "dob":
            showPassView.isHidden = false
            showPassImg.image = UIImage(named: "calender")
            showDatePicker()
            break
            
        case "passport":
            showPassView.isHidden = false
            showPassImg.image = UIImage(named: "downarrow")
            break
            
            
            
        default:
            break
        }
        
        
        if cellInfo?.key1 == "noedit" {
            txtField.isUserInteractionEnabled = false
            txtField.alpha = 0.6
        }else {
            txtField.isUserInteractionEnabled = true
            txtField.alpha = 1
        }
    }
    
    
    func setupUI() {
        countryCodeView.isHidden = true
        self.txtField.isSecureTextEntry = false
        showPassView.backgroundColor = .WhiteColor
        showPassView.isHidden = true
        showPassBtn.setTitle("", for: .normal)
        holderView.backgroundColor = .WhiteColor
//        textHolderView.backgroundColor = .WhiteColor
//        textHolderView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
//        textHolderView.layer.borderWidth = 1
//        textHolderView.layer.cornerRadius = 4
//        textHolderView.clipsToBounds = true
    showPassImg.image = UIImage(named: "hidepass")
//        titlelbl.textColor = .AppLabelColor
//        titlelbl.font = UIFont.OpenSansRegular(size: 14)
        txtField.delegate = self
        txtField.backgroundColor = .clear
      //  txtField.setLeftPaddingPoints(20)
        txtField.font = UIFont.LatoRegular(size: 14)
        txtField.addTarget(self, action: #selector(editingText(textField:)), for: .editingChanged)
        
        txtField.label.textColor = .AppSubtitleColor
        
        txtField.setOutlineColor( .black, for: .editing)
        txtField.setOutlineColor( .red , for: .disabled)
        txtField.setOutlineColor( .lightGray.withAlphaComponent(0.4) , for: .normal)
        
        forgetPwdBtn.setTitle("Forgot Password?", for: .normal)
        forgetPwdBtn.setTitleColor(.AppBackgroundColor, for: .normal)
        forgetPwdBtn.titleLabel?.font = UIFont.OpenSansRegular(size: 14)
        forgetPwdBtn.isHidden = true
        
       // titlelblHolderView.backgroundColor = .WhiteColor
        
        
        countryCodeView.isHidden = true
        countryCodeView.backgroundColor = .WhiteColor
        countryCodeView.layer.borderWidth = 1
        countryCodeView.layer.borderColor = UIColor.AppBorderColor.cgColor
        
        countryCodelbl.text = "+916"
        countryCodelbl.textColor = HexColor("#D0D0D0")
        countryCodelbl.font = UIFont.OpenSansRegular(size: 18)
        dropdownBtn.setTitle("", for: .normal)
        setupDropDown()
    }
    
    func setupDropDown() {

        dropDown.direction = .any
        dropDown.backgroundColor = .WhiteColor
        dropDown.anchorView = self.dropdownBtn
        dropDown.bottomOffset = CGPoint(x: 0, y: dropdownBtn.frame.size.height + 10)
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            self?.countryCodelbl.text = item
            self?.countryCodelbl.textColor = .AppLabelColor
            self?.delegate?.didTapOnCountryCodeDropDownBtn(cell: self!)
        }

    }
    
    @objc func editingText(textField:UITextField) {
        delegate?.editingTextField(tf: textField)
    }
    
    
    
   
    func showDatePicker(){
        //Formate Date
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        txtField.inputAccessoryView = toolbar
        txtField.inputView = datePicker
        
    }
    
    @objc func donedatePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        txtField.text = formatter.string(from: datePicker.date)
        delegate?.donedatePicker(cell: self)
    }
    
    @objc func cancelDatePicker(){
        delegate?.cancelDatePicker(cell: self)
    }
    
    
    @IBAction func didTapOnForGetPassword(_ sender: Any) {
        delegate?.didTapOnForGetPassword(cell: self)
    }
    
    
    
    @IBAction func didTapOnShowPasswordBtn(_ sender: Any) {
        delegate?.didTapOnShowPasswordBtn(cell: self)
    }

    @IBAction func didTapOnCountryCodeDropDownBtn(_ sender: Any) {
        dropDown.show()
        delegate?.didTapOnCountryCodeDropDownBtn(cell: self)
    }
    
}


extension TextfieldTVCell {
    override func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        if key == "mobile" {
            maxLength = 10
            guard CharacterSet(charactersIn: "0123456789").isSuperset(of: CharacterSet(charactersIn: string)) else {
                return false
            }
        }else {
            maxLength = 50
        }
        
        
        let currentString: NSString = (textField.text ?? "") as NSString
        let newString: NSString =  currentString.replacingCharacters(in: range, with: string) as NSString
        
        return newString.length <= maxLength
    }
}
