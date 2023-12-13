//
//  CalenderVC.swift
//  BabSafar
//
//  Created by MA673 on 20/07/22.
//

import UIKit
import JTAppleCalendar


class CalenderVC: BaseTableVC {
    
    @IBOutlet weak var nav: NavBar!
    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var calendarViewHolder: UIView!
    @IBOutlet weak var calendarView: JTAppleCalendarView!
       @IBOutlet weak var leftButton: UIButton!
    //    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var sundayLabel: UILabel!
    @IBOutlet weak var mondayLabel: UILabel!
    @IBOutlet weak var tuesdayLabel: UILabel!
    @IBOutlet weak var thursdayLabel: UILabel!
    @IBOutlet weak var wednesdayLabel: UILabel!
    @IBOutlet weak var fridayLabel: UILabel!
    @IBOutlet weak var saturdayLabel: UILabel!
    
    @IBOutlet weak var selectBtn: UIButton!
    @IBOutlet weak var selectBtnView: UIView!
    @IBOutlet weak var selectlbl: UILabel!
    @IBOutlet weak var leftButtonView: UIView!
    
    
    
    static var newInstance: CalenderVC? {
        let storyboard = UIStoryboard(name: Storyboard.Main.name,
                                      bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: self.className()) as? CalenderVC
        return vc
    }
    
    var titleStr: String?
    
    var selectedfirstDate : Date?
    var selectedlastDate : Date?
    let df = DateFormatter()
    var startDate = Date().dateByAddingMonths(months: -12).startOfMonth
    var endDate = Date().dateByAddingMonths(months: 12).endOfMonth
    var selectedDays: Date?
    let grayView = UIView()
    var btnDoneActionBool = Bool()
    var calstartDate = String()
    var calendDate = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupUI()
        updateUI()
        setupCalView()
        
       
    }
    

    
    func setupUI() {
        nav.titlelbl.text = "Calendar"
        nav.backBtn.addTarget(self, action: #selector(backbtnAction(_:)), for: .touchUpInside)
        selectBtn.setTitle("", for: .normal)
        setupViews(v: selectBtnView, radius: 4, color: .AppNavBackColor)
        setupLabels(lbl: selectlbl, text: "Select", textcolor: .WhiteColor, font: .LatoSemibold(size: 20))
    }
    
    @objc func backbtnAction(_ sender:UIButton) {
        self.dismiss(animated: true)
    }
    
    func setupViews(v:UIView,radius:CGFloat,color:UIColor) {
        v.backgroundColor = color
        v.layer.cornerRadius = radius
        v.clipsToBounds = true
        v.layer.borderWidth = 0.5
        v.layer.borderColor = UIColor.AppBorderColor.cgColor
    }
    
    func setupLabels(lbl:UILabel,text:String,textcolor:UIColor,font:UIFont) {
        lbl.text = text
        lbl.textColor = textcolor
        lbl.font = font
    }
    
    func updateUI() {
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        holderView.backgroundColor = .white
        holderView.layer.shadowColor = UIColor.lightGray.cgColor
        holderView.layer.shadowOpacity = 1
        holderView.layer.shadowOffset = .zero
        holderView.layer.shadowRadius = 5
        
        
        monthLabel.textColor = .AppLabelColor
        monthLabel.font = UIFont.LatoRegular(size: 24)
        monthLabel.textAlignment = .left
        
        sundayLabel.textColor = HexColor("#555555")
        sundayLabel.font = UIFont.LatoRegular(size: 14)
        sundayLabel.text = "SU"
        
        mondayLabel.textColor = HexColor("#555555")
        mondayLabel.font = UIFont.LatoRegular(size: 14)
        mondayLabel.text = "MO"
        
        tuesdayLabel.textColor = HexColor("#555555")
        tuesdayLabel.font = UIFont.LatoRegular(size: 14)
        tuesdayLabel.text = "TU"
        
        wednesdayLabel.textColor = HexColor("#555555")
        wednesdayLabel.font = UIFont.LatoRegular(size: 14)
        wednesdayLabel.text = "WE"
        
        thursdayLabel.textColor = HexColor("#555555")
        thursdayLabel.font = UIFont.LatoRegular(size: 14)
        thursdayLabel.text = "TH"
        
        fridayLabel.textColor = HexColor("#555555")
        fridayLabel.font = UIFont.LatoRegular(size: 14)
        fridayLabel.text = "FR"
        
        saturdayLabel.textColor = HexColor("#555555")
        saturdayLabel.font = UIFont.LatoRegular(size: 14)
        saturdayLabel.text = "SA"
        
        
        nav.isHidden = true
        self.view.backgroundColor = .black.withAlphaComponent(0.70)
        selectBtnView.isHidden = true
    }
    
    
    func setupCalView() {
        
        
        calendarViewHolder.backgroundColor = .clear
        
        // Do any additional setup after loading the view.
        calendarView.scrollDirection  = .vertical
        calendarView.scrollingMode = .stopAtEachSection
        calendarView.showsHorizontalScrollIndicator = false
        
        calendarView.scrollToDate(Date(),animateScroll: false)
        
        calendarView.register(UINib(nibName: "calendarCVCell", bundle: nil), forCellWithReuseIdentifier: "calendarCVCell")
        //        calendarView.allowsSelection = true
        let journyType = defaults.string(forKey: UserDefaultsKeys.journeyType)
        if journyType == "oneway" {
            calendarView.allowsMultipleSelection = false
        }else {
            calendarView.allowsMultipleSelection = true
        }
        
        if defaults.string(forKey: UserDefaultsKeys.tabselect) == "Hotel" {
            calendarView.allowsMultipleSelection = true
        }
        
        
        calendarView.isRangeSelectionUsed = true
        
        calendarView.ibCalendarDelegate = self
        calendarView.ibCalendarDataSource = self
        calendarView.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        calendarView.minimumLineSpacing = 5
        calendarView.minimumInteritemSpacing = 5
        
        
        calendarView.visibleDates { (visibleDates) in
            self.setupMonthLabel(date: visibleDates.monthDates.first?.date ?? Date())
        }
        
        let panGensture = UILongPressGestureRecognizer(target: self, action: #selector(didStartRangeSelecting(gesture:)))
        panGensture.minimumPressDuration = 0.5
        calendarView.addGestureRecognizer(panGensture)
        
    }
    
    
    @objc func didStartRangeSelecting(gesture: UITapGestureRecognizer) {
        let point = gesture.location(in: gesture.view!)
        let rangeSelectedDates = calendarView.selectedDates
        
        guard let cellState = calendarView.cellStatus(at: point) else { return }
        
        if !rangeSelectedDates.contains(cellState.date) {
            let dateRange = calendarView.generateDateRange(from: rangeSelectedDates.first ?? cellState.date, to: cellState.date)
            calendarView.selectDates(dateRange, keepSelectionIfMultiSelectionAllowed: true)
        }
    }
    
    func setupMonthLabel(date: Date) {
        monthLabel.text = date.monthYearName
    }
    
    
    func handleConfiguration(cell: JTAppleCell?, cellState: CellState) {
        guard let cell = cell as? calendarCVCell else { return }
        handleCellColor(cell: cell, cellState: cellState)
        handleCellSelected(cell: cell, cellState: cellState)
        
        if calendarView.selectedDates.count == 0 {
            
        }else if calendarView.selectedDates.count == 1 {
            
            calstartDate = "\(cellState.date.customDateStringFormat("dd-MM-YYYY"))"
            calendDate = "\(cellState.date.customDateStringFormat("dd-MM-YYYY"))"
            
        }else {
            
            
            calstartDate = calendarView.selectedDates.first?.customDateStringFormat("dd-MM-YYYY") ?? ""
            calendDate = calendarView.selectedDates.last?.customDateStringFormat("dd-MM-YYYY") ?? ""
            
            
        }
    }
    
    
    func handleCellColor(cell: calendarCVCell, cellState: CellState) {
        if cellState.dateBelongsTo == .thisMonth {
            cell.label.textColor = UIColor.black
        } else {
            cell.label.textColor = UIColor.lightGray
        }
    }
    
    func handleCellSelected(cell: calendarCVCell, cellState: CellState) {
        cell.selectedView.isHidden = !cellState.isSelected
        
        
        cell.selectedView.layer.cornerRadius = cell.selectedView.frame.width / 2
        cell.selectedView.clipsToBounds = true
        
        switch cellState.selectedPosition() {
        case .left:
//            cell.selectedView.layer.cornerRadius = 0
//            cell.selectedView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
            cell.selectedView.isHidden = false
            cell.selectedView.backgroundColor = UIColor.AppNavBackColor
            cell.label.textColor = UIColor.white
            break
        case .middle:
//            cell.selectedView.layer.cornerRadius = 0
//            cell.selectedView.layer.maskedCorners = []
            cell.selectedView.isHidden = false
            cell.selectedView.backgroundColor = UIColor.AppNavBackColor.withAlphaComponent(0.3)
            cell.label.textColor = UIColor.AppLabelColor.withAlphaComponent(0.4)
            break
        case .right:
//            cell.selectedView.layer.cornerRadius = 0
//            cell.selectedView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
            cell.selectedView.isHidden = false
            cell.selectedView.backgroundColor = UIColor.AppNavBackColor
            cell.label.textColor = UIColor.white
            break
        case .full:
//            cell.selectedView.layer.cornerRadius = 0
//            cell.selectedView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
            cell.selectedView.isHidden = false
            cell.selectedView.backgroundColor = UIColor.AppNavBackColor
            cell.label.textColor = UIColor.white
            break
            
        default:
            break
            
        }
    }
    
    
    
    
        @IBAction func leftButtonClick(_ sender: Any) {
            calendarView.scrollToSegment(.previous)
        }
    
        @IBAction func rightButtonClick(_ sender: Any) {
            calendarView.scrollToSegment(.next)
        }
    
    
    @IBAction func didTapOnBackButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func didTapOnDepartureBtnAction(_ sender: Any) {
        print("didTapOnDepartureBtnAction")
    }
    
    
    @IBAction func didTapOnReturnBtnAction(_ sender: Any) {
        print("didTapOnReturnBtnAction")
    }
    
    
    @IBAction func selectDateBtnAction(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("reload"), object: nil)
        dismiss(animated: false)
    }
    
    
    
    @IBAction func didTapOnOkBtn(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("reload"), object: nil)
        dismiss(animated: false)
    }
    
    
    
    @IBAction func didTapOnCloseBtnAction(_ sender: Any) {
        dismiss(animated: false)
    }
    
}



extension CalenderVC: JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource {
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        
        handleConfiguration(cell: cell, cellState: cellState)
        
    }

    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "calendarCVCell", for: indexPath) as! calendarCVCell
        cell.label.text = cellState.text
        // cell.holderView.backgroundColor = HexColor("#ECF3FD")
        handleConfiguration(cell: cell, cellState: cellState)
        //        self.calendar(calendar, willDisplay: cell, forItemAt: date, cellState: cellState, indexPath: indexPath)

        if cellState.dateBelongsTo == .thisMonth {
            cell.isHidden = false
        } else {
            cell.isHidden = true
        }

        if date <= Date(){
            cell.label.textColor = HexColor("#555555", alpha: 0.4)
//            leftButtonView.alpha = 0.5
//            leftButton.isUserInteractionEnabled = false
        }else {
            cell.label.textColor = HexColor("#555555")
//            leftButtonView.alpha = 1
//            leftButton.isUserInteractionEnabled = true
        }



        return cell
    }
    

    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setupMonthLabel(date: visibleDates.monthDates.first!.date)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleConfiguration(cell: cell, cellState: cellState)
        print(cellState.date.customDateStringFormat())
        print("start date  : \(calstartDate)")
        print("End date  : \(calendDate)")
        
        
        if let selectedTab = defaults.string(forKey: UserDefaultsKeys.tabselect) {
            if selectedTab == "Flight" {
                
                if let selectedJourneyType = defaults.string(forKey: UserDefaultsKeys.journeyType) {
                    if selectedJourneyType == "oneway" {
                        defaults.set(calstartDate, forKey: UserDefaultsKeys.calDepDate)
                    }else if selectedJourneyType == "circle" {
                        defaults.set(calstartDate, forKey: UserDefaultsKeys.calDepDate)
                        defaults.set(calendDate, forKey: UserDefaultsKeys.calRetDate)
                    }else {
                        print("mcalDepDate\(calstartDate)")
                        defaults.set(calstartDate, forKey: UserDefaultsKeys.calDepDate)
                    }
                }
                
                
            }else {
                defaults.set(calstartDate, forKey: UserDefaultsKeys.checkin)
                defaults.set(calendDate, forKey: UserDefaultsKeys.checkout)
            }
        }
        
        
        
        if selectedfirstDate != nil {
            if date < selectedfirstDate! {
                calendarView.selectDates(from: date, to: selectedfirstDate!,  triggerSelectionDelegate: false, keepSelectionIfMultiSelectionAllowed: true)
                selectedlastDate = calendarView.selectedDates.last
                selectedfirstDate = calendarView.selectedDates.first
                
            } else {
                selectedlastDate = calendarView.selectedDates.last
                calendarView.selectDates(from: selectedfirstDate!, to: date,  triggerSelectionDelegate: false, keepSelectionIfMultiSelectionAllowed: true)
            }
        } else {
            selectedfirstDate = calendarView.selectedDates.first
            selectedlastDate = nil
            handleConfiguration(cell: cell, cellState: cellState)
        }
        
       
        
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleConfiguration(cell: cell, cellState: cellState)
        
        if selectedfirstDate != nil{
            if date > (selectedfirstDate!){
                calendarView.deselectDates(from: selectedfirstDate!, to: date, triggerSelectionDelegate: false)
                selectedfirstDate = calendarView.selectedDates.first
            } else if selectedlastDate == nil || date == selectedlastDate {
                selectedfirstDate = nil
                selectedlastDate = nil
                handleConfiguration(cell: cell, cellState: cellState)
                
            }else {
                handleConfiguration(cell: cell, cellState: cellState)
            }
        }
    }
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        
        print("configureCalendar")
        let parameter = ConfigurationParameters(startDate: self.startDate,
                                                endDate: self.endDate,
                                                numberOfRows: 6,
                                                generateInDates: .forAllMonths,
                                                generateOutDates: .tillEndOfGrid,
                                                firstDayOfWeek: .monday,
                                                hasStrictBoundaries:true)
        return parameter
    }
    
    func calendar(_ calendar: JTAppleCalendarView, shouldSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) -> Bool {
        return date >= Date()
    }
    
    
    
    
    
}
