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
    @IBOutlet var ColorCodeLabel: UILabel!
    @IBOutlet var RGBLabel: UILabel!
    @IBOutlet var saveButton: UIButton!
    
    
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
        imageView.layer.cornerRadius = 10
        
        saveButton.tintColor = UIColor.systemBlue
    }
    
    //imageviewをタップした時に色を判別
    @IBAction func getImageRGB(_ sender: UITapGestureRecognizer) {
        
        //tapした場所に赤い四角を置いてみる
        let tappedAreaView = UIView(frame: CGRect(origin: sender.location(in: imageView), size: CGSize(width: 4, height: 4)))
        
        tappedAreaView.backgroundColor = .red
        
        //        self.imageView.addSubview(tappedAreaView)
        
        guard imageView.image != nil else {return}
        
        //タップした座標の取得
        tapPoint = sender.location(in: imageView)
        var pixelColor = (imageView.image?.pixelColor(x: Int(tapPoint.x), y: Int(tapPoint.y)))
        
        
        pixelColor = imageView.colorOfPoint(point: sender.location(in: imageView))
        
        colorView.backgroundColor = pixelColor
        colorCode = UIColor.toHexString(pixelColor!)()
        print(colorCode)
        colorView.layer.cornerRadius = 35
        ColorCodeLabel.text = "#" + String(colorCode)
        RGBLabel.text = "R:\(UIColor.hex(string: colorCode, alpha: 1).red()) " + "G:\(UIColor.hex(string: colorCode, alpha: 1).green()) " + "B:\(UIColor.hex(string: colorCode, alpha: 1).blue())"
        
        
        
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
                    
                    self.navigationController?.popToRootViewController(animated: true)
                    
                    let previousViewController = self.tabBarController?.viewControllers?[0]
                    self.tabBarController?.selectedViewController = previousViewController
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



extension UIImage {
    var pixelWidth: Int {
        return cgImage?.width ?? 0
    }
    
    var pixelHeight: Int {
        return cgImage?.height ?? 0
    }
    
    func pixelColor(x: Int, y: Int) -> UIColor {
        assert(
            0 ..< pixelWidth ~= x && 0 ..< pixelHeight ~= y,
            "Pixel coordinates are out of bounds"
        )
        
        guard
            let cgImage = cgImage,
            let data = cgImage.dataProvider?.data,
            let dataPtr = CFDataGetBytePtr(data),
            let colorSpaceModel = cgImage.colorSpace?.model,
            let componentLayout = cgImage.bitmapInfo.componentLayout
        else {
            assertionFailure("Could not get a pixel of an image")
            return .clear
        }
        
        assert(
            colorSpaceModel == .rgb,
            "The only supported color space model is RGB"
        )
        assert(
            cgImage.bitsPerPixel == 32 || cgImage.bitsPerPixel == 24,
            "A pixel is expected to be either 4 or 3 bytes in size"
        )
        
        let bytesPerRow = cgImage.bytesPerRow
        let bytesPerPixel = cgImage.bitsPerPixel / 8
        let pixelOffset = y * bytesPerRow + x * bytesPerPixel
        
        if componentLayout.count == 4 {
            let components = (
                dataPtr[pixelOffset + 0],
                dataPtr[pixelOffset + 1],
                dataPtr[pixelOffset + 2],
                dataPtr[pixelOffset + 3]
            )
            
            var alpha: UInt8 = 0
            var red: UInt8 = 0
            var green: UInt8 = 0
            var blue: UInt8 = 0
            
            switch componentLayout {
            case .bgra:
                alpha = components.3
                red = components.2
                green = components.1
                blue = components.0
            case .abgr:
                alpha = components.0
                red = components.3
                green = components.2
                blue = components.1
            case .argb:
                alpha = components.0
                red = components.1
                green = components.2
                blue = components.3
            case .rgba:
                alpha = components.3
                red = components.0
                green = components.1
                blue = components.2
            default:
                return .clear
            }
            
            /// If chroma components are premultiplied by alpha and the alpha is `0`,
            /// keep the chroma components to their current values.
            if cgImage.bitmapInfo.chromaIsPremultipliedByAlpha, alpha != 0 {
                let invisibleUnitAlpha = 255 / CGFloat(alpha)
                red = UInt8((CGFloat(red) * invisibleUnitAlpha).rounded())
                green = UInt8((CGFloat(green) * invisibleUnitAlpha).rounded())
                blue = UInt8((CGFloat(blue) * invisibleUnitAlpha).rounded())
            }
            
            return .init(red: red, green: green, blue: blue, alpha: alpha)
            
        } else if componentLayout.count == 3 {
            let components = (
                dataPtr[pixelOffset + 0],
                dataPtr[pixelOffset + 1],
                dataPtr[pixelOffset + 2]
            )
            
            var red: UInt8 = 0
            var green: UInt8 = 0
            var blue: UInt8 = 0
            
            switch componentLayout {
            case .bgr:
                red = components.2
                green = components.1
                blue = components.0
            case .rgb:
                red = components.0
                green = components.1
                blue = components.2
            default:
                return .clear
            }
            
            return .init(red: red, green: green, blue: blue, alpha: UInt8(255))
            
        } else {
            assertionFailure("Unsupported number of pixel components")
            return .clear
        }
    }
}

public extension UIColor {
    convenience init(red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8) {
        self.init(
            red: CGFloat(red) / 255,
            green: CGFloat(green) / 255,
            blue: CGFloat(blue) / 255,
            alpha: CGFloat(alpha) / 255
        )
    }
    
    func toHexString() -> String {
        var red: CGFloat     = 1.0
        var green: CGFloat   = 1.0
        var blue: CGFloat    = 1.0
        var alpha: CGFloat   = 1.0
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        let r = Int(String(Int(floor(red*100)/100 * 255)).replacingOccurrences(of: "-", with: ""))!
        let g = Int(String(Int(floor(green*100)/100 * 255)).replacingOccurrences(of: "-", with: ""))!
        let b = Int(String(Int(floor(blue*100)/100 * 255)).replacingOccurrences(of: "-", with: ""))!
        
        let result = String(r, radix: 16).leftPadding(toLength: 2, withPad: "0") + String(g, radix: 16).leftPadding(toLength: 2, withPad: "0") + String(b, radix: 16).leftPadding(toLength: 2, withPad: "0")
        return result
    }
}


extension String {
    // 左から文字埋めする
    func leftPadding(toLength: Int, withPad character: Character) -> String {
        let stringLength = self.count
        if stringLength < toLength {
            return String(repeatElement(character, count: toLength - stringLength)) + self
        } else {
            return String(self.suffix(toLength))
        }
    }
}

public extension CGBitmapInfo {
    enum ComponentLayout {
        case bgra
        case abgr
        case argb
        case rgba
        case bgr
        case rgb
        
        var count: Int {
            switch self {
            case .bgr, .rgb: return 3
            default: return 4
            }
        }
    }
    
    var componentLayout: ComponentLayout? {
        guard let alphaInfo = CGImageAlphaInfo(rawValue: rawValue & Self.alphaInfoMask.rawValue) else { return nil }
        let isLittleEndian = contains(.byteOrder32Little)
        
        if alphaInfo == .none {
            return isLittleEndian ? .bgr : .rgb
        }
        let alphaIsFirst = alphaInfo == .premultipliedFirst || alphaInfo == .first || alphaInfo == .noneSkipFirst
        
        if isLittleEndian {
            return alphaIsFirst ? .bgra : .abgr
        } else {
            return alphaIsFirst ? .argb : .rgba
        }
    }
    
    var chromaIsPremultipliedByAlpha: Bool {
        let alphaInfo = CGImageAlphaInfo(rawValue: rawValue & Self.alphaInfoMask.rawValue)
        return alphaInfo == .premultipliedFirst || alphaInfo == .premultipliedLast
    }
}

extension UIColor {
    
    func red() -> String {
        var redValue: CGFloat = 0
        self.getRed(&redValue, green: nil, blue: nil, alpha: nil)
        return String(Int(redValue * 255))
    }
    
    func green() -> String {
        var greenValue: CGFloat = 0
        self.getRed(nil, green: &greenValue, blue: nil, alpha: nil)
        return String(Int(greenValue * 255))
    }
    
    func blue() -> String {
        var blueValue: CGFloat = 0
        self.getRed(nil, green: nil, blue: &blueValue, alpha: nil)
        return String(Int(blueValue * 255))
    }
    
}

extension UIView {
    func colorOfPoint(point: CGPoint) -> UIColor {
        let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        
        var pixelData: [UInt8] = [0, 0, 0, 0]
        
        let context = CGContext(data: &pixelData, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        
        context!.translateBy(x: -point.x, y: -point.y)
        
        self.layer.render(in: context!)
        
        let red: CGFloat = CGFloat(pixelData[0]) / CGFloat(255.0)
        let green: CGFloat = CGFloat(pixelData[1]) / CGFloat(255.0)
        let blue: CGFloat = CGFloat(pixelData[2]) / CGFloat(255.0)
        let alpha: CGFloat = CGFloat(pixelData[3]) / CGFloat(255.0)
        
        let color: UIColor = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        
        return color
    }
}
