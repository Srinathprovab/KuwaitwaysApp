//
//  DashBoardVC.swift
//  BeeoonsApp
//
//  Created by MA673 on 16/08/22.
//

import UIKit

class DashBoardVC: BaseTableVC {
    
    
    var tablerow = [TableRow]()
    static var newInstance: DashBoardVC? {
        let storyboard = UIStoryboard(name: Storyboard.Main.name,
                                      bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: self.className()) as? DashBoardVC
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupTV()
    }
    
    func setupTV() {
        self.view.backgroundColor = .AppBGcolor
        commonTableView.registerTVCells(["EmptyTVCell","SelectTabTVCell","HotelDealsTVCell","LabelTVCell"])
        appendLoginTvcells()
    }
    
    
    func appendLoginTvcells() {
        tablerow.removeAll()
        
        if screenHeight > 800 {
            tablerow.append(TableRow(height:80, bgColor:.AppBackgroundColor,cellType:.EmptyTVCell))
        }else {
            tablerow.append(TableRow(height:40, bgColor:.AppBackgroundColor,cellType:.EmptyTVCell))
        }
        
        tablerow.append(TableRow(cellType:.SelectTabTVCell))
        tablerow.append(TableRow(height:10,bgColor: .AppBGcolor,cellType:.EmptyTVCell))
        tablerow.append(TableRow(title:"Best Deals Flights ",subTitle: "Deals from your favorite booking sites, All in one place.",key: "deals",cellType:.LabelTVCell))
        tablerow.append(TableRow(height:18,bgColor: .AppBGcolor,cellType:.EmptyTVCell))
        tablerow.append(TableRow(key1:"hotel",cellType:.HotelDealsTVCell))
        
        tablerow.append(TableRow(height:18,bgColor: .AppBGcolor,cellType:.EmptyTVCell))
        tablerow.append(TableRow(title:"Best Deals Hotels ",subTitle: "Popular International Flights From Kuwait",key: "deals",cellType:.LabelTVCell))
        tablerow.append(TableRow(height:18,bgColor: .AppBGcolor,cellType:.EmptyTVCell))
        tablerow.append(TableRow(key1:"flight",cellType:.HotelDealsTVCell))
        tablerow.append(TableRow(height:30,bgColor: .AppBGcolor,cellType:.EmptyTVCell))

        commonTVData = tablerow
        commonTableView.reloadData()
        
    }
    
    
    override func didTapOnDashboardTab(cell: SelectTabTVCell) {
        
        let tabselect = defaults.string(forKey: UserDefaultsKeys.tabselect)
        switch tabselect {
        case "Flight":
            gotoBookingFlightVC()
            break
            
        case "Hotel":
            gotoBookHotelVC()
            break
        default:
            break
        }
    }
    
    
    func gotoBookingFlightVC() {
        guard let vc = BookFlightVC.newInstance.self else {return}
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    func gotoBookHotelVC() {
        guard let vc = BookHotelVC.newInstance.self else {return}
        vc.modalPresentationStyle = .fullScreen
        vc.isVcFrom = "dashboard"
        self.present(vc, animated: true)
    }
    
    
    func gotoSideMenuVC() {
        guard let vc = SideMenuVC.newInstance.self else {return}
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: false)
    }
    
    
    override func didTapOnMenuBtn(cell:SelectTabTVCell){
        gotoSideMenuVC()
    }
    
    
    override func didTapOnLaungageBtn(cell:SelectTabTVCell){
        guard let vc = SelectLanguageVC.newInstance.self else {return}
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true)
    }
    
}
