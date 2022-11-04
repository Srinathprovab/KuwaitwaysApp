//
//  ResetPasswordVC.swift
//  BeeoonsApp
//
//  Created by MA673 on 16/08/22.
//

import UIKit

class ResetPasswordVC: BaseTableVC {
    
    
    var tablerow = [TableRow]()
    static var newInstance: ResetPasswordVC? {
        let storyboard = UIStoryboard(name: Storyboard.Login.name,
                                      bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: self.className()) as? ResetPasswordVC
        return vc
    }
    var email = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupTV()
    }
    
    func setupTV() {
        
        commonTableView.registerTVCells(["EmptyTVCell","LogoImgTVCell","LabelTVCell","TextfieldTVCell","RadioButtonTVCell","ButtonTVCell"])
        
        appendLoginTvcells()
    }
    
   
    
    func appendLoginTvcells() {
        tablerow.removeAll()
        
        tablerow.append(TableRow(height:60,cellType:.EmptyTVCell))
        tablerow.append(TableRow(cellType:.LogoImgTVCell))
        tablerow.append(TableRow(title:"Reset Your Password",subTitle: "Enter your email and we'll send you the instructions to recover your password:",key: "resetpass",cellType:.LabelTVCell))
        tablerow.append(TableRow(title:"Email Address*",text:"1", tempText: "Email Adress",cellType:.TextfieldTVCell))
        
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
            
        default:
            break
        }
    }
    
    
    override func btnAction(cell: ButtonTVCell){
        
        if email.isEmpty == true {
            showToast(message: "Enter Email Address")
        }else  if email.isValidEmail() == false {
            showToast(message: "Enter Valid Address")
        }else {
            print("Callllll apiiiiiii")
        }
    }
    
    
    @IBAction func didTapOnSkipBtn(_ sender: Any) {
        dismiss(animated: true)
    }
    
}
