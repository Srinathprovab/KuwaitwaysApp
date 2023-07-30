//
//  ContactInfoVC.swift
//  KuwaitWays
//
//  Created by FCI on 24/05/23.
//

import UIKit

class ContactInfoVC: BaseTableVC, TimerManagerDelegate {
   
    
    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var nav: NavBar!
    @IBOutlet weak var navHeight: NSLayoutConstraint!
    @IBOutlet weak var bookNowHolderView: UIView!
    @IBOutlet weak var savelbl: UILabel!
    @IBOutlet weak var saveBtn: UIButton!
    
    static var newInstance: ContactInfoVC? {
        let storyboard = UIStoryboard(name: Storyboard.Main.name,
                                      bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: self.className()) as? ContactInfoVC
        return vc
    }
    var tablerow = [TableRow]()
    
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(offline), name: NSNotification.Name("offline"), object: nil)
        
        countryCode = defaults.string(forKey: UserDefaultsKeys.mobilecountrycode) ?? ""
        billingCountryCode = defaults.string(forKey: UserDefaultsKeys.mobilecountrycode) ?? ""
        
    }
    
    func timerDidFinish() {
        guard let vc = PopupVC.newInstance.self else {return}
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: false)
    }
    
    func updateTimer() {
        
    }
    
    
    @objc func offline(notificatio:UNNotification) {
        callapibool = true
        guard let vc = NoInternetConnectionVC.newInstance.self else {return}
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false)
    }
    
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupUI()
        TimerManager.shared.delegate = self
    }
    
    
    
    func setupUI() {
        
        holderView.backgroundColor = .AppHolderViewColor
        setuplabels(lbl: nav.titlelbl, text: "Contact Information", textcolor: .WhiteColor, font: .OpenSansMedium(size: 20), align: .center)
        nav.backBtn.addTarget(self, action: #selector(didTapOnBackBtnAction(_:)), for: .touchUpInside)
        saveBtn.setTitle("", for: .normal)
        saveBtn.addTarget(self, action: #selector(didTapOnSaveBtnAction(_:)), for: .touchUpInside)
        bookNowHolderView.backgroundColor = .AppJournyTabSelectColor
        email = ""
        mobile = ""
        commonTableView.registerTVCells(["ContactInformationTVCell",
                                         "EmptyTVCell"])
        setupTVCells()
        
        if screenHeight > 835 {
            navHeight.constant = 130
        }else {
            navHeight.constant = 90
        }
    }
    
    
    func setupTVCells() {
        tablerow.removeAll()
        
        tablerow.append(TableRow(cellType:.ContactInformationTVCell))
        if screenHeight < 835 {
            tablerow.append(TableRow(height:50,bgColor: .AppHolderViewColor,cellType:.EmptyTVCell))
        }
        commonTVData = tablerow
        commonTableView.reloadData()
    }
    
    
    override func didTapOnCountryCodeBtn(cell: ContactInformationTVCell) {
        billingCountryCode = cell.billingCountryCode
        billingCountryName = cell.billingCountryName
        countryCode = cell.countryCodeLbl.text ?? ""
    }
    
    
    override func didTapOnDropDownBtn(cell: ContactInformationTVCell) {
        billingCountryCode = cell.billingCountryCode
        billingCountryName = cell.billingCountryName
        countryCode = cell.countryCodeLbl.text ?? ""
    }
    
    
    @objc func didTapOnBackBtnAction(_ sender:UIButton) {
        callapibool = false
        dismiss(animated: true)
    }
    
    
    override func editingTextField(tf:UITextField){
        
        
        switch tf.tag {
        case 111:
            email = tf.text ?? ""
            break
            
        case 222:
            mobile = tf.text ?? ""
            break
            
        default:
            break
        }
    }
    
    @objc func didTapOnSaveBtnAction(_ sender:UIButton) {
        
        if email == "" {
            showToast(message: "Enter Email Address")
        }else if email.isValidEmail() == false {
            showToast(message: "Enter Valid Email Addreess")
        }else if mobile == "" {
            showToast(message: "Enter Mobile No")
        }else if mobile.isValidMobileNumber() == false {
            showToast(message: "Enter Valid Mobile No")
        }else if billingCountryCode == "" {
            showToast(message: "Enter Country Code")
        }else if mobilenoMaxLengthBool == false {
            showToast(message: "Enter Valid Mobile No")
        }else {
            guard let vc = PayNowVC.newInstance.self else {return}
            vc.modalPresentationStyle = .overCurrentContext
            callapibool = true
            self.present(vc, animated: true)
        }
        
    }
    
    
}
