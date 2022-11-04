//
//  SelectedHotelInfoVC.swift
//  BeeoonsApp
//
//  Created by MA673 on 22/08/22.
//

import UIKit

class SelectedHotelInfoVC: BaseTableVC {
    
    @IBOutlet weak var nav: NavBar!
    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var navHeight: NSLayoutConstraint!
    
    
    
    var isVcFrom = String()
    var tablerow = [TableRow]()
    var desc = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Feugiat ut tristique velit in. Dis cursus gravida lorem non consectetur morbi morbi. Ultrices egestas id malesuada justo. Massa ac euismod accumsan tellus turpis."
    static var newInstance: SelectedHotelInfoVC? {
        let storyboard = UIStoryboard(name: Storyboard.Hotel.name,
                                      bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: self.className()) as? SelectedHotelInfoVC
        return vc
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
    }
    
    func setupUI() {
        
        self.view.backgroundColor = .black.withAlphaComponent(0.4)
        self.holderView.backgroundColor = .AppBackgroundColor
        nav.titlelbl.text = ""
        nav.backBtn.addTarget(self, action: #selector(backbtnAction(_:)), for: .touchUpInside)
        nav.citylbl.isHidden = false
        nav.datelbl.isHidden = false
        nav.travellerlbl.isHidden = false
        
        nav.citylbl.text = "\(defaults.string(forKey: UserDefaultsKeys.locationcity) ?? "")"
        nav.datelbl.text = "CheckIn -\(defaults.string(forKey: UserDefaultsKeys.checkin) ?? "" ) CheckOut -\(defaults.string(forKey: UserDefaultsKeys.checkin) ?? "")"
        nav.travellerlbl.text = "Guests- 1 / Room - 1"
        
        if screenHeight > 800 {
            navHeight.constant = 190
        }else {
            navHeight.constant = 160
        }
        
        
        commonTableView.registerTVCells(["EmptyTVCell","HotelSearchResultTVCell","RatingWithLabelsTVCell","FacilitiesTVCell","HotelImagesTVCell","RoomsTVCell"])
        appendHotelSearctTvcells(str: "hotel")
    }
    
    
    @objc func backbtnAction(_ sender:UIButton) {
        dismiss(animated: true)
    }
    
    func appendHotelSearctTvcells(str:String) {
        tablerow.removeAll()
        
        tablerow.append(TableRow(title:"Golden Tulip Deira( Former Nihal Palace)",subTitle: "Deira, Al Rigga Street, Clock Tower,DUBAI, 33214",key:"rating", characterLimit: 4,cellType:.RatingWithLabelsTVCell))
        tablerow.append(TableRow(height:20,cellType:.EmptyTVCell))
        tablerow.append(TableRow(cellType:.HotelImagesTVCell))
        tablerow.append(TableRow(title:"Description",subTitle: desc,cellType:.RatingWithLabelsTVCell))
       
        if isVcFrom != "PayNowVC" {
            tablerow.append(TableRow(title:"Rooms",cellType:.RoomsTVCell))
        }
        tablerow.append(TableRow(title:"Facilities",cellType:.FacilitiesTVCell))
        tablerow.append(TableRow(height:50,cellType:.EmptyTVCell))
        
        
        commonTVData = tablerow
        commonTableView.reloadData()
        
    }
    
    func setupLabels(lbl:UILabel,text:String,textcolor:UIColor,font:UIFont) {
        lbl.text = text
        lbl.textColor = textcolor
        lbl.font = font
    }
    
    func setupViews(v:UIView,radius:CGFloat,color:UIColor) {
        v.backgroundColor = color
        v.layer.cornerRadius = radius
        v.clipsToBounds = true
        v.layer.borderWidth = 0.2
        v.layer.borderColor = UIColor.AppBorderColor.cgColor
    }
    
    
    override func didTapOnCancellationPolicyBtn(cell: TwinSuperiorRoomTVCell) {
        print("didTapOnCancellationPolicyBtn")
    }
    
    @objc func didTapOnBookNowBtn(_ sender:UIButton) {
        guard let vc = PayNowVC.newInstance.self else {return}
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false)
    }
    
    
}


extension SelectedHotelInfoVC {
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        if isVcFrom != "PayNowVC" {
            let cell =  Bundle.main.loadNibNamed("BookNowTVCell", owner: self, options: nil)?.first as! BookNowTVCell
            cell.bookNowlbl.text = "Continue"
            cell.bookNowBtn.addTarget(self, action: #selector(didTapOnBookNowBtn(_:)), for: .touchUpInside)
            return cell
        }else {
            return UIView()
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 60
    }
}
