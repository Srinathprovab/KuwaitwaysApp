//
//  LoginVC.swift
//  BeeoonsApp
//
//  Created by MA673 on 16/08/22.
//

import UIKit

class LoginVC: BaseTableVC {
    
    
    var tablerow = [TableRow]()
    static var newInstance: LoginVC? {
        let storyboard = UIStoryboard(name: Storyboard.Login.name,
                                      bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: self.className()) as? LoginVC
        return vc
    }
    var email = String()
    var pass = String()
    var showPwdBool = true
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupTV()
    }
    
    func setupTV() {
        
        commonTableView.registerTVCells(["EmptyTVCell","LogoImgTVCell","LabelTVCell","TextfieldTVCell","RadioButtonTVCell","ButtonTVCell","UnderLineTVCell","SignUpWithTVCell","LabelWithButtonTVCell"])
        
        appendLoginTvcells()
    }
    
    
    func appendLoginTvcells() {
        tablerow.removeAll()
        
        tablerow.append(TableRow(height:80,cellType:.EmptyTVCell))
        tablerow.append(TableRow(cellType:.LogoImgTVCell))
        tablerow.append(TableRow(title:"Login Account",subTitle: "Hello , welcome back to our account !",key: "login",cellType:.LabelTVCell))
        tablerow.append(TableRow(title:"Email Address*",text:"1", tempText: "Email Adress",cellType:.TextfieldTVCell))
        tablerow.append(TableRow(title:"Password*",key:"pass", text:"2", tempText: "Password",cellType:.TextfieldTVCell))
        
        tablerow.append(TableRow(height:20,cellType:.EmptyTVCell))
        tablerow.append(TableRow(title:"Login",cellType:.ButtonTVCell))
        tablerow.append(TableRow(height:50,cellType:.EmptyTVCell))
        tablerow.append(TableRow(cellType:.UnderLineTVCell))
        tablerow.append(TableRow(height:20,cellType:.EmptyTVCell))
        tablerow.append(TableRow(cellType:.SignUpWithTVCell))
        tablerow.append(TableRow(height:100,cellType:.EmptyTVCell))
        tablerow.append(TableRow(title:"Not register yet?",subTitle: "",key: "acccreate", tempText: "Create Account",cellType:.LabelWithButtonTVCell))

        
        commonTVData = tablerow
        commonTableView.reloadData()
        
    }
    
    override func editingTextField(tf: UITextField) {
        
        print(tf.text ?? "")
        switch tf.tag {
        case 1:
            email = tf.text ?? ""
            break
            
        case 2:
            pass = tf.text ?? ""
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
        }else if pass.isEmpty == true {
            showToast(message: "Enter Password")
        }else  if pass.isValidPassword() == false {
            showToast(message: "Enter Valid Password")
        }else {
            print("Callllll apiiiiiii")
        }
    }
    
    override func didTapOnShowPasswordBtn(cell:TextfieldTVCell){
        
        if showPwdBool == true {
          // cell.showImage.image = UIImage(named: "showpass")
            cell.txtField.isSecureTextEntry = false
            showPwdBool = false
        }else {
            cell.txtField.isSecureTextEntry = true
           // cell.showImage.image = UIImage(named: "hidepass")
            showPwdBool = true
        }
        
    }
    
    
    override func didTapOnForGetPassword(cell:TextfieldTVCell){
        guard let vc = ResetPasswordVC.newInstance.self else {return}
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    
    override func didTapOnGoogleBtn(cell: SignUpWithTVCell){
        print("didTapOnGoogleBtn")
    }
    
    
    override func didTapOnBackToCreateAccountBtn(cell: LabelWithButtonTVCell) {
        guard let vc = CreateAccountVC.newInstance.self else {return}
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
   
    
    
    @IBAction func didTapOnSkipBtn(_ sender: Any) {
        dismiss(animated: false)
    }
    
}
