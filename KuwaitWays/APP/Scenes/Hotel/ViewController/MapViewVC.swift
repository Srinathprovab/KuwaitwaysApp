//
//  MapViewVC.swift
//  BeeoonsApp
//
//  Created by MA673 on 23/08/22.
//

import UIKit
import MapKit

class MapViewVC: UIViewController {
    
    
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
        
        addAnnotationsToMapView()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupUI()
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
        
        
        setupMapView()
        addAnnotationsToMapView()
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
    
    
    
    
    
    func setupMapView() {
        mapView.delegate = self
        
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 39.8283, longitude: -98.5795), span: MKCoordinateSpan(latitudeDelta: 20, longitudeDelta: 20))
        mapView.setRegion(region, animated: true)
    }
    
    func addAnnotationsToMapView() {
        for index in 0..<latitudeArray.count {
            let coordinate = CLLocationCoordinate2D(latitude: latitudeArray[index], longitude: longitudeArray[index])
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            mapView.addAnnotation(annotation)
        }
    }
    
    // MARK: - MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil // Return nil for the user's location annotation
        }
        
        let identifier = "CustomAnnotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }
        
        
        // Set the image for the annotation view
        annotationView?.image = UIImage(named: "loc")?.withRenderingMode(.alwaysOriginal).withTintColor(.AppBackgroundColor)
        
        return annotationView
    }
}

