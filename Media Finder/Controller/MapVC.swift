//
//  MapVC.swift
//  Media Finder
//
//  Created by Nafea Elkassas on 07/05/2023.
//

import MapKit

protocol sendLocationDelegate: AnyObject{
    func sendLocationAddress(address: String)
}

class MapVC: UIViewController {
    //MARK: - Properties
    let locationManager = CLLocationManager()
    weak var delegate: sendLocationDelegate?
    
    //MARK: - OutLets
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var mapKit: MKMapView!
    
    //MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        mapKit.delegate = self
        checkLocationServices()
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    //MARK: - Actions
    @IBAction func dubmitBtnTapped(_ sender: UIButton) {
        delegate?.sendLocationAddress(address: addressLabel.text ?? "")
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
extension MapVC: MKMapViewDelegate{
    
    //MARK: -  Map Kit Methods
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let lat = mapView.centerCoordinate.latitude
        let long = mapView.centerCoordinate.longitude
        let location = CLLocation(latitude: lat, longitude: long)
        getAddressName(location: location)
    }
    
    
    //MARK: - Private Functions
    
    private func getAddressName(location: CLLocation){
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location) { placeMarks, error in
            if let error = error {
                print(error.localizedDescription)
            } else if let firstPlaceMark = placeMarks?.first {
//                self.addressLabel.text = firstPlaceMark.compactAddress ?? "Not Found"
                let addressText = firstPlaceMark.compactAddress ?? "Not Found"
                            print("Address: \(addressText)") // Print the address for debugging
                            self.addressLabel.text = addressText
            }
        }
    }
    
    private func checkLocationServices(){
        if CLLocationManager.locationServicesEnabled(){
            authoriseLocationServices()
        } else {
            print("Please Enable Location Services 'GPS'!")
        }
    }
    
    private func authoriseLocationServices(){
        switch CLLocationManager.authorizationStatus(){
        case .authorizedAlways, .authorizedWhenInUse :
            print("Successful")
        case .restricted, .denied:
            print("Denied")
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        default:
            print("Cannot Get Your Location !!")
        }
    }
    
    private func getCurrentLocation(){
        if let location = locationManager.location?.coordinate{
            let region = MKCoordinateRegion(center: location, latitudinalMeters: 10000, longitudinalMeters: 10000)
            mapKit.setRegion(region, animated: true)
            getAddressName(location: locationManager.location!)
        }
    }
}
