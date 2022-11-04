//
//  SideMenuVC.swift
//  BabSafar
//
//  Created by MA673 on 21/07/22.
//

import UIKit

class SideMenuVC: BaseTableVC {
    
    @IBOutlet weak var holderView: UIView!
    
    static var newInstance: SideMenuVC? {
        let storyboard = UIStoryboard(name: Storyboard.Main.name,
                                      bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: self.className()) as? SideMenuVC
        return vc
    }
    var tablerow = [TableRow]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .black.withAlphaComponent(0.5)
        setupMenuTVCells()
        
        holderView.backgroundColor = .clear
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeDown.direction = .left
        self.view.addGestureRecognizer(swipeDown)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.holderView.addGestureRecognizer(tap)
        
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        dismiss(animated: false)
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
            case .left:
                dismiss(animated: false)
            default:
                break
            }
        }
    }
    
    
    
    func setupMenuTVCells() {
        let screenHeight = UIScreen.main.bounds.size.height
        if screenHeight > 800 {
            commonTableView.isScrollEnabled = false
        }else {
            commonTableView.isScrollEnabled = true
        }
        
        
        commonTableView.registerTVCells(["MenuBGTVCell","checkOptionsTVCell","EmptyTVCell"])
        tablerow.removeAll()
        tablerow.append(TableRow(cellType:.MenuBGTVCell))
        tablerow.append(TableRow(height:30,cellType:.EmptyTVCell))
        tablerow.append(TableRow(title:"My Bookings",key: "menu", image: "menu1",cellType:.checkOptionsTVCell))
        tablerow.append(TableRow(title:"Discover Beeoons",key: "menu", image: "menu2",cellType:.checkOptionsTVCell))
        tablerow.append(TableRow(title:"Your Property",key: "menu", image: "menu3",cellType:.checkOptionsTVCell))
        tablerow.append(TableRow(title:"Customer Support",key: "menu", image: "menu4",cellType:.checkOptionsTVCell))
        tablerow.append(TableRow(title:"Our Products",key: "ourproducts", image: "",cellType:.checkOptionsTVCell))
        
        tablerow.append(TableRow(title:"Flights",key: "menu", image: "menu5",cellType:.checkOptionsTVCell))
        tablerow.append(TableRow(title:"Hotels",key: "menu", image: "menu6",cellType:.checkOptionsTVCell))
        tablerow.append(TableRow(title:"Private Jet",key: "menu", image: "menu7",cellType:.checkOptionsTVCell))
        tablerow.append(TableRow(title:"Rent a Car",key: "menu", image: "menu8",cellType:.checkOptionsTVCell))
        tablerow.append(TableRow(title:"Transfer",key: "menu", image: "menu9",cellType:.checkOptionsTVCell))
        tablerow.append(TableRow(title:"Events",key: "menu", image: "menu10",cellType:.checkOptionsTVCell))
        
        tablerow.append(TableRow(height:30,cellType:.EmptyTVCell))
        tablerow.append(TableRow(title:"Logout",key: "menu", image: "logout",cellType:.checkOptionsTVCell))
        tablerow.append(TableRow(height:30,cellType:.EmptyTVCell))
        commonTVData = tablerow
        commonTableView.reloadData()
    }
    
    
    override func didTapOnLoginBtn(cell: MenuBGTVCell) {
        guard let vc = LoginVC.newInstance.self else {return}
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true)
        
    }
    
    
    override func didTapOnEditProfileBtn(cell: MenuBGTVCell) {
        guard let vc = EditProfileVC.newInstance.self else {return}
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true)
    }
    
    
    override func didTapOnMenuOptionBtn(cell:checkOptionsTVCell){
        switch cell.titlelbl.text {
        case "My Bookings":
            gotoMyBookingVC()
            break
            
        case "Flights":
            gotoBookFlightsVC()
            break
            
        case "Hotels":
            gotoBookHotelsVC()
            break
            
        default:
            break
        }
    }
    
    func gotoBookFlightsVC() {
        guard let vc = BookFlightVC.newInstance.self else {return}
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true)
    }
    
    func gotoBookHotelsVC() {
        guard let vc = BookHotelVC.newInstance.self else {return}
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true)
    }
    
    func gotoMyBookingVC() {
        guard let vc = DBTabbarController.newInstance.self else {return}
        vc.modalPresentationStyle = .overCurrentContext
        vc.selectedIndex = 1
        present(vc, animated: true)
    }
    
}

