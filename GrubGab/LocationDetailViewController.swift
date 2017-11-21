//
//  LocationDetailViewController.swift
//  GrubGab
//
//  Created by John Gallaugher on 11/20/17.
//  Copyright © 2017 John Gallaugher. All rights reserved.
//

import UIKit

class LocationDetailViewController: UIViewController {

    @IBOutlet weak var placeNameLabel: UITextField!
    var placeName: String?
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    } 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let placeName = placeName {
            placeNameLabel.text = placeName
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        placeName = placeNameLabel.text
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
