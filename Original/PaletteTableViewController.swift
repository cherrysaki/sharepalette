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

    var colorArray: [UIColor] = []
    var dateArray: [String] = []
    
    var data: Dictionary<String, Any> = [:]
    var isMyLocation = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 80
        tableView.register(UINib(nibName: "PaletteTableViewCell", bundle: nil), forCellReuseIdentifier: "PaletteCell")
        
        if let user = Auth.auth().currentUser {
            Firestore.firestore().collection("users/\(user.uid)/colors")
                .addSnapshotListener { [self] querySnapshot, error in
                    guard let snapshot = querySnapshot else {
                        print("Error fetching snapshots: \(error!)")
                        return
                    }
                    snapshot.documentChanges.forEach { diff in
                        //データを取得
                        //snapshotのデータをcolorArray,dateArrayにいれたい
                        //https://re-engines.com/2020/01/09/ios%E3%81%A7firestore%E3%82%92%E4%BD%BF%E3%81%A3%E3%81%A6%E3%81%BF%E3%81%9F%E3%80%80%E3%81%9D%E3%81%AE2/
                    }
                }
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
        cell.label.text = "sample"
        
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
