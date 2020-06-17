//
//  AddPlaceViewController.swift
//  favouriteplacestovisit_Amandeep_344
//
//  Created by user174568 on 6/16/20.
//  Copyright © 2020 user174568. All rights reserved.
//

import UIKit
import MapKit

// protocol used for sending data back
protocol DataEnteredDelegate {
    func userDidEnterInformation(fav:[Place])
   
}

class AddPlaceViewController: UIViewController {
    
    // making this a weak variable so that it won't create a strong reference cycle
    var delegate: DataEnteredDelegate?
    var latitude1 = 0.0
    var longitude1 = 0.0
    var name1 = ""
    var favplaces = [Place]()
    var coordinate = CLLocationCoordinate2D()
    let userDefaults = UserDefaults.standard
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var subtitle: UITextField!
    @IBOutlet weak var latitude: UITextField!
    @IBOutlet weak var longitude: UITextField!
    
    @IBAction func done(_ sender: Any) {
        
        save()
        
        delegate?.userDidEnterInformation(fav: self.favplaces)
        
        _ = navigationController?.popViewController(animated: true)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func save(){

        let teams = [Place(title: name.text!, subtitle:  subtitle.text!, latitude:  Double(latitude.text!)!, longitude: Double(longitude.text!)!)]
        
        let decoded = userDefaults.data(forKey: "teams")
        if decoded == nil{
            self.favplaces = [Place]()
        }else{
            let decodedTeams = NSKeyedUnarchiver.unarchiveObject(with: decoded!) as! [Place]
            self.favplaces = decodedTeams
        }
        self.favplaces.append(contentsOf: teams)
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: self.favplaces)
        self.userDefaults.set(encodedData, forKey: "teams")
        self.userDefaults.synchronize()
    }
}



