//
//  DetailViewController.swift
//  Original
//
//  Created by 神林沙希 on 2022/07/08.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var colorView: UIView!
    @IBOutlet var colorLabel: UILabel!
    
    var image: UIImage = UIImage()
    var color: UIColor = UIColor()
    var colorCode: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
        colorView.backgroundColor = color
        colorLabel.text = colorCode
        
        // Do any additional setup after loading the view.
    }
    
    
}
