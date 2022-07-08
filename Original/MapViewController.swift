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
import FirebaseStorage
import FirebaseAuth
import GoogleMaps
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate, CAAnimationDelegate{
    
    let locationStateManager = LocationStateManager.shared
    
    var saveData: UserDefaults = UserDefaults.standard
    
    @IBOutlet var mapView: GMSMapView!
    
    var image: UIImage = UIImage()
    var color: UIColor = UIColor()
    var colorCode: String = ""
    
    var dataList: Dictionary<String, Any> = [:]
    var markers: Dictionary<String, GMSMarker> = [:]
    var isMyLocation = true
    
    //    override func viewWillAppear(_ animated: Bool) {
    //        super.viewWillAppear(animated)
    //
    //        if let user = Auth.auth().currentUser {
    //
    //            // ユーザー名を取得する処理省略
    //
    //            Firestore.firestore().collection("users/\(user.uid)/colors").addSnapshotListener({ (querySnapshot, error) in
    //                if let querySnapshot = querySnapshot {
    //                    var idArray: [String] = []
    //                    var dateArray:[Date] = []
    //                    var imageArray:[UIImage] = []
    //                    var colorArray:[UIColor] = []
    //                    var latArray:[Double] = []
    //                    var lonArray:[Double] = []
    //                    for doc in querySnapshot.documents {
    //                        let data = doc.data()
    //                        idArray.append(doc.documentID)
    //                        let timeStamp = data["date"] as! Timestamp
    //                        dateArray.append(timeStamp.dateValue())
    //                        let storage = Storage.storage()
    //                        var reference: StorageReference!
    //                        print(" 🍣")
    //                        print(data["image"] as? String ?? "Unknown")
    //                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
    //                            reference = storage.reference(forURL: data["image"] as? String ?? "Unknown")
    //                            reference.downloadURL { (url, error) in
    //                                print("image url is",url!)
    //                                let data = NSData(contentsOf: url!)
    //                                imageArray.append(UIImage(data: data! as Data)!)
    //                            }
    //                        }
    //                        colorArray.append(UIColor.hex(string: data["color"] as! String, alpha: 1.0))
    //                        latArray.append(data["lat"] as! Double)
    //                        lonArray.append(data["lon"] as! Double)
    //                        print("日付\(dateArray)")
    //                    }
    //                    self.idArray = idArray
    //                    self.dateArray = dateArray
    //                    self.imageArray = imageArray
    //                    self.colorArray = colorArray
    //                    self.latArray = latArray
    //                    self.lonArray = lonArray
    //
    //                } else if let error = error {
    //                    print("取得失敗: " + error.localizedDescription)
    //                }
    //            })
    //        }
    //        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
    //            print(self.latArray)
    //            self.view.addSubview(self.setupMap)
    //        }
    //    }
    
    //    override func loadViewIfNeeded() {
    //        if saveData.object(forKey: "lat") != nil {
    //            latArray = saveData.object(forKey: "lat") as! [Double]
    //        }
    //        if saveData.object(forKey: "lon") != nil {
    //            lonArray = saveData.object(forKey: "lon") as! [Double]
    //        }
    //    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMap()
        
        if let user = Auth.auth().currentUser {
            Firestore.firestore().collection("users/\(user.uid)/colors")
                .addSnapshotListener { querySnapshot, error in
                    guard let snapshot = querySnapshot else {
                        print("Error fetching snapshots: \(error!)")
                        return
                    }
                    snapshot.documentChanges.forEach { diff in
                        if (diff.type == .added) {
                            print("New marker: \(diff.document.data())")
                            let id = diff.document.documentID
                            let data = diff.document.data()
                            self.addMarker(id: id, data: data)
                        }
                        if (diff.type == .modified) {
                            print("Modified marker: \(diff.document.data())")
                            let id = diff.document.documentID
                            let data = diff.document.data()
                            self.modifyMarker(id: id, data: data)
                        }
                        if (diff.type == .removed) {
                            print("Removed marker: \(diff.document.data())")
                            let id = diff.document.documentID
                            self.removeMarker(id: id)
                        }
                    }
                }
        }
        
    }
    
    // TODO: Mapのセットアップ
    // https://qiita.com/nwatabou/items/38f4240582d70a4d84a8
    private func setupMap() {
        let lat = locationStateManager.lat
        let lon = locationStateManager.lon
        
        mapView.camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lon, zoom: 12.0)
        mapView.delegate = self
        mapView.accessibilityElementsHidden = false
        mapView.isMyLocationEnabled = true
    }
    
    // TODO: Markerを操作する関数
    private func addMarker(id: String, data: Dictionary<String, Any>) {
        let marker = createMarker(id: id, data: data)
        markers[id] = marker
        dataList[id] = data
    }
    
    private func modifyMarker(id: String, data: Dictionary<String, Any>) {
        removeMarker(id: id)
        let marker = createMarker(id: id, data: data)
        markers[id] = marker
        dataList[id] = data
    }
    
    private func removeMarker(id: String) {
        (markers[id]!).map = nil
        markers.removeValue(forKey: id)
        dataList.removeValue(forKey: id)
    }
    
    private func createMarker(id: String, data: Dictionary<String, Any>) -> GMSMarker {
        let lat = data["lat"] as! Double
        let lon = data["lon"] as! Double
        let color = UIColor.hex(string: data["color"] as! String, alpha: 1.0).cgColor
        
        let label = UILabel(frame: CGRect(x:0.0, y:0.0, width:20.0, height:20.0))
        
        let markerView = UIView(frame: CGRect(x:0.0, y:0.0, width:20.0, height:20.0))
        markerView.layer.cornerRadius = 10.0
        markerView.layer.borderWidth = 5.0
        markerView.layer.borderColor = color
        markerView.backgroundColor = .white
        markerView.addSubview(label)
        markerView.accessibilityIdentifier = id
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        marker.accessibilityRespondsToUserInteraction = true
        marker.iconView = markerView
        marker.map = mapView
        
        return marker
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        let data = dataList[marker.iconView!.accessibilityIdentifier ?? ""] as! Dictionary<String, Any>
        let url = URL(string: data["image"] as! String)
        let d = NSData(contentsOf: url!)
        image = UIImage(data: d! as Data)!
        color = UIColor.hex(string: data["color"] as! String, alpha: 1.0)
        colorCode = "#\(data["color"] as! String)"
        print("onClick")
        self.performSegue(withIdentifier: "toDetailVC", sender: self)
        
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailVC" {
            let detailVC = segue.destination as? DetailViewController
            detailVC?.image = self.image
            detailVC?.color = self.color
            detailVC?.colorCode = self.colorCode
        }
    }
    
    //    private lazy var setupMap: GMSMapView = {
    //        // 東京を表示する緯度・経度・mapカメラズーム値を設定
    //        let camera = GMSCameraPosition.camera(
    //            withLatitude: lat,
    //            longitude: lon,
    //            zoom: 8.0)
    //        let mapView = GMSMapView.map(withFrame: view.frame, camera: camera)
    //        mapView.isMyLocationEnabled = true
    //        for i in 0...latArray.count - 1 {
    //            let marker = GMSMarker()
    //            let opacityAnimation = CABasicAnimation(keyPath: "opacity")
    //            opacityAnimation.fromValue = 0.0
    //            opacityAnimation.toValue = 1.0
    //            opacityAnimation.duration = 0.5
    //            opacityAnimation.isRemovedOnCompletion = false
    //            opacityAnimation.fillMode = .forwards
    //            opacityAnimation.delegate = self
    //            opacityAnimation.setValue(marker.layer, forKey: "marker_opacity1")
    //            marker.layer.add(opacityAnimation, forKey: "marker_opacity2")
    //            marker.position = CLLocationCoordinate2D(latitude: latArray[i],longitude: lonArray[i])
    //            let label = UILabel(frame: CGRect(x:0.0, y:0.0, width:20.0, height:20.0))
    //            //            label.text = "s"
    //            //            label.font = UIFont.systemFont(ofSize: 15.0)
    //            //            label.textAlignment = .center
    //            //            label.textColor = .white
    //            let markerView = UIView(frame: CGRect(x:0.0, y:0.0, width:20.0, height:20.0))
    //            markerView.layer.cornerRadius = 10.0
    //            markerView.layer.borderWidth = 5.0
    //            markerView.layer.borderColor = colorArray[i].cgColor
    //            markerView.backgroundColor = .white
    //            markerView.addSubview(label)
    //            marker.iconView = markerView
    //            marker.map = mapView
    //        }
    //        return mapView
    //    }()
    
    
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

public struct MyColor: Codable {
    
    let color: String
    let date: Date
    let image: String
    let lat: Float
    let lon: Float
    
    enum CodingKeys: String, CodingKey {
        case color
        case date
        case image
        case lat
        case lon
    }
}
