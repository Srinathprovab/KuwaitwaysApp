//
//  MyAccountVC.swift
//  BeeoonsApp
//
//  Created by MA673 on 24/08/22.
//

import UIKit

class MyAccountVC: BaseTableVC {
    
    @IBOutlet weak var nav: NavBar!
    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var navHeight: NSLayoutConstraint!
    
    static var newInstance: MyAccountVC? {
        let storyboard = UIStoryboard(name: Storyboard.Main.name,
                                      bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: self.className()) as? MyAccountVC
        return vc
    }
    
    var tablerow = [TableRow]()
    var editBtnBool = false
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    
    func setupUI() {
        
        holderView.backgroundColor = .AppBackgroundColor
        nav.titlelbl.text = "My Account"
        nav.editView.isHidden = false
        nav.backBtn.isHidden = true
        nav.editView.backgroundColor = .clear
        nav.editImg.image = UIImage(named: "edit2")
        nav.editBtn.addTarget(self, action: #selector(didTapOnEditMyAccountBtn(_:)), for: .touchUpInside)
        navHeight.constant = 130
        
        commonTableView.registerTVCells(["TextfieldTVCell","EmptyTVCell","ButtonTVCell","ChooseProfilPpictureTVCell"])
        setupTVcells(str: "noedit")
    }
    
    
    func setupTVcells(str:String) {
        tablerow.removeAll()
        
      //  tablerow.append(TableRow(title:"Srinath".uppercased(),image: "profile",cellType:.ChooseProfilPpictureTVCell))
        tablerow.append(TableRow(title:"Frist Name *",text:"1", key1:str, tempText: "Name",cellType:.TextfieldTVCell))
        tablerow.append(TableRow(title:"Last Name*",text:"2", key1:str, tempText: "Last Name",cellType:.TextfieldTVCell))
        tablerow.append(TableRow(title:"Date of Brith*",key:"dob",text:"3", key1:str, tempText: "Date of Brith",cellType:.TextfieldTVCell))
        tablerow.append(TableRow(title:"Nationality*",text:"4",key1:str, tempText: "Nationality",cellType:.TextfieldTVCell))
        tablerow.append(TableRow(height:100,cellType:.EmptyTVCell))
        
        if editBtnBool == true {
            tablerow.append(TableRow(title:"UPDATE",cellType:.ButtonTVCell))
            tablerow.append(TableRow(height:50,cellType:.EmptyTVCell))
        }
        
        
        commonTVData = tablerow
        commonTableView.reloadData()
        
    }
    
    
    @objc func didTapOnEditMyAccountBtn(_ sender:UIButton) {
        editBtnBool = true
        setupTVcells(str: "edit")
    }
    
    
    override func donedatePicker(cell:TextfieldTVCell){
        self.view.endEditing(true)
    }
    
    override func cancelDatePicker(cell:TextfieldTVCell){
        self.view.endEditing(true)
    }
    
    
    override func didtapOnChooseprofilePitctureBtn(cell: ChooseProfilPpictureTVCell) {
       
        
        let alertController = UIAlertController(title: "", message: "Please Choose To Open", preferredStyle:.alert)
        
        alertController.addAction(UIAlertAction(title: "Camera", style: .default){ action -> Void in
            self.openCemera()
        })
        
        alertController.addAction(UIAlertAction(title: "Gallary", style: .default){ action -> Void in
            self.openGallery()
        })
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel){ action -> Void in
           
        })
        self.present(alertController, animated: true, completion: nil)
    }
    
}



extension MyAccountVC:UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
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
    
    
    func openCemera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            if let cell = commonTableView.cellForRow(at: IndexPath(item: 0, section: 0)) as? ChooseProfilPpictureTVCell {
                cell.profileImg.image = pickedImage
            }
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}


extension MyAccountVC {
    
    
     func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell =  Bundle.main.loadNibNamed("ChooseProfilPpictureTVCell", owner: self, options: nil)?.first as! ChooseProfilPpictureTVCell
         cell.titlelbl.text = "Srinath"
         cell.profileImg.image = UIImage(named: "profile")
        return cell
    }
    
    
    
    
}
