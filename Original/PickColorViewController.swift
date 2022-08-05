//
//  ViewController2.swift
//  Original
//
//  Created by 神林沙希 on 2021/12/29.
//

import UIKit
import Foundation
import CoreLocation
import Firebase
import FirebaseStorage
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class PickColorViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var colorView: UIView!
    @IBOutlet var saveButton: UIButton!
    
    //let locationManager = CLLocationManager()
    let locationStateManager = LocationStateManager.shared
    
    var saveData: UserDefaults = UserDefaults.standard
    
    var image = UIImage()
    var lat = CLLocationDegrees()
    var lon = CLLocationDegrees()
    //表示されている画像のタップ座標用変数
    var tapPoint = CGPoint(x: 0, y: 0)
    
    
    //色の配列
    var colors: [Data] = []
    var colorCode:String = ""
    var images: [Data] = []
    var latArray: [Double] = []
    var lonArray: [Double] = []
    
    
    override func viewDidLoad() {
        imageView.image = image
//        locationManager.delegate = self
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.requestLocation()
    }
    
    //imageviewをタップした時に色を判別
    @IBAction func getImageRGB(_ sender: UITapGestureRecognizer) {
        
        //tapした場所に赤い四角を置いてみる
        let tappedAreaView = UIView(frame: CGRect(origin: sender.location(in: imageView), size: CGSize(width: 4, height: 4)))
        
        tappedAreaView.backgroundColor = .red
        
        self.imageView.addSubview(tappedAreaView)
        
        guard imageView.image != nil else {return}
        
        //タップした座標の取得
        tapPoint = sender.location(in: imageView)
        colorCode = (imageView.image?.getColor(pos: tapPoint))!
        colorView.backgroundColor = UIColor.hex(string: colorCode, alpha: 1.0)
    }
    
    // TODO: データの保存処理
    // DispatchQueue -> https://ticklecode.com/swfitgdp/
    // DispatchSemaphore -> https://qiita.com/shtnkgm/items/d552bd3cf709266a9050
    @IBAction func save(){
        saveButton.isEnabled = false
        let loadingView = createLoadingView()
        UIApplication.shared.windows.filter{$0.isKeyWindow}.first?.addSubview(loadingView)
        
        // ユーザーがログインしているか確認する
        if let user = Auth.auth().currentUser {
            let image = self.imageView.image?.jpegData(compressionQuality: 0.01)!
            // データを保存
            DispatchQueue(label: "post data", qos: .default).async {
                // 画像のアップロード
                let ref = self.postImage(user: user,image: image!)
                // ダウンロードURLの取得
                let url = self.getDownloadUrl(storageRef: ref)
                // カラーデータの保存
                self.postColorData(user: user, imageUrlString: url)
                DispatchQueue.main.async {
                    loadingView.removeFromSuperview()
                }
                print("complete!")
            }
            
        } else {
            print("Error: ユーザーがログインしていません。")
            return
        }
        
    }
    
    // TODO: postImage
    private func postImage(user: User,image:Data) -> StorageReference {
        let semaphore = DispatchSemaphore(value: 0)
        
        let currentTimeStampInSecond = NSDate().timeIntervalSince1970
        let storage = Storage.storage().reference(forURL: "gs://original-app-31d37.appspot.com")
        
        // 保存する場所を指定
        let storageRef = storage.child("image").child(user.uid).child("\(user.uid)+\(currentTimeStampInSecond).jpg")
        
        // ファイルをアップロード
   
        storageRef.putData(image, metadata: nil) { (metadate, error) in
            //errorがあったら
            if error != nil {
                print("Firestrageへの画像の保存に失敗")
                print(error.debugDescription)
            }else {
                print("Firestrageへの画像の保存に成功")
            }
            semaphore.signal()
        }
        
        semaphore.wait()
        return storageRef
    }
    
    // TODO: getDownloadUrl
    private func getDownloadUrl(storageRef: StorageReference) -> String {
        let semaphore = DispatchSemaphore(value: 0)
        
        var imageUrlString = ""
        
        storageRef.downloadURL { (url, error) in
            if error != nil {
                print("Firestorageからのダウンロードに失敗しました")
                print(error.debugDescription)
            } else {
                print("Firestorageからのダウンロードに成功しました")
                //6URLをString型に変更して変数urlStringにdainyuu
                guard let urlString = url?.absoluteString else {
                    return
                }
                imageUrlString = urlString
            }
            semaphore.signal()
        }
        
        semaphore.wait()
        return imageUrlString
    }
    
    // TODO: postColorData
    private func postColorData(user: User, imageUrlString: String) {
        let semaphore = DispatchSemaphore(value: 0)
        
        Firestore.firestore().collection("users/\(user.uid)/colors").addDocument(data: [
            "date": FieldValue.serverTimestamp(),
            "image": imageUrlString,
            "color": self.colorCode,
            "lat": self.locationStateManager.lat,
            "lon": self.locationStateManager.lon
        ]) { error in
            if let error = error {
                // 失敗した場合
                print("保存失敗: " + error.localizedDescription)
                let dialog = UIAlertController(title: "保存失敗", message: error.localizedDescription, preferredStyle: .alert)
                dialog.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(dialog, animated: true, completion: nil)
            } else {
                print("保存成功")
                //元の画面に戻る
                self.dismiss(animated: true, completion: nil)
            }
            semaphore.signal()
        }
        
        semaphore.wait()
        return
    }
    
    // TODO: Loading View
    private func createLoadingView() -> UIView {
        let loadingView = UIView(frame: UIScreen.main.bounds)
        loadingView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        activityIndicator.center = loadingView.center
        activityIndicator.color = UIColor.white
        activityIndicator.style = UIActivityIndicatorView.Style.large
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        loadingView.addSubview(activityIndicator)
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 30))
        label.center = CGPoint(x: activityIndicator.frame.origin.x + activityIndicator.frame.size.width / 2, y: activityIndicator.frame.origin.y + 90)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.text = "アップロード中です..."
        loadingView.addSubview(label)
        
        return loadingView
    }
    
}


//    @IBAction func save(){
//        let date = FieldValue.serverTimestamp()
//        if let user = Auth.auth().currentUser {
//            var imageUrlString = ""
//            let storage = Storage.storage().reference(forURL: "gs://original-app-31d37.appspot.com")
//            let storageRef = storage.child("image").child("\(user.uid)+\(date).jpeg")
//            //storageに画像を保存
//            storageRef.putData(imageView.image!.jpegData(compressionQuality: 0.01)! as Data, metadata: nil) { (metadate, error) in
//                //errorがあったら
//                if error != nil {
//                    print("Firestrageへの画像の保存に失敗")
//                    print(error.debugDescription)
//                }else {
//                    print("Firestrageへの画像の保存に成功")
//                    //5画像のURLを取得
//                    storageRef.downloadURL { (url, error) in
//                        if error != nil {
//                            print("Firestorageからのダウンロードに失敗しました")
//                        }else {
//                            print("Firestorageからのダウンロードに成功しました")
//                            //6URLをString型に変更して変数urlStringにdainyuu
//                            guard let urlString = url?.absoluteString else {
//                                return
//                            }
//                            imageUrlString = urlString
//                        }
//                    }
//                }
//            }
//            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
//                Firestore.firestore().collection("users/\(user.uid)/colors").document().setData(
//                    [
//                        "date": date,
//                        "image": imageUrlString,
//                        "color": self.colorCode,
//                        "lat": self.lat,
//                        "lon": self.lon
//                    ],merge: true
//                    ,completion: { error in
//                        if let error = error {
//                            // 失敗した場合
//                            print("保存失敗: " + error.localizedDescription)
//                            let dialog = UIAlertController(title: "保存失敗", message: error.localizedDescription, preferredStyle: .alert)
//                            dialog.addAction(UIAlertAction(title: "OK", style: .default))
//                            self.present(dialog, animated: true, completion: nil)
//                        } else {
//                            print("保存成功")
//                            //元の画面に戻る
//                            self.dismiss(animated: true, completion: nil)
//                        }
//                    })
//            }
//        }
//    }
//
//
//    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//    //        if segue.identifier == "mapConfirm" {
//    //            let MapViewController: MapViewController = segue.destination as! MapViewController
//    //
//    //            MapViewController.lat = self.lat
//    //            MapViewController.lon = self.lon
//    //        }
//    //
//    //    }
//
//    // 位置情報を取得・更新したときに呼ばれる
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        // 最後に収集したlocationを取得
//        if let location = locations.last {
//            // 経度と緯度を取得
//            lat = location.coordinate.latitude
//            lon = location.coordinate.longitude
//            print("緯度: \(lat), 経度: \(lon)")
//        }
//    }
//
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print(error)
//    }
//
//}



extension UIImage {
    func convertImageToBase64(image: UIImage) -> String? {
        let imageData = image.jpegData(compressionQuality: 0.5)
        return imageData?.base64EncodedString(options:Data.Base64EncodingOptions.lineLength64Characters)
    }
    
    func getColor(pos: CGPoint) -> String? {
        let pixelDataByteSize = 4
        
        guard let cgImage = self.cgImage else { return nil }
        let pixelData = cgImage.dataProvider!.data
        
        let data : UnsafePointer = CFDataGetBytePtr(pixelData)
        let scale = UIScreen.main.scale
        let address : Int = ((Int(self.size.width) * Int(pos.y * scale)) + Int(pos.x * scale)) * pixelDataByteSize
        let r = CGFloat(data[address])
        let g = CGFloat(data[address+1])
        let b = CGFloat(data[address+2])
        let a = CGFloat(data[address+3])
        print(UIColor(red: r/255, green: g/255, blue: b/255, alpha: a/255))
        print("🍙")
        //カラーコードで表示
        print("#"+String(NSString(format: "%02x%02x%02x", Int(r),Int(g),Int(b))))
        return String(NSString(format: "%02x%02x%02x", Int(r),Int(g),Int(b)))
    }
    
    func hex(string: String, alpha: CGFloat) -> UIColor {
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
