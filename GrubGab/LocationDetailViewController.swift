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
    
    var locationManger: CLLocationManager!
    var currentLocation: CLLocation!
    var place: Places.PlaceData?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    } 
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getLocation()
        if let place = place {
            placeNameLabel.text = place.placeName
        } else {
            // Just stuff some empty values in there for starters
            place = Places.PlaceData(placeName: "", coordinates: CLLocation(), postedBy: "")
        }
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        place?.placeName = placeNameLabel.text!
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
//        let geoCoder = CLGeocoder()
//        var place = ""
        currentLocation = locations.last
        place?.coordinates = currentLocation
        print("Longitude: \(currentLocation.coordinate.longitude), Latitude: \(currentLocation.coordinate.latitude)")
        
//        let currentLatitude = currentLocation.coordinate.latitude
//        let currentLongitude = currentLocation.coordinate.longitude
//        let currentCoordinates = "\(currentLatitude),\(currentLongitude)"
//        geoCoder.reverseGeocodeLocation(currentLocation, completionHandler: {placemarks, error in
//            if placemarks != nil {
//                let placemark = placemarks?.last
//                place = (placemark?.name)!
//            } else {
//                print("Error retrieving place. Error code: \(error!)")
//                place = "Unknown Weather Location"
//            }
//
//        })
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get user location.")
    }
}
