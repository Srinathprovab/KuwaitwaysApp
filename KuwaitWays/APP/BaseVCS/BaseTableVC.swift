//
//  BaseTableVC.swift
//  Clique
//
//  Created by Codebele-03 on 03/06/21.
//

import UIKit

class BaseTableVC: UIViewController, ButtonTVCellDelegate,TextfieldTVCellDelegate, SelectGenderTVCellDelegate, RadioButtonTVCellDelegate, SignUpWithTVCellDelegate, MenuBGTVCellDelegate,LabelWithButtonTVCellDelegate, SelectTabTVCellDelegate, SearchFlightTVCellDelegate, TravellerEconomyTVCellDelegate, SearchFlightResultInfoTVCellDelegate, BookNowTVCellDelegate, TDetailsLoginTVCellDelegate,PromocodeTVCellDelegate, PriceSummaryTVCellDelegate, AddTravellersDetailsTVCellDelegate, CheckBoxTVCellDelegate,MultiCityTripTVCellDelegate, HotelSearchResultTVCellDelegate, RoomsTVCellDelegate, StarRatingTVCellDelegate, ChooseProfilPpictureTVCellDelegate,checkOptionsTVCellDelegate {
    
    
    
    
    
    @IBOutlet weak var commonScrollView: UITableView!
    @IBOutlet weak var commonTableView: UITableView!
    @IBOutlet weak var commonTVTopConstraint: NSLayoutConstraint!
    
    
    var commonTVData = [TableRow]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.modalPresentationCapturesStatusBarAppearance = true
        self.navigationController?.navigationBar.isHidden = true
        configureTableView()
        //        self.automaticallyAdjustsScrollViewInsets = false
        
        // Do any additional setup after loading the view.
    }
    
    
    func configureTableView() {
        if commonTableView != nil {
            makeDefaultConfigurationForTable(tableView: commonTableView)
        } else {
            print("commonTableView is nil")
        }
    }
    
    func makeDefaultConfigurationForTable(tableView: UITableView) {
        
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.tableFooterView = UIView()
        
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        } else {
            // Fallback on earlier versions
        }
    }
    
    func serviceCall_Completed_ForNoDataLabel(noDataMessage: String? = nil, data: [Any]? = nil, centerVal:CGFloat? = nil, color: UIColor = HexColor("#182541")) {
        dealWithNoDataLabel(message: noDataMessage, data: data, centerVal: centerVal ?? 2.0, color: color)
    }
    
    func dealWithNoDataLabel(message: String?, data: [Any]?, centerVal: CGFloat = 2.0, color: UIColor = HexColor("#182541")) {
        if commonTableView == nil { return; }
        
        commonTableView.viewWithTag(100)?.removeFromSuperview()
        
        if let message = message, let data = data {
            if data.count == 0 {
                let tableSize = commonTableView.frame.size
                
                let label = UILabel(frame: CGRect(x: 15, y: 15, width: tableSize.width, height: 60))
                label.center = CGPoint(x: (tableSize.width/2), y: (tableSize.height/centerVal))
                label.tag = 100
                label.numberOfLines = 0
                
                label.textAlignment = NSTextAlignment.center
                //                label.font = UIFont.CircularStdMedium(size: 14)
                label.textColor = color
                label.text = message
                
                commonTableView.addSubview(label)
            }
        }
        
    }
    
    
    //Delegate Methods
    func btnAction(cell: ButtonTVCell) {}
    func didTapOnForGetPassword(cell: TextfieldTVCell) {}
    func editingTextField(tf: UITextField) {}
    func didTapOnShowPasswordBtn(cell: TextfieldTVCell) {}
    func didSelectMaleRadioBtn(cell: SelectGenderTVCell) {}
    func didSelectOnFemaleBtn(cell: SelectGenderTVCell) {}
    func didTapOnSaveBtn(cell: SelectGenderTVCell) {}
    func didTapOnRadioButton(cell: RadioButtonTVCell) {}
    func didTapOnGoogleBtn(cell: SignUpWithTVCell) {}
    func didTapOnLoginBtn(cell: MenuBGTVCell) {}
    func didTapOnEditProfileBtn(cell: MenuBGTVCell) {}
    func didTapOnCountryCodeDropDownBtn(cell:TextfieldTVCell){}
    func didTapOnBackToLoginBtn(cell: LabelWithButtonTVCell) {}
    func didTapOnBackToCreateAccountBtn(cell: LabelWithButtonTVCell) {}
    func didTapOnDashboardTab(cell: SelectTabTVCell) {}
    func didTapOnFromCity(cell: HolderViewTVCell) {}
    func didTapOnToCity(cell: HolderViewTVCell) {}
    func didTapOnSelectDepDateBtn(cell: DualViewTVCell) {}
    func didTapOnSelectRepDateBtn(cell: DualViewTVCell) {}
    func didTapOnDecrementButton(cell: TravellerEconomyTVCell) {}
    func didTapOnIncrementButton(cell: TravellerEconomyTVCell) {}
    func didTapOnAddTravelerEconomy(cell:HolderViewTVCell){}
    func didTapOnSearchFlightsBtn(cell:SearchFlightTVCell){}
    func didTapOnRefunduableBtn(cell: SearchFlightResultInfoTVCell) {}
    func didTapOnBookNowBtn(cell: BookNowTVCell) {}
    func didTapOnLoginBtn(cell: TDetailsLoginTVCell) {}
    func didTapOnApplyBtn(cell: PromocodeTVCell) {}
    func didTapOnRefundBtn(cell: PriceSummaryTVCell) {}
    func didTapOnAddAdultBtn(cell: AddTravellersDetailsTVCell) {}
    func didTapOnCheckBoxDropDownBtn(cell: CheckBoxTVCell) {}
    func didTapOnShowMoreBtn(cell: CheckBoxTVCell) {}
    
    func didTapOnFromBtn(cell:MulticityFromToTVCell){}
    func didTapOnToBtn(cell:MulticityFromToTVCell){}
    func didTapOndateBtn(cell:MulticityFromToTVCell){}
    func didTapOnCloseBtn(cell:MulticityFromToTVCell){}
    func didTapOnAddTravellerEconomy(cell:HolderViewTVCell){}
    func didTapOnMultiCityTripSearchFlight(cell:ButtonTVCell){}
    
    func didTapOnLocationOrCityBtn(cell:HolderViewTVCell){}
    func didtapOnCheckInBtn(cell:DualViewTVCell){}
    func didtapOnCheckOutBtn(cell:DualViewTVCell){}
    func didTapOnSearchHotelsBtn(cell:ButtonTVCell){}
    func didTapOnDetailsBtn(cell: HotelSearchResultTVCell) {}
    func didTapOnCancellationPolicyBtn(cell: TwinSuperiorRoomTVCell) {}
    func didTapOnMenuBtn(cell:SelectTabTVCell){}
    func didTapOnLaungageBtn(cell:SelectTabTVCell){}
    func didTapOnStarRatingCell(cell: StarRatingCVCell) {}
    func didTapOnEditBtn(cell:TitleLblTVCell){}
    func donedatePicker(cell:TextfieldTVCell){}
    func cancelDatePicker(cell:TextfieldTVCell){}
    func didtapOnChooseprofilePitctureBtn(cell: ChooseProfilPpictureTVCell) {}
    func didTapOnMenuOptionBtn(cell:checkOptionsTVCell){}
    
    
    
    
    
    
    
    
    
    
    
}

extension BaseTableVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = commonTVData[indexPath.row].height
        
        if let height = height {
            return height
        }
        
        return UITableView.automaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
}
extension BaseTableVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == commonTableView {
            return commonTVData.count
        }else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var commonCell: TableViewCell!
        
        var data: TableRow?
        var commonTV = UITableView()
        
        if tableView == commonTableView {
            data = commonTVData[indexPath.row]
            commonTV = commonTableView
        }
        
        
        if let cellType = data?.cellType {
            switch cellType {
                
                //Sign & SignUp Cells
                
            case .EmptyTVCell:
                let cell: EmptyTVCell = commonTV.dequeTVCell(indexPath: indexPath)
                commonCell = cell
                
                
                
            case .ButtonTVCell:
                let cell: ButtonTVCell = commonTV.dequeTVCell(indexPath: indexPath)
                cell.delegate = self
                commonCell = cell
                
                
                
            case .TextfieldTVCell:
                let cell: TextfieldTVCell = commonTV.dequeTVCell(indexPath: indexPath)
                cell.delegate = self
                commonCell = cell
                
                
            case .SelectGenderTVCell:
                let cell: SelectGenderTVCell = commonTV.dequeTVCell(indexPath: indexPath)
                cell.delegate = self
                commonCell = cell
                
                
                
            case .RadioButtonTVCell:
                let cell: RadioButtonTVCell = commonTV.dequeTVCell(indexPath: indexPath)
                cell.delegate = self
                commonCell = cell
                
                
            case .LabelTVCell:
                let cell: LabelTVCell = commonTV.dequeTVCell(indexPath: indexPath)
                commonCell = cell
                
                
            case .SignUpWithTVCell:
                let cell: SignUpWithTVCell = commonTV.dequeTVCell(indexPath: indexPath)
                cell.delegate = self
                commonCell = cell
                
                
            case .LogoImgTVCell:
                let cell: LogoImgTVCell = commonTV.dequeTVCell(indexPath: indexPath)
                commonCell = cell
                
                
                
            case .MenuBGTVCell:
                let cell: MenuBGTVCell = commonTV.dequeTVCell(indexPath: indexPath)
                cell.delegate = self
                commonCell = cell
                
                
                
            case .UnderLineTVCell:
                let cell: UnderLineTVCell = commonTV.dequeTVCell(indexPath: indexPath)
                commonCell = cell
                
                
            case .LabelWithButtonTVCell:
                let cell: LabelWithButtonTVCell = commonTV.dequeTVCell(indexPath: indexPath)
                cell.delegate = self
                commonCell = cell
                
                
            case .SelectTabTVCell:
                let cell: SelectTabTVCell = commonTV.dequeTVCell(indexPath: indexPath)
                cell.delegate = self
                commonCell = cell
                
                
            case .HotelDealsTVCell:
                let cell: HotelDealsTVCell = commonTV.dequeTVCell(indexPath: indexPath)
                commonCell = cell
                
                
            case .SearchFlightTVCell:
                let cell: SearchFlightTVCell = commonTV.dequeTVCell(indexPath: indexPath)
                cell.delegate = self
                commonCell = cell
                
                
            case .FromCityTVCell:
                let cell: FromCityTVCell = commonTV.dequeTVCell(indexPath: indexPath)
                commonCell = cell
                
                
            case .TravellerEconomyTVCell:
                let cell: TravellerEconomyTVCell = commonTV.dequeTVCell(indexPath: indexPath)
                cell.delegate = self
                commonCell = cell
                
                
            case .TitleLblTVCell:
                let cell: TitleLblTVCell = commonTV.dequeTVCell(indexPath: indexPath)
                commonCell = cell
                
                
            case .SearchFlightResultInfoTVCell:
                let cell: SearchFlightResultInfoTVCell = commonTV.dequeTVCell(indexPath: indexPath)
                cell.delegate = self
                commonCell = cell
                
                
                
            case .BookNowTVCell:
                let cell: BookNowTVCell = commonTV.dequeTVCell(indexPath: indexPath)
                cell.delegate = self
                commonCell = cell
                
                
                
            case .FareBreakdownTVCell:
                let cell: FareBreakdownTVCell = commonTV.dequeTVCell(indexPath: indexPath)
                commonCell = cell
                
                
                
            case .TDetailsLoginTVCell:
                let cell: TDetailsLoginTVCell = commonTV.dequeTVCell(indexPath: indexPath)
                cell.delegate = self
                commonCell = cell
                
                
                
            case .PromocodeTVCell:
                let cell: PromocodeTVCell = commonTV.dequeTVCell(indexPath: indexPath)
                cell.delegate = self
                commonCell = cell
                
                
                
            case .PriceSummaryTVCell:
                let cell: PriceSummaryTVCell = commonTV.dequeTVCell(indexPath: indexPath)
                cell.delegate = self
                commonCell = cell
                
                
            case .checkOptionsTVCell:
                let cell: checkOptionsTVCell = commonTV.dequeTVCell(indexPath: indexPath)
                cell.delegate = self
                commonCell = cell
                
                
            case .AddTravellersDetailsTVCell:
                let cell: AddTravellersDetailsTVCell = commonTV.dequeTVCell(indexPath: indexPath)
                cell.delegate = self
                commonCell = cell
                
                
            case .SliderTVCell:
                let cell: SliderTVCell = commonTV.dequeTVCell(indexPath: indexPath)
                commonCell = cell
                
                
                
            case .CheckBoxTVCell:
                let cell: CheckBoxTVCell = commonTV.dequeTVCell(indexPath: indexPath)
                cell.delegate = self
                commonCell = cell
                
                
            case .MultiCityTripTVCell:
                let cell: MultiCityTripTVCell = commonTV.dequeTVCell(indexPath: indexPath)
                cell.delegate = self
                commonCell = cell
                
                
                
            case .HotelSearchResultTVCell:
                let cell: HotelSearchResultTVCell = commonTV.dequeTVCell(indexPath: indexPath)
                cell.delegate = self
                commonCell = cell
                
                
                
            case .RatingWithLabelsTVCell:
                let cell: RatingWithLabelsTVCell = commonTV.dequeTVCell(indexPath: indexPath)
                commonCell = cell
                
                
                
            case .FacilitiesTVCell:
                let cell: FacilitiesTVCell = commonTV.dequeTVCell(indexPath: indexPath)
                commonCell = cell
                
                
                
            case .HotelImagesTVCell:
                let cell: HotelImagesTVCell = commonTV.dequeTVCell(indexPath: indexPath)
                commonCell = cell
                
                
                
            case .RoomsTVCell:
                let cell: RoomsTVCell = commonTV.dequeTVCell(indexPath: indexPath)
                cell.delegate = self
                commonCell = cell
                
                
                
            case .PriceLabelsTVCell:
                let cell: PriceLabelsTVCell = commonTV.dequeTVCell(indexPath: indexPath)
                commonCell = cell
                
                
                
            case .SelectLanguageTVCell:
                let cell: SelectLanguageTVCell = commonTV.dequeTVCell(indexPath: indexPath)
                commonCell = cell
                
                
                
            case .StarRatingTVCell:
                let cell: StarRatingTVCell = commonTV.dequeTVCell(indexPath: indexPath)
                cell.delegate = self
                commonCell = cell
                
                
                
            case .ChooseProfilPpictureTVCell:
                let cell: ChooseProfilPpictureTVCell = commonTV.dequeTVCell(indexPath: indexPath)
                cell.delegate = self
                commonCell = cell
                
                
            default:
                print("handle this case in getCurrentCellAt")
            }
        }
        
        commonCell.cellInfo = data
        commonCell.indexPath = indexPath
        commonCell.selectionStyle = .none
        
        return commonCell
    }
} 



extension UITableView {
    func registerTVCells(_ classNames: [String]) {
        for className in classNames {
            register(UINib(nibName: className, bundle: nil), forCellReuseIdentifier: className)
        }
    }
    
    func dequeTVCell<T: UITableViewCell>(indexPath: IndexPath, osVersion: String? = nil) -> T {
        let className = String(describing: T.self) + "\(osVersion ?? "")"
        guard let cell = dequeueReusableCell(withIdentifier: className, for: indexPath) as? T  else { fatalError("Couldn’t get cell with identifier \(className)") }
        return cell
    }
    
    func dequeTVCellForFooter<T: UITableViewCell>() -> T {
        let className = String(describing: T.self)
        guard let cell = dequeueReusableCell(withIdentifier: className) as? T  else { fatalError("Couldn’t get cell with identifier \(className)") }
        return cell
    }
    
}
