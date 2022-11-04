//
//  SaveTravellersDetailsVC.swift
//  BeeoonsApp
//
//  Created by MA673 on 18/08/22.
//

import UIKit

class SaveTravellersDetailsVC: BaseTableVC {
    
    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var nav: NavBar!
    @IBOutlet weak var navHeight: NSLayoutConstraint!
    
    
    static var newInstance: SaveTravellersDetailsVC? {
        let storyboard = UIStoryboard(name: Storyboard.Main.name,
                                      bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: self.className()) as? SaveTravellersDetailsVC
        return vc
    }
    
    
    var tablerow = [TableRow]()
    
    var gender = String()
    var fname = String()
    var lname = String()
    var dob = String()
    var nationality = String()
    var passportNO = String()
    var passportIssuingCountry = String()
    var passportExprityDate = String()
    
    override func viewWillAppear(_ animated: Bool) {
        
        if screenHeight > 800 {
            navHeight.constant = 190
        }else {
            navHeight.constant = 150
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // showDatePicker()
    }
    
    
    
    func setupUI() {
        holderView.backgroundColor = .WhiteColor
        nav.titlelbl.text = "Travellers Details"
        nav.backBtn.addTarget(self, action: #selector(gotoBackScreen), for: .touchUpInside)
        nav.citylbl.isHidden = false
        nav.datelbl.isHidden = false
        nav.travellerlbl.isHidden = false
        nav.citylbl.text = "Adult"
        nav.datelbl.text = ""
        nav.travellerlbl.text = ""
        
        commonTableView.registerTVCells(["EmptyTVCell","LogoImgTVCell","LabelTVCell","TextfieldTVCell","RadioButtonTVCell","ButtonTVCell","SelectGenderTVCell"])
        
        
        
        
        if let selectedTab = defaults.string(forKey: UserDefaultsKeys.tabselect) {
            if selectedTab == "Flight" {
                setupTVCells()
            }else {
                setupHotelTVCells()
            }
        }
    }
    
    
    @objc func gotoBackScreen() {
        dismiss(animated: true)
    }
    
    
    func setupTVCells() {
        tablerow.removeAll()
        
        tablerow.append(TableRow(height:20,cellType:.EmptyTVCell))
        tablerow.append(TableRow(cellType:.SelectGenderTVCell))
        tablerow.append(TableRow(height:10,cellType:.EmptyTVCell))
        tablerow.append(TableRow(title:"Frist Name *",text:"1", tempText: "Name",cellType:.TextfieldTVCell))
        tablerow.append(TableRow(title:"Last Name*",text:"2", tempText: "Last Name",cellType:.TextfieldTVCell))
        tablerow.append(TableRow(title:"Date of Brith*",key:"dob", text:"3", tempText: "Date of Brith",cellType:.TextfieldTVCell))
        tablerow.append(TableRow(title:"Nationality*",text:"4", tempText: "Nationality",cellType:.TextfieldTVCell))
        tablerow.append(TableRow(title:"Passport NO*",text:"5", tempText: "Passport NO",cellType:.TextfieldTVCell))
        tablerow.append(TableRow(title:"Passport Issuing Country*",key:"passport", text:"6", tempText: "Passport Issuing Country",cellType:.TextfieldTVCell))
        tablerow.append(TableRow(title:"Passport Exprity Date*",key:"dob", text:"7", tempText: "Passport Exprity Date",cellType:.TextfieldTVCell))
        
        
        
        tablerow.append(TableRow(height:20,cellType:.EmptyTVCell))
        tablerow.append(TableRow(title:"SAVE",cellType:.ButtonTVCell))
        tablerow.append(TableRow(height:50,cellType:.EmptyTVCell))
        
        commonTVData = tablerow
        commonTableView.reloadData()
        
    }
    
    
    func setupHotelTVCells() {
        tablerow.removeAll()
        
        tablerow.append(TableRow(height:20,cellType:.EmptyTVCell))
        tablerow.append(TableRow(cellType:.SelectGenderTVCell))
        tablerow.append(TableRow(height:10,cellType:.EmptyTVCell))
        tablerow.append(TableRow(title:"Frist Name *",text:"1", tempText: "Name",cellType:.TextfieldTVCell))
        tablerow.append(TableRow(title:"Last Name*",text:"2", tempText: "Last Name",cellType:.TextfieldTVCell))
        tablerow.append(TableRow(title:"Date of Brith*",key:"dob", text:"3", tempText: "Date of Brith",cellType:.TextfieldTVCell))
        tablerow.append(TableRow(title:"Nationality*",text:"4", tempText: "Nationality",cellType:.TextfieldTVCell))
        
        tablerow.append(TableRow(height:20,cellType:.EmptyTVCell))
        tablerow.append(TableRow(title:"SAVE",cellType:.ButtonTVCell))
        tablerow.append(TableRow(height:50,cellType:.EmptyTVCell))
        
        commonTVData = tablerow
        commonTableView.reloadData()
        
    }
    
    
    override func didSelectMaleRadioBtn(cell:SelectGenderTVCell){
        gender = "Male"
        cell.maleRadioImg.image = UIImage(named: "radioSelected")
        cell.femaleRadioImg.image = UIImage(named: "radioUnselected")
    }
    
    override func didSelectOnFemaleBtn(cell:SelectGenderTVCell){
        gender = "Female"
        cell.maleRadioImg.image = UIImage(named: "radioUnselected")
        cell.femaleRadioImg.image = UIImage(named: "radioSelected")
    }
    
    
    
    
    override func didTapOnShowPasswordBtn(cell:TextfieldTVCell){
       print("didTapOnShowPasswordBtn")
    }
    
    
    
    override func editingTextField(tf: UITextField) {
        
        print(tf.text ?? "")
        switch tf.tag {
        case 1:
            fname = tf.text ?? ""
            break
            
        case 2:
            lname = tf.text ?? ""
            break
            
        case 3:
            dob = tf.text ?? ""
            break
            
        case 4:
            nationality = tf.text ?? ""
            break
            
        case 5:
            passportNO = tf.text ?? ""
            break
            
        case 6:
            passportIssuingCountry = tf.text ?? ""
            break
            
        case 7:
            passportExprityDate = tf.text ?? ""
            break
            
        default:
            break
        }
    }
    
    
    
    override func btnAction(cell: ButtonTVCell){
        
        
        
        if let selectedTab = defaults.string(forKey: UserDefaultsKeys.tabselect) {
            if selectedTab == "Flight" {
                if gender.isEmpty == true {
                    showErrorMessage(item: 3, msg: "Enter Gender")
                }else if fname.isEmpty == true {
                    showErrorMessage(item: 3, msg: "Enter First Name")
                }else if lname.isEmpty == true {
                    showErrorMessage(item: 4, msg: "Enter Last Name")
                }else if dob.isEmpty == true {
                    showErrorMessage(item: 5, msg: "Enter DOB")
                }else if passportNO.isEmpty == true {
                    showErrorMessage(item: 6, msg: "Enter Passport NO")
                }else if passportIssuingCountry.isEmpty == true {
                    showErrorMessage(item: 7, msg: "Enter Passport Issuing Country")
                }else if passportExprityDate.isEmpty == true {
                    showErrorMessage(item: 8, msg: "Enter Passport Exprity Date")
                }else {
                    print("Call API ...........")
                    dismiss(animated: true)
                }
            }else {
                if gender.isEmpty == true {
                    showErrorMessage(item: 3, msg: "Enter Gender")
                }else if fname.isEmpty == true {
                    showErrorMessage(item: 3, msg: "Enter First Name")
                }else if lname.isEmpty == true {
                    showErrorMessage(item: 4, msg: "Enter Last Name")
                }else if dob.isEmpty == true {
                    showErrorMessage(item: 5, msg: "Enter DOB")
                }else {
                    print("Call API ...........")
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "add"), object: "\(fname + lname)")
                    //dismiss(animated: true)
                    gotoPayNowVC()
                }
            }
        }
        
    }
    
    
    
    func showErrorMessage(item:Int,msg:String) {
        let cell = commonTableView.cellForRow(at: IndexPath(item: item, section: 0)) as? TextfieldTVCell
        cell?.txtField.setOutlineColor( .red.withAlphaComponent(0.4) , for: .disabled)
        showToast(message: msg)
    }
    
    
    func gotoPayNowVC() {
        guard let vc = PayNowVC.newInstance.self else {return}
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    
    
    
    override func donedatePicker(cell:TextfieldTVCell){
        self.view.endEditing(true)
    }
    
    override func cancelDatePicker(cell:TextfieldTVCell){
        self.view.endEditing(true)
    }
   
}
