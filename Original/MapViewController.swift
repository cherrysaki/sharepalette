//
//  mapViewController.swift
//  Original
//
//  Created by 神林沙希 on 2022/05/13.
//

import UIKit
import GoogleMaps
//import GoogleMapsUtils

class MapViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate{
    private lazy var setupMap: GMSMapView = {
        // 東京を表示する緯度・経度・mapカメラズーム値を設定
        let camera = GMSCameraPosition.camera(
            withLatitude: 36.0,
            longitude: 140.0,
            zoom: 8.0)
        let mapView = GMSMapView.map(withFrame: view.frame, camera: camera)
        mapView.isMyLocationEnabled = true
        return mapView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(setupMap)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


}
