//
//  ViewController2.swift
//  Original
//
//  Created by 神林沙希 on 2021/12/29.
//

import UIKit

class PickColorViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var colorView: UIView!
    
    var saveData: UserDefaults = UserDefaults.standard
    
    var image = UIImage()
    //表示されている画像のタップ座標用変数
    var tapPoint = CGPoint(x: 0, y: 0)
    
    
    //色の配列
    var colors: [Data] = []
    var color:UIColor = .white
    var images: [Data] = []
    
    
    override func viewDidLoad() {
        imageView.image = image
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
        color = (imageView.image?.getColor(pos: tapPoint))!
        colorView.backgroundColor = color
    }
    
    @IBAction func save(){
        if saveData.object(forKey: "color") != nil {
            colors = saveData.object(forKey: "color") as! [Data]
        }
        let saveColor = try! NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: false)
        colors.append(saveColor)
        saveData.set(colors, forKey: "color")
        if saveData.object(forKey: "image") != nil {
            images = saveData.object(forKey: "image") as! [Data]
        }
        let saveImage = try! NSKeyedArchiver.archivedData(withRootObject: image, requiringSecureCoding: false)
        images.append(saveImage)
        saveData.set(images, forKey: "image")
        self.dismiss(animated: true, completion: nil)
    }
    
}



extension UIImage {
    func getColor(pos: CGPoint) -> UIColor? {
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
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: a/255)
    }
}






