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
    
    var color: UIColor = UIColor()
    
    var data: Dictionary<String, Any> = [:]
    var isMyLocation = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 80
        tableView.register(UINib(nibName: "PaletteTableViewCell", bundle: nil), forCellReuseIdentifier: "PaletteCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        colorArray = []
        getFirebasedocuments()
    }
    
 
    
    
    func getFirebasedocuments() {
        var testArray: [UIColor] = []
        var testcodeArray: [String] = []
        
        if let user = Auth.auth().currentUser {
            Firestore.firestore().collection("users/\(user.uid)/colors").getDocuments(completion: { [self] collection, error in
                if let error = error{
                    print(error)
                }else{
                    for document in collection!.documents{
                        guard let colorCode = document.get("color") as? String else { return }
                        self.color = UIColor.hex(string: colorCode , alpha: 1.0)
                        testArray.append(self.color)
                        testcodeArray.append(colorCode)
                        print(testArray)
                    }
                    colorArray = testArray
                    colorCodeArray = testcodeArray
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
        cell.colorView.backgroundColor = colorArray[indexPath.row]
        cell.View.layer.cornerRadius = 3
        cell.View.layer.cornerRadius = 30
        cell.View.layer.shadowColor = UIColor.black.cgColor //影の色を決める
        cell.View.layer.shadowOpacity = 0.25//影の色の透明度
        cell.View.layer.shadowRadius = 4 //影のぼかし
        cell.View.layer.shadowOffset = CGSize(width: 0, height: 4)
        cell.label.text = "#" + colorCodeArray[indexPath.row]
        cell.RGBlabel.text = "R:\(UIColor.hex(string: colorCodeArray[indexPath.row], alpha: 1).red()) " + "G:\(UIColor.hex(string: colorCodeArray[indexPath.row], alpha: 1).green()) " + "B:\(UIColor.hex(string: colorCodeArray[indexPath.row], alpha: 1).blue())"
        
        return cell
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
