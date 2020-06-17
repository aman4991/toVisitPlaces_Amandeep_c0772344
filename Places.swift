//
//  Places.swift
//  favouriteplacestovisit_Amandeep_344
//
//  Created by user174568 on 17/06/20.
//  Copyright © 2020 user174568. All rights reserved.
//

import Foundation
import MapKit

class Place: NSObject,NSCoding {

    
    
    var title: String?
    var subtitle: String?
    var latitude: Double?
    var longitude: Double?
    
    init(title: String?, subtitle: String?, latitude: Double, longitude:Double) {
           self.title = title
           self.subtitle = subtitle
           self.latitude = latitude
           self.longitude = longitude
    }
      // MARK: NSCoding
      required convenience init?(coder decoder: NSCoder) {
          guard let title = decoder.decodeObject(forKey: "title") as? String
              else { return nil }
          
          self.init(
              title: title,
              subtitle: decoder.decodeObject(forKey: "subtitle") as! String,
              latitude: decoder.decodeObject(forKey: "latitude") as! Double,
              longitude: decoder.decodeObject(forKey: "longitude") as! Double
          )
      }
      
      func encode(with aCoder: NSCoder) {
          aCoder.encode(self.title, forKey: "title")
          aCoder.encode(self.subtitle, forKey: "subtitle")
          aCoder.encode(self.latitude, forKey: "latitude")
          aCoder.encode(self.longitude, forKey: "longitude")
      }
    
    static func getPlaces() -> [Place]{
        guard let path = Bundle.main.path(forResource: "Places", ofType: "plist"), let array = NSArray(contentsOfFile: path) else { return [] }
        var places = [Place]()
        for item in array{
            let dictionary = item as? [String: Any]
            let title = dictionary?["title"]as?String
            let subtitle = dictionary?["description"]as? String
            let latitude = dictionary?["latitude"]as? Double ?? 0 ,longitude = dictionary?["longitude"] as? Double ?? 0
            let place = Place(title: title, subtitle: subtitle, latitude: latitude, longitude: longitude)
            places.append(place)
        }
        return places as [Place]
    }
}
