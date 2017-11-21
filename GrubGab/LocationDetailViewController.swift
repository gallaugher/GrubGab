//
//  LocationDetailViewController.swift
//  GrubGab
//
//  Created by John Gallaugher on 11/20/17.
//  Copyright © 2017 John Gallaugher. All rights reserved.
//

import UIKit
import CoreLocation

class LocationDetailViewController: UIViewController {

    @IBOutlet weak var placeNameLabel: UITextField!
    @IBOutlet weak var addressLabel: UITextField!
    
    var locationManger: CLLocationManager!
    var currentLocation: CLLocation!
    var placeData: Places.PlaceData?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    } 
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getLocation()
        if let place = placeData {
            placeNameLabel.text = place.placeName
            addressLabel.text = place.address
            currentLocation = place.coordinates
        } else {
            // Just stuff some empty values in there for starters
            placeData = Places.PlaceData(placeName: "", address: "", coordinates: CLLocation(), postedBy: "")
        }
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        placeData?.placeName = placeNameLabel.text!
        placeData?.address = addressLabel.text!
    }

    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    
}

extension LocationDetailViewController: CLLocationManagerDelegate {
    
    func getLocation(){
        locationManger = CLLocationManager()
        locationManger.delegate = self
    }
    
    func handleLocationAuthorizationStatus(status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManger.requestWhenInUseAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
            locationManger.requestLocation()
        case .denied:
            showAlertToPrivacySettings(title: "User has not authorized location services", message: "Select 'Settings' below to open device settings and enable location services for this app.")
        case .restricted:
            showAlert(title: "Location services denied", message: "It may be that parental controls are restricting location use in this app")
        }
    }
    
    func showAlertToPrivacySettings(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        guard let settingsURL = URL(string: UIApplicationOpenSettingsURLString) else {
            print("Something went wrong getting the UIApplicationOpenSettingsURLString")
            return
        }
        let settingsActions = UIAlertAction(title: "Settings", style: .default) { value in
            UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(settingsActions)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        handleLocationAuthorizationStatus(status: status)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let geoCoder = CLGeocoder()
        currentLocation = locations.last
        placeData?.coordinates = currentLocation
        print(">>> Longitude: \(currentLocation.coordinate.longitude), Latitude: \(currentLocation.coordinate.latitude)")
        
        geoCoder.reverseGeocodeLocation(currentLocation, completionHandler: {placemarks, error in
                    if placemarks != nil {
                        let placemark = placemarks?.last
                        self.placeData?.placeName = placemark?.name ?? ""
                        self.placeData?.address = placemark?.thoroughfare ?? ""
                    } else {
                        print("Error retrieving place. Error code: \(error!)")
                    }
        
                })
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get user location.")
    }
}
