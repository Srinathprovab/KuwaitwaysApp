//
//  ContactUsVC.swift
//  KuwaitWays
//
//  Created by FCI on 20/12/23.
//

import UIKit
import MessageUI

class ContactUsVC: BaseTableVC {
    
    
    static var newInstance: ContactUsVC? {
        let storyboard = UIStoryboard(name: Storyboard.Main.name,
                                      bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: self.className()) as? ContactUsVC
        return vc
    }
    
    var tablerow = [TableRow]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupUI()
    }
    
    func setupUI() {
        commonTableView.registerTVCells(["ContactUsTVCell"])
        setupTVCells()
    }
    
    
    func setupTVCells() {
        tablerow.removeAll()
        
        tablerow.append(TableRow(cellType:.ContactUsTVCell))
        
        commonTVData = tablerow
        commonTableView.reloadData()
    }
    
    override func didTapOnMailBtnAction(cell: ContactUsTVCell) {
        openEmail(mailstr: "reservation@kuwaitways.com")
    }
    
    override func didTapOnPhoneBtnAction(cell: ContactUsTVCell) {
        let phoneNumber = "+965 22092007" // Replace with the actual phone number from your data
        makePhoneCall(number: phoneNumber)
        
    }
    

    @IBAction func didTapOnBackBtnAction(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
}



extension ContactUsVC:MFMailComposeViewControllerDelegate {
    
    @objc func openEmail(mailstr:String) {
        if MFMailComposeViewController.canSendMail() {
            let composeVC = MFMailComposeViewController()
            composeVC.mailComposeDelegate = self
            composeVC.setToRecipients([mailstr]) // Set the recipient email address
            
            // Set the email subject
            //    composeVC.setSubject("Hello from Swift!")
            
            // Set the email body
            //   composeVC.setMessageBody("This is the body of the email.", isHTML: false)
            
            present(composeVC, animated: true, completion: nil)
        } else {
            // Handle the case when the device cannot send emails
            print("Device cannot send emails.")
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    func makePhoneCall(number: String) {
        if let phoneURL = URL(string: "tel://\(number)"),
           UIApplication.shared.canOpenURL(phoneURL) {
            UIApplication.shared.open(phoneURL, options: [:], completionHandler: nil)
        } else {
            // Handle the case where the device cannot make calls or the URL is invalid.
        }
    }
    
    
}
