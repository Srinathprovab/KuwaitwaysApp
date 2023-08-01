//
//  MapViewVC.swift
//  BeeoonsApp
//
//  Created by MA673 on 23/08/22.
//

import UIKit
import MapKit

class MapViewVC: UIViewController, TimerManagerDelegate {
    
    
    @IBOutlet weak var nav: NavBar!
    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var navHeight: NSLayoutConstraint!
    @IBOutlet weak var textFieldHolderView: UIView!
    @IBOutlet weak var searchImg: UIImageView!
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    
    static var newInstance: MapViewVC? {
        let storyboard = UIStoryboard(name: Storyboard.Hotel.name,
                                      bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: self.className()) as? MapViewVC
        return vc
    }
    
    
    @objc func offline(notificatio:UNNotification) {
        callapibool = true
        guard let vc = NoInternetConnectionVC.newInstance.self else {return}
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false)
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(offline), name: NSNotification.Name("offline"), object: nil)
        
        
        print(latitudeArray)
        print(longitudeArray)
        
        
        TimerManager.shared.delegate = self
        
    }
    
    func timerDidFinish() {
        guard let vc = PopupVC.newInstance.self else {return}
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: false)
    }
    
    func updateTimer() {
        
    }
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupUI()
        
        mapView.delegate = self
        addAnnotations()
    }
    
    func setupUI() {
        
        self.view.backgroundColor = .black.withAlphaComponent(0.4)
        self.holderView.backgroundColor = .WhiteColor
        nav.titlelbl.text = "Map View"
        nav.backBtn.addTarget(self, action: #selector(backbtnAction(_:)), for: .touchUpInside)
        
        let screenHeight = UIScreen.main.bounds.size.height
        if screenHeight > 835 {
            navHeight.constant = 130
        }else {
            navHeight.constant = 100
        }
        
        textFieldHolderView.backgroundColor = HexColor("#F0F0F0")
        textFieldHolderView.layer.cornerRadius = 6
        textFieldHolderView.clipsToBounds = true
        searchImg.image = UIImage(named: "search")?.withRenderingMode(.alwaysOriginal).withTintColor(.AppBackgroundColor)
        searchTF.font = UIFont.OpenSansMedium(size: 16)
        searchTF.placeholder = "Search By Location"
        searchTF.setLeftPaddingPoints(20)
        searchTF.addTarget(self, action: #selector(editingChanged(_:)), for: .editingChanged)
        
    }
    
    
    @objc func backbtnAction(_ sender:UIButton) {
        callapibool = false
        dismiss(animated: true)
    }
    
    
    @objc func editingChanged(_ textField:UITextField) {
        print(textField.text)
    }
    
}

extension MapViewVC: MKMapViewDelegate {
    
    
    func addAnnotations() {
        for i in 0..<latitudeArray.count {
            let latitude = latitudeArray[i]
            let longitude = longitudeArray[i]
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            mapView.addAnnotation(annotation)
        }
    }
    
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }
        
        let identifier = "AnnotationIdentifier"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        } else {
            annotationView?.annotation = annotation
        }
        
        annotationView?.image = UIImage(named: "loc")?.withRenderingMode(.alwaysOriginal).withTintColor(.red)
        
        return annotationView
    }
    
}

