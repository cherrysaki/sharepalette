//
//  PaletteTableViewController.swift
//  Original
//
//  Created by 神林沙希 on 5/8/22.
//

import UIKit
import Firebase
import CoreLocation

class PaletteTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    
    var index = 0
    
    var colorArray: [UIColor] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    var colorCodeArray: [String] = []{
        didSet {
            tableView.reloadData()
        }
    }
    
    var imageArray: [UIImage] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    var latArray: [Double] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    var lonArray: [Double] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    var dateArray: [String] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    var color: UIColor = UIColor()
    
    var data: Dictionary<String, Any> = [:]
    var isMyLocation = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 90
        tableView.register(UINib(nibName: "PaletteTableViewCell", bundle: nil), forCellReuseIdentifier: "PaletteCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        colorArray = []
        getFirebasedocuments()
    }
    
    
    
    
    func getFirebasedocuments() {
        var colorArray: [UIColor] = []
        var colorCodeArray: [String] = []
        var imageArray: [UIImage] = []
        var latArray: [Double] = []
        var lonArray: [Double] = []
        var dateArray: [String] = []
        
        if let user = Auth.auth().currentUser {
            Firestore.firestore().collection("users/\(user.uid)/colors").order(by: "date", descending: true).getDocuments(completion: { [self] collection, error in
                if let error = error{
                    print(error)
                }else{
                    for document in collection!.documents{
                        guard let colorCode = document.get("color") as? String else { return }
                        self.color = UIColor.hex(string: colorCode , alpha: 1.0)
                        colorArray.append(self.color)
                        colorCodeArray.append(colorCode)
                        print(colorArray)
                        let imageURL = URL(string: document.get("image") as! String)
                        let d = NSData(contentsOf: imageURL!)
                        let image = UIImage(data: d! as Data)!
                        imageArray.append(image)
                        let lat = document.get("lat") as! Double
                        latArray.append(lat)
                        let lon = document.get("lon") as! Double
                        lonArray.append(lon)
                        let timeStamp = document.get("date") as! Timestamp
                        let dates: Date = timeStamp.dateValue()
                        let dateFormatter = DateFormatter()
                        dateFormatter.locale = Locale(identifier: "ja_JP")
                        dateFormatter.dateStyle = .medium
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        dateArray.append(dateFormatter.string(from: dates))
                    }
                    self.colorArray = colorArray
                    self.colorCodeArray = colorCodeArray
                    self.imageArray = imageArray
                    self.latArray = latArray
                    self.lonArray = lonArray
                    self.dateArray = dateArray
                }
            })
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return colorArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得する
        let cell = tableView.dequeueReusableCell(withIdentifier: "PaletteCell", for: indexPath) as! PaletteTableViewCell
        
        // セルに表示する値を設定する
        cell.selectionStyle = .none
        cell.colorView.backgroundColor = colorArray[indexPath.row]
        cell.View.layer.cornerRadius = 15
        cell.shadowView.layer.cornerRadius = 15
        cell.shadowView.layer.shadowColor = UIColor.black.cgColor //影の色を決める
        cell.shadowView.layer.shadowOpacity = 0.15//影の色の透明度
        cell.shadowView.layer.shadowRadius = 4 //影のぼかし
        cell.shadowView.layer.shadowOffset = CGSize(width: 0, height: 4)
        cell.label.text = "#" + colorCodeArray[indexPath.row]
        cell.RGBlabel.text = "R:\(UIColor.hex(string: colorCodeArray[indexPath.row], alpha: 1).red()) " + "G:\(UIColor.hex(string: colorCodeArray[indexPath.row], alpha: 1).green()) " + "B:\(UIColor.hex(string: colorCodeArray[indexPath.row], alpha: 1).blue())"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
        self.performSegue(withIdentifier: "toDetailVC", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailVC" {
            let detailVC = segue.destination as? DetailViewController
            detailVC?.image = imageArray[index]
            detailVC?.color = colorArray[index]
            detailVC?.colorCode = colorCodeArray[index]
            detailVC?.lat = latArray[index]
            detailVC?.lon = lonArray[index]
            detailVC?.date = dateArray[index]
            
        }
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
