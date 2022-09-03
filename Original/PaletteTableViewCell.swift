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
    @IBOutlet var shadowView:UIView!
    
   
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
