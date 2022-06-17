//
//  mapViewController.swift
//  Original
//
//  Created by 神林沙希 on 2022/05/13.
//

import UIKit
import Foundation
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

                Firestore.firestore().collection("users/\(user.uid)/colors").addSnapshotListener({ (querySnapshot, error) in
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
                            let timeStamp = data["date"] as! Timestamp
                            dateArray.append(timeStamp.dateValue())
                            print(data["image"] as? String ?? "Unknown")
                            let imageData = Data(base64Encoded: data["image"] as? String ?? "Unknown", options: .ignoreUnknownCharacters)
                            print("画像\(data["image"] as! Data)")
                            imageArray.append(UIImage(data: imageData! as Data)!)
                            colorArray.append(UIColor.hex(string: data["color"] as! String, alpha: 1.0))
                            latArray.append(data["lat"] as! Double)
                            lonArray.append(data["lon"] as! Double)
                            print("日付\(dateArray)")
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
        print(lat)
        //view.addSubview(setupMap)
        }
    
  
//    override func loadViewIfNeeded() {
//        if saveData.object(forKey: "lat") != nil {
//            latArray = saveData.object(forKey: "lat") as! [Double]
//        }
//        if saveData.object(forKey: "lon") != nil {
//            lonArray = saveData.object(forKey: "lon") as! [Double]
//        }
//    }
    
    
//    private lazy var setupMap: GMSMapView = {
//        // 東京を表示する緯度・経度・mapカメラズーム値を設定
//        let camera = GMSCameraPosition.camera(
//            withLatitude: latArray[0],
//            longitude: lonArray[0],
//            zoom: 8.0)
//        let mapView = GMSMapView.map(withFrame: view.frame, camera: camera)
//        mapView.isMyLocationEnabled = true
//
//        let marker = GMSMarker()
//        marker.position = CLLocationCoordinate2D(latitude: 36.0,longitude: 140.0)
//        marker.title = "TOKYO"
//        marker.map = mapView
//        return mapView
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}

extension UIColor {
    class func hex(string: String, alpha: CGFloat) -> UIColor {
        let string_ = string.replacingOccurrences(of: "#", with: "")
        let scanner = Scanner(string: string_ as String)
        var color: UInt32 = 0
        if scanner.scanHexInt32(&color) {
            let r = CGFloat((color & 0xFF0000) >> 16) / 255.0
            let g = CGFloat((color & 0x00FF00) >> 8) / 255.0
            let b = CGFloat(color & 0x0000FF) / 255.0
            return UIColor(red:r,green:g,blue:b,alpha:alpha)
        } else {
            return UIColor.white
        }
    }
}
