//
//  ResetPasswordVC.swift
//  BeeoonsApp
//
//  Created by MA673 on 16/08/22.
//

import UIKit

class ResetPasswordVC: BaseTableVC, ForgetPasswordViewModelDelegate {
    
    
    var tablerow = [TableRow]()
    static var newInstance: ResetPasswordVC? {
        let storyboard = UIStoryboard(name: Storyboard.Login.name,
                                      bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: self.className()) as? ResetPasswordVC
        return vc
    }
    var email = String()
    var mobile = String()
    var payload = [String:Any]()
    var vm:ForgetPasswordViewModel?
    
    

    @objc func offline(notificatio:UNNotification) {
        callapibool = true
        guard let vc = NoInternetConnectionVC.newInstance.self else {return}
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(offline), name: NSNotification.Name("offline"), object: nil)

    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupTV()
        vm = ForgetPasswordViewModel(self)
    }
    
    func setupTV() {
        
        commonTableView.registerTVCells(["EmptyTVCell",
                                         "LogoImgTVCell",
                                         "LabelTVCell",
                                         "TextfieldTVCell",
                                         "RadioButtonTVCell",
                                         "ButtonTVCell"])
        
        appendLoginTvcells()
    }
    
    
    
    func appendLoginTvcells() {
        tablerow.removeAll()
        
        tablerow.append(TableRow(height:60,cellType:.EmptyTVCell))
        tablerow.append(TableRow(cellType:.LogoImgTVCell))
        tablerow.append(TableRow(title:"Reset Your Password",subTitle: "Enter your email and we'll send you the instructions to recover your password:",key: "resetpass",cellType:.LabelTVCell))
        tablerow.append(TableRow(title:"Email Address*",text:"1", tempText: "Email Adress",cellType:.TextfieldTVCell))
        tablerow.append(TableRow(title:"Mobile Number*",key: "mobile",text:"4", moreData:["+91","+988","+133"], tempText: "Mobile",cellType:.TextfieldTVCell))
        
        tablerow.append(TableRow(height:20,cellType:.EmptyTVCell))
        tablerow.append(TableRow(title:"Send",cellType:.ButtonTVCell))
        tablerow.append(TableRow(height:50,cellType:.EmptyTVCell))
        
        commonTVData = tablerow
        commonTableView.reloadData()
        
    }
    
    override func editingTextField(tf: UITextField) {
        
        print(tf.text ?? "")
        switch tf.tag {
        case 1:
            email = tf.text ?? ""
            break
            
        case 4:
            mobile = tf.text ?? ""
            break
            
        default:
            break
        }
    }
    
    
    override func btnAction(cell: ButtonTVCell){
        
        if email.isEmpty == true {
            showToast(message: "Enter Email Address")
        }else  if email.isValidEmail() == false {
            showToast(message: "Enter Valid Address")
        }else  if mobile.isEmpty == true {
            showToast(message: "Enter Mobile NO")
        }else {
        
            payload["email"] = email
            payload["phone"] = mobile
            vm?.CALL_FORGET_PASSWORD_API(dictParam: payload)
        }
    }
    
    
    @IBAction func didTapOnSkipBtn(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
    
    func forgetPasswordDetails(response: LoginModel) {
        if response.status == false {
            showToast(message: response.data ?? "Errorrrrr")
        }else {
            showToast(message: response.data ?? "")
            let seconds = 3.0
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {[self] in
                // Put your code which should be executed with a delay here
//                NotificationCenter.default.post(name: NSNotification.Name("logindon"), object: nil)
                dismiss(animated: true)
            }
        }
    }
    
    
    
}
