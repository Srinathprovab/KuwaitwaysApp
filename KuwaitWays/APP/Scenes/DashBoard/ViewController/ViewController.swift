//
//  ViewController.swift
//  BeeoonsApp
//
//  Created by MA673 on 12/08/22.
//

import UIKit

//MARK: - INITIAL SETUP LABELS
func setuplabels(lbl:UILabel,text:String,textcolor:UIColor,font:UIFont,align:NSTextAlignment) {
    lbl.text = text
    lbl.textColor = textcolor
    lbl.font = font
    lbl.numberOfLines = 0
    lbl.textAlignment = align
}

//MARK: - convert Date Format
func convertDateFormat(inputDate: String,f1:String,f2:String) -> String {
    
    let olDateFormatter = DateFormatter()
    olDateFormatter.dateFormat = f1
    
    guard let oldDate = olDateFormatter.date(from: inputDate) else { return "" }
    
    let convertDateFormatter = DateFormatter()
    convertDateFormatter.dateFormat = f2
    
    return convertDateFormatter.string(from: oldDate)
}


//MARK: - check Departure And Return Dates
func checkDepartureAndReturnDates1(_ parameters: [String: Any],p1:String) -> Bool {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd-MM-yyyy"
    
    guard let departureDateStr = parameters[p1] as? String,
          let departureDate = dateFormatter.date(from: departureDateStr)
    else {
        print("Invalid date format")
        return false
    }
    
    let calendar = Calendar.current
    let currentDate = Date()
    
    if calendar.isDateInTomorrow(departureDate) {
        print("Departure is tomorrow's date")
        return true
    } else if departureDate > currentDate {
        print("Departure is a future date")
        return true
    } else {
        print("Departure is not a future or tomorrow's date")
        return false
    }
    
    
}






//MARK: - check Departure And Return Dates
func checkDepartureAndReturnDates(_ parameters: [String: Any],p1:String,p2:String) -> Bool {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd-MM-yyyy"
    
    guard let departureDateStr = parameters[p1] as? String,
          let returnDateStr = parameters[p2] as? String,
          let departureDate = dateFormatter.date(from: departureDateStr),
          let returnDate = dateFormatter.date(from: returnDateStr) else {
        print("Invalid date format")
        return false
    }
    
    let calendar = Calendar.current
    let currentDate = Date()
    
    if calendar.isDateInTomorrow(departureDate) {
        print("Departure is tomorrow's date")
        return true
    } else if departureDate > currentDate {
        print("Departure is a future date")
        return true
    } else {
        print("Departure is not a future or tomorrow's date")
        return false
    }
    
    if calendar.isDateInTomorrow(returnDate) {
        print("Return is tomorrow's date")
        return true
    } else if returnDate > currentDate {
        print("Return is a future date")
        return true
    } else {
        print("Return is not a future or tomorrow's date")
        return false
    }
}


class ViewController: UIViewController {
    
    var ExecuteOnceBool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if !UserDefaults.standard.bool(forKey: "ExecuteOnceLoginVC") {
            ExecuteOnceBool = false
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                self.gotoLoginVC()
            })
            
            UserDefaults.standard.set(true, forKey: "ExecuteOnceLoginVC")
        }
        
        
        if ExecuteOnceBool == true {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                self.gotodashBoardScreen()
            })
        }
        
    }
    
    
    func gotodashBoardScreen() {
        guard let vc = DBTabbarController.newInstance.self else {return}
        vc.modalPresentationStyle = .fullScreen
        vc.selectedIndex = 0
        callapibool = true
        present(vc, animated: true)
    }
    
    func gotoLoginVC() {
        guard let vc = LoginVC.newInstance.self else {return}
        vc.modalPresentationStyle = .fullScreen
        callapibool = true
        vc.isvcfrom = "ViewController"
        present(vc, animated: true)
    }
    
    
}





protocol TimerManagerDelegate: AnyObject {
    func timerDidFinish()
    func updateTimer()
}


class TimerManager {
    static let shared = TimerManager() // Singleton instance
    weak var delegate: TimerManagerDelegate?
    
    var timer: Timer?
    var totalTime = 1
    private var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    
    private init() {}
    
    func startTimer() {
        
        
        endBackgroundTask() // End any existing background task (if any)
        backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
            self?.endBackgroundTask()
        }
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: RunLoop.Mode.common)
        
        
    }
    
    @objc func updateTimer() {
        if totalTime != 0 {
            totalTime -= 1
            delegate?.updateTimer()
        } else {
            sessionStop()
            delegate?.timerDidFinish()
            endBackgroundTask()
        }
    }
    
    @objc func sessionStop() {
        if let timer = timer {
            timer.invalidate()
            self.timer = nil
        }
    }
    
    private func endBackgroundTask() {
        guard backgroundTask != .invalid else { return }
        UIApplication.shared.endBackgroundTask(backgroundTask)
        backgroundTask = .invalid
    }
}

