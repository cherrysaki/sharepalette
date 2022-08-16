//
//  DetailViewController.swift
//  Original
//
//  Created by 神林沙希 on 2022/07/08.
//

import UIKit
import CoreLocation

class DetailViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var colorView: UIView!
    @IBOutlet var colorLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    
    let text = [ "国名", "郵便番号", "都道府県", "郡", "市区町村", "丁番なしの地名", "地名", "番地" ]
    var location: [ UILabel ] = []
    var lat = CLLocationDegrees()
    var lon = CLLocationDegrees()
    var addressString = ""
    
    
    var image: UIImage = UIImage()
    var color: UIColor = UIColor()
    var colorCode: String = ""
    var date: String = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
        colorView.backgroundColor = color
        colorLabel.text = colorCode
        convert(lat: lat, lon: lon)
    }
    
    
    func convert(lat: CLLocationDegrees, lon: CLLocationDegrees) {
        let geocorder = CLGeocoder()
        let location = CLLocation(latitude: lat, longitude: lon)
        
        geocorder.reverseGeocodeLocation(location) { (placeMarks, error) in
            if let placemark = placeMarks?.first {
                //住所
                let administrativeArea = placemark.administrativeArea == nil ? "" : placemark.administrativeArea!
                let locality = placemark.locality == nil ? "" : placemark.locality!
                let subLocality = placemark.subLocality == nil ? "" : placemark.subLocality!
                let thoroughfare = placemark.thoroughfare == nil ? "" : placemark.thoroughfare!
                let subThoroughfare = placemark.subThoroughfare == nil ? "" : placemark.subThoroughfare!
                let placeName = !thoroughfare.contains( subLocality ) ? subLocality : thoroughfare
                self.addressLabel.text = administrativeArea + locality + placeName + subThoroughfare
            }
        }
    }
    
}



