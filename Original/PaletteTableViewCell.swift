//
//  PaletteTableViewCell.swift
//  Original
//
//  Created by 神林沙希 on 5/8/22.
//

import UIKit

class PaletteTableViewCell: UITableViewCell {
    
    @IBOutlet var colorView: UIView!
    @IBOutlet var label: UILabel!
    @IBOutlet var RGBlabel: UILabel!
    @IBOutlet var View: UIView!
    
    
//    required init?(coder: NSCoder) {
//        colorView.layer.cornerRadius = 30
//        colorView.layer.shadowColor = UIColor.black.cgColor //影の色を決める
//        colorView.layer.shadowOpacity = 1 //影の色の透明度
//        colorView.layer.shadowRadius = 8 //影のぼかし
//        colorView.layer.shadowOffset = CGSize(width: 4, height: 4)
//        fatalError("init(coder:) has not been implemented")
//    }
//    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
