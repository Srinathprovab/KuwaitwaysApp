//
//  EditProfileVC.swift
//  BeeoonsApp
//
//  Created by MA673 on 16/08/22.
//

import UIKit

class EditProfileVC: BaseTableVC {
    
    
    @IBOutlet weak var nav: NavBar!
    @IBOutlet weak var profilePicView: UIView!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var changePicBtn: UIButton!
    
    var tablerow = [TableRow]()
    static var newInstance: EditProfileVC? {
        let storyboard = UIStoryboard(name: Storyboard.Login.name,
                                      bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: self.className()) as? EditProfileVC
        return vc
    }
    var fname = String()
    var lname = String()
    var email = String()
    var mobile = String()
    var pass = String()
    var cpass = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupTV()
    }
    
    func setupTV() {
        
        nav.titlelbl.text = "Edit Profile"
        nav.backBtn.addTarget(self, action: #selector(didTapOnBackBtn(_:)), for: .touchUpInside)
        profilePicView.layer.cornerRadius = 50
        profilePicView.clipsToBounds = true
        profilePicView.layer.borderWidth = 0.5
        profilePicView.layer.borderColor = UIColor.AppBorderColor.cgColor
        profilePic.layer.cornerRadius = 45
        profilePic.clipsToBounds = true
        changePicBtn.setTitleColor(.AppBackgroundColor, for: .normal)
        changePicBtn.setTitle("Change Picture", for: .normal)
        changePicBtn.titleLabel?.font = UIFont.OpenSansMedium(size: 16)
        
        commonTableView.registerTVCells(["EmptyTVCell","LogoImgTVCell","LabelTVCell","TextfieldTVCell","RadioButtonTVCell","ButtonTVCell"])
        appendLoginTvcells()
    }
    
    
    func appendLoginTvcells() {
        tablerow.removeAll()
        
        tablerow.append(TableRow(height:20,cellType:.EmptyTVCell))
        tablerow.append(TableRow(title:"Frist Name *",text:"1", tempText: "Name",cellType:.TextfieldTVCell))
        tablerow.append(TableRow(title:"Last Name*",text:"2", tempText: "Last Name",cellType:.TextfieldTVCell))
        tablerow.append(TableRow(title:"Email Address*",text:"3", tempText: "Email Adress",cellType:.TextfieldTVCell))
        tablerow.append(TableRow(title:"Mobile Number*",key: "mobile",text:"4", moreData:["+91","+988","+133"], tempText: "Mobile",cellType:.TextfieldTVCell))
        tablerow.append(TableRow(title:"Password*",key:"pwd", text:"5", tempText: "Password",cellType:.TextfieldTVCell))
        
        
        tablerow.append(TableRow(height:20,cellType:.EmptyTVCell))
        tablerow.append(TableRow(title:"UPDATE",cellType:.ButtonTVCell))
        tablerow.append(TableRow(height:50,cellType:.EmptyTVCell))
        
        commonTVData = tablerow
        commonTableView.reloadData()
        
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
            email = tf.text ?? ""
            break
            
        case 4:
            mobile = tf.text ?? ""
            break
            
        case 5:
            pass = tf.text ?? ""
            break
            
        default:
            break
        }
    }
    
    
    override func btnAction(cell: ButtonTVCell){
        
        if fname.isEmpty == true {
            showToast(message: "Enter First Name")
        }else  if lname.isEmpty == true {
            showToast(message: "Enter Last Name")
        }else  if email.isEmpty == true {
            showToast(message: "Enter Email Address")
        }else  if email.isValidEmail() == false {
            showToast(message: "Enter Valid Address")
        }else if mobile.isEmpty == true {
            showToast(message: "Enter Mobile Number")
        }else  if pass.isEmpty == true {
            showToast(message: "Enter Password")
        }else  if pass.isValidPassword() == false {
            showToast(message: "Enter Valid Password")
        }else  if cpass.isEmpty == true {
            showToast(message: "Enter Conform Password")
        }else  if pass != cpass {
            showToast(message: "Password Should Match")
        }else {
            showToast(message: "Call apiiiiiiii.........")
        }
    }
    
    
    override func didTapOnCountryCodeDropDownBtn(cell:TextfieldTVCell){
        cell.dropDown.show()
    }
    
    
    @objc func didTapOnBackBtn(_ sender: UIButton) {
        print("didTapOnBackBtn")
    }
    
    
    
    @IBAction func didTapOnChangePicBtn(_ sender: Any) {
        openGallery()
    }
    
}




extension EditProfileVC:UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func openGallery() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            let alert  = UIAlertController(title: "Warning", message: "You don't have permission to access gallery.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            profilePic.image = pickedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
