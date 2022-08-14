//
//  GMSMaker+Ex.swift
//  Original
//
//  Created by 張翔 on 2022/08/14.
//

import Foundation
import GoogleMaps


extension GMSMarker {
    
    static func markerImage(with strokeColor: UIColor, center centerColor: UIColor) -> UIImage {
        let originalMarkerimage = GMSMarker.markerImage(with: strokeColor)
        UIGraphicsBeginImageContext(originalMarkerimage.size)
        originalMarkerimage.draw(at: .zero)
        let context = UIGraphicsGetCurrentContext()
        centerColor.setFill()
        var circleRect = CGRect(x: 0, y: -7.68, width: originalMarkerimage.size.width, height: originalMarkerimage.size.height)
        circleRect = circleRect.insetBy(dx: 9.8, dy: 17.3)
        context?.fillEllipse(in: circleRect)
        
        let finalMerkerImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return finalMerkerImage!
    }
}
