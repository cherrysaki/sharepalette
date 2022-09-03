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
    @IBOutlet var RGBColorLabel: UILabel!
   

    var lat = CLLocationDegrees()
    var lon = CLLocationDegrees()
    var addressString = ""
    var date: String = ""
    var image: UIImage = UIImage()
    var color: UIColor = UIColor()
    var colorCode: String = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
        imageView.layer.cornerRadius = 10
        colorView.backgroundColor = color
        colorLabel.text = colorCode
        RGBColorLabel.text = "R:\(UIColor.hex(string: colorCode, alpha: 1).red()) " + "G:\(UIColor.hex(string: colorCode, alpha: 1).green()) " + "B:\(UIColor.hex(string: colorCode, alpha: 1).blue())"
        dateLabel.text = date
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



