//
//  PlacesViewController.swift
//  GrubGab
//
//  Created by An awesome student on 11/20/17.
//  Copyright © 2017 held by all who are awesome. All rights reserved.
//

import UIKit

class PlacesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var places = Places()
    
    // Since we have a dark orange for the navigation bar, this will turn the battary, time, and signal indicators white. You need to do in each view controller file for all view controllers embedded in a navigation controller. You also need to add the following file to your project:
    // UINavigationController + preferredStatusBarStyle.swift
    // Text for buttons was set indivdually.
    // Navigation color was set by clicking on the Navigation Controller
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    } 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        

        
        // Put in somem bogus data
        places.placeArray.append(Places.PlaceData(placeName: "White Mountain Creamery", latitude: "", longitude: "", postedBy: "Fr. Leahy"))
        places.placeArray.append(Places.PlaceData(placeName: "The Eagle's Nest", latitude: "", longitude: "", postedBy: "Vanilla Ice"))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowPlaceSegue" {
            let destination = segue.destination as! LocationDetailViewController
            let selectedRow = tableView.indexPathForSelectedRow!.row
            destination.placeName = places.placeArray[selectedRow].placeName
        } else {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                tableView.deselectRow(at: selectedIndexPath, animated: true)
            }
        }
    }
    
    @IBAction func unwindFromLocationDetail(segue: UIStoryboardSegue) {
        let source = segue.source as! LocationDetailViewController
        // If there's a valid indexPathForSelectedRow, must be returning from a cell-click-to-edit and NOT a "+" add new
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            places.placeArray[selectedIndexPath.row].placeName = source.placeName!
            tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
        } else { // Must be returning from a "+" add new
            let newIndexPath = IndexPath(row: places.placeArray.count, section: 0)
            let placeName = source.placeName!
            places.placeArray.append(Places.PlaceData(placeName: placeName, latitude: "", longitude: "", postedBy: ""))
            tableView.insertRows(at: [newIndexPath], with: .bottom)
            tableView.scrollToRow(at: newIndexPath, at: .bottom, animated: true)
        }
    }
    
}

extension PlacesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.placeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = places.placeArray[indexPath.row].placeName
        cell.detailTextLabel?.text = places.placeArray[indexPath.row].postedBy
        return cell
    }
}


