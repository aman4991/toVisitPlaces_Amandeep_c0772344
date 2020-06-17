//
//  FavouriteplacesViewController.swift
//  favouriteplacestovisit_Amandeep_344
//
//  Created by user174568 on 17/06/20.
//  Copyright © 2020 user174568. All rights reserved.
//

import UIKit
import CoreLocation

class FavouriteplacesViewController: UITableViewController,DataEnteredDelegate,DataEnteredDelegate2 {
    
    func userDidEnterInformation(fav: [Place]) {
        favplaces = fav
        self.tableview.reloadData()
    }
    
    func userDidEnterInformation(name: String, subtitle: String, lat: Double, long: Double) {
        
        name1 = name
        subtitle1 = subtitle
        longitude = long
        latitude = lat
        addpin = true
        self.tableview.reloadData()
    }
    
    
    let userDefaults = UserDefaults.standard
    var latitude = 0.0
    var longitude = 0.0
    var name1 = ""
    var subtitle1 = ""
    var favplaces = [Place]()
    var coordinate = CLLocationCoordinate2D()
    let defaults = UserDefaults.standard
    var addpin = false
    
    @IBOutlet var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self
        getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableview.reloadData()
        
        if addpin == true{
            let teams = [Place(title: name1 , subtitle:  subtitle1, latitude:  latitude, longitude: longitude)]
            
            let decoded  = self.defaults.data(forKey: "teams")
            if decoded != nil{
                var decodedTeams = NSKeyedUnarchiver.unarchiveObject(with: decoded!) as! [Place]
                self.favplaces = decodedTeams
            }else{
                self.favplaces = [Place]()
            }
            self.favplaces.append(contentsOf: teams)
            let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: self.favplaces)
            self.defaults.set(encodedData, forKey: "teams")
            self.defaults.synchronize()
            addpin = false
            self.tableview.reloadData()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favplaces.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableview.dequeueReusableCell(withIdentifier: "places", for: indexPath) as! FavPlacesCell
        let item = self.favplaces[indexPath.row]
        
        cell.name.text = item.title
        cell.subtitle.text = item.subtitle
        if let i = item.latitude{
            cell.latitude.text =  "\(i)"
        }
        if let ii = item.longitude{
            cell.longitude.text = "\(ii)"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            
            self.favplaces.remove(at: indexPath.row)
            self.tableview.deleteRows(at: [indexPath], with: .automatic)
            
            let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: self.favplaces)
            self.defaults.set(encodedData, forKey: "teams")
            self.defaults.synchronize()
            
            tableView.reloadData()
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "favplace") {
            let destination = segue.destination as! AddPlaceViewController
            destination.modalPresentationStyle = .fullScreen
            destination.delegate = self
            
        }else if (segue.identifier == "map") {
            if let cell = sender as? UITableViewCell {
                let indexPath = tableView.indexPath(for: cell)!
                let controller = segue.destination as! MapViewController
                controller.titleName = self.favplaces[indexPath.row].title!
                controller.lat = self.favplaces[indexPath.row].latitude ?? 0.0
                controller.long = self.favplaces[indexPath.row].longitude ?? 0.0
                controller.delegate = self
            }
        }
        
    }
    
    
    func getData(){
        
        let decoded  = userDefaults.data(forKey: "teams")
        if decoded == nil{
            self.favplaces = [Place]()
        }else{
            let decodedTeams = NSKeyedUnarchiver.unarchiveObject(with: decoded!) as! [Place]
            self.favplaces = decodedTeams
        }
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: self.favplaces)
        self.userDefaults.set(encodedData, forKey: "teams")
        self.userDefaults.synchronize()
    }
}

class FavPlacesCell:UITableViewCell{
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var latitude: UILabel!
    @IBOutlet weak var longitude: UILabel!
    @IBOutlet weak var subtitle: UILabel!
}
