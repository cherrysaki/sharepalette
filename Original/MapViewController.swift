//
//  mapViewController.swift
//  Original
//
//  Created by 神林沙希 on 2022/05/13.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate{
    
    var lat = CLLocationDegrees()
    var lon = CLLocationDegrees()
    
    
    var saveData: UserDefaults = UserDefaults.standard
    var latArray: [Double] = []
    var lonArray: [Double] = []
    
    
  
    override func loadViewIfNeeded() {
        if saveData.object(forKey: "lat") != nil {
            latArray = saveData.object(forKey: "lat") as! [Double]
        }
        if saveData.object(forKey: "lon") != nil {
            lonArray = saveData.object(forKey: "lon") as! [Double]
        }
    }
    
    
    private lazy var setupMap: GMSMapView = {
        // 東京を表示する緯度・経度・mapカメラズーム値を設定
        let camera = GMSCameraPosition.camera(
            withLatitude: 36.0,
            longitude: 140.0,
            zoom: 8.0)
        let mapView = GMSMapView.map(withFrame: view.frame, camera: camera)
        mapView.isMyLocationEnabled = true
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: 36.0,longitude: 140.0)
        marker.title = "TOKYO"
        marker.map = mapView
        return mapView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(setupMap)
    }
    
}
