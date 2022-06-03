//
//  mapViewController.swift
//  Original
//
//  Created by 神林沙希 on 2022/05/13.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import GoogleMaps

class MapViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate{
    
    var lat = CLLocationDegrees()
    var lon = CLLocationDegrees()
    
    
    var saveData: UserDefaults = UserDefaults.standard
    
    var idArray: [String] = []
    var dateArray:[Date] = []
    var imageArray:[UIImage] = []
    var colorArray:[UIColor] = []
    var latArray:[Double] = []
    var lonArray:[Double] = []
    
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            if let user = Auth.auth().currentUser {

                // ユーザー名を取得する処理省略

                Firestore.firestore().collection("users/\(user.uid)/colors").order(by: "date").addSnapshotListener({ (querySnapshot, error) in
                    if let querySnapshot = querySnapshot {
                        var idArray: [String] = []
                        var dateArray:[Date] = []
                        var imageArray:[UIImage] = []
                        var colorArray:[UIColor] = []
                        var latArray:[Double] = []
                        var lonArray:[Double] = []
                        for doc in querySnapshot.documents {
                            let data = doc.data()
                            idArray.append(doc.documentID)
                            dateArray.append(data["date"] as! Date)
                            imageArray.append(data["image"] as! UIImage)
                            colorArray.append(data["color"] as! UIColor)
                            latArray.append(data["lat"] as! Double)
                            lonArray.append(data["lon"] as! Double)
                        }
                        self.idArray = idArray
                        self.dateArray = dateArray
                        self.imageArray = imageArray
                        self.colorArray = colorArray
                        self.latArray = latArray
                        self.lonArray = lonArray
                        
                    } else if let error = error {
                        print("取得失敗: " + error.localizedDescription)
                    }
                })
            }
        print(latArray)
        view.addSubview(setupMap)
        }
    
  
//    override func loadViewIfNeeded() {
//        if saveData.object(forKey: "lat") != nil {
//            latArray = saveData.object(forKey: "lat") as! [Double]
//        }
//        if saveData.object(forKey: "lon") != nil {
//            lonArray = saveData.object(forKey: "lon") as! [Double]
//        }
//    }
    
    
    private lazy var setupMap: GMSMapView = {
        // 東京を表示する緯度・経度・mapカメラズーム値を設定
        let camera = GMSCameraPosition.camera(
            withLatitude: latArray[0],
            longitude: lonArray[0],
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
        
    }
    
}
